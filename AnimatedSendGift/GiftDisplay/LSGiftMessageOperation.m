//
//  LSGiftMessageOperation.m
//  AnimatedSendGift
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "LSGiftMessageOperation.h"
#import "LSGiftDisplayInfo.h"

NSString * const LSGiftMessageOperationDidStartNotification = @"LSGiftMessageOperationDidStartNotification";
NSString * const LSGiftMessageOperationDidFinishNotification = @"LSGiftMessageOperationDidFinishNotification";

static NSString * const kOperationLockName = @"kOperationLockName";

typedef NS_ENUM(NSInteger, LSGMOperationState) {
    LSGMOperationPausedState      = -1,
    LSGMOperationReadyState       = 1,
    LSGMOperationExecutingState   = 2,
    LSGMOperationFinishedState    = 3,
};//消息线程操作状态

//获取消息线程操作结束group
static dispatch_group_t message_save_operation_completion_group() {
    static dispatch_group_t ls_message_save_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_message_save_operation_completion_group = dispatch_group_create();
    });
    
    return ls_message_save_operation_completion_group;
}

//获取消息线程操作结束queue
static dispatch_queue_t message_save_operation_completion_queue() {
    static dispatch_queue_t ls_message_save_operation_completion_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_message_save_operation_completion_queue = dispatch_queue_create("com.alamofire.networking.operation.queue", DISPATCH_QUEUE_CONCURRENT );
    });
    
    return ls_message_save_operation_completion_queue;
}

//completionblock设置的queue
static dispatch_queue_t ls_operation_processing_queue() {
    static dispatch_queue_t ls_completionblock_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_completionblock_operation_processing_queue = dispatch_queue_create("com.alamofire.networking.http-request.processing", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return ls_completionblock_operation_processing_queue;
}
//completionblock设置的group
static dispatch_group_t ls_operation_completion_group() {
    static dispatch_group_t ls_completionblock_operation_completion_group;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_completionblock_operation_completion_group = dispatch_group_create();
    });
    
    return ls_completionblock_operation_completion_group;
}

/**
 * @method 设置operation的状态
 */
static inline NSString * AFKeyPathFromOperationState(LSGMOperationState state) {
    switch (state) {
        case LSGMOperationReadyState:
            return @"isReady";
        case LSGMOperationExecutingState:
            return @"isExecuting";
        case LSGMOperationFinishedState:
            return @"isFinished";
        case LSGMOperationPausedState:
            return @"isPaused";
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            return @"state";
#pragma clang diagnostic pop
        }
    }
}

static inline BOOL AFStateTransitionIsValid(LSGMOperationState fromState, LSGMOperationState toState, BOOL isCancelled) {
    switch (fromState) {
        case LSGMOperationReadyState:
            switch (toState) {
                case LSGMOperationPausedState:
                case LSGMOperationExecutingState:
                    return YES;
                case LSGMOperationFinishedState:
                    return isCancelled;
                default:
                    return NO;
            }
        case LSGMOperationExecutingState:
            switch (toState) {
                case LSGMOperationPausedState:
                case LSGMOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        case LSGMOperationFinishedState:
            return NO;
        case LSGMOperationPausedState:
            return toState == LSGMOperationReadyState;
        default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
            switch (toState) {
                case LSGMOperationPausedState:
                case LSGMOperationReadyState:
                case LSGMOperationExecutingState:
                case LSGMOperationFinishedState:
                    return YES;
                default:
                    return NO;
            }
        }
#pragma clang diagnostic pop
    }
}

#pragma mark - LSGiftMessageOperation
@interface LSGiftMessageOperation ()

@property (readwrite, nonatomic, assign) LSGMOperationState state;//operation的状态

@property (nonatomic,readwrite,strong) NSString *message;//消息信息

@property (nonatomic,readwrite,strong) NSRecursiveLock *lock;//锁

@property (nonatomic,readwrite,strong) LSGiftDisplayInfo *saveMessageInfo;//保存的消息

@end

@implementation LSGiftMessageOperation

/**
 * @brief 线程入口 开启runloop
 */
+ (void)saveMessageThreadEntryPoint:(id)__unused object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"Save Gift Message"];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
/**
 * @brief 获取保存礼物消息的线程
 */
+ (NSThread *)savemessageThread {
    static NSThread *_savemessageThread = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _savemessageThread = [[NSThread alloc] initWithTarget:self selector:@selector(saveMessageThreadEntryPoint:) object:nil];
        [_savemessageThread start];
    });
    
    return _savemessageThread;
}


#pragma mark - 实例化
/**
 * @brief 实例化
 * @param message 消息信息
 */
- (instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _state = LSGMOperationReadyState;
    
    self.lock = [[NSRecursiveLock alloc] init];
    self.lock.name = kOperationLockName;
    self.runLoopModes = [NSSet setWithObject:NSRunLoopCommonModes];
    
    self.message = message;
    
    return self;
}
#pragma mark - NSOperation
/**
 * @brief 设置自定义的完成回调
 */
- (void)setCompletionBlockWithSuccess:(void (^)(LSGiftMessageOperation *operation, id message))success
{
    // completionBlock is manually nilled out in AFURLConnectionOperation to break the retain cycle.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
#pragma clang diagnostic ignored "-Wgnu"
    self.completionBlock = ^{
        if (self.completionGroup) {
            dispatch_group_enter(self.completionGroup);
        }
        
        dispatch_async(ls_operation_processing_queue(), ^{
            id saveMessageInfo = self.saveMessageInfo;
            if (success) {
                dispatch_group_async(self.completionGroup ?: ls_operation_completion_group(), self.completionQueue ?: dispatch_get_main_queue(), ^{
                    success(self, saveMessageInfo);
                });
            }
            if (self.completionGroup) {
                dispatch_group_leave(self.completionGroup);
            }
        });
    };
#pragma clang diagnostic pop
}
/**
 * @brief 设置结束回调
 */
- (void)setCompletionBlock:(void (^)(void))block {
    [self.lock lock];
    if (!block) {
        [super setCompletionBlock:nil];
    } else {
        __weak __typeof(self)weakSelf = self;
        [super setCompletionBlock:^ {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            
            dispatch_group_t group = strongSelf.completionGroup ?: message_save_operation_completion_group();
            dispatch_queue_t queue = strongSelf.completionQueue ?: dispatch_get_main_queue();
            dispatch_group_async(group, queue, ^{
                block();
            });
            
            dispatch_group_notify(group, message_save_operation_completion_queue(), ^{
                [strongSelf setCompletionBlock:nil];
            });
        }];
    }
    [self.lock unlock];
}

#pragma mark - 获取任务状态
- (BOOL)isReady {
    return self.state == LSGMOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
    return self.state == LSGMOperationExecutingState;
}

- (BOOL)isFinished {
    return self.state == LSGMOperationFinishedState;
}

- (BOOL)isConcurrent {
    return YES;
}

/**
 * 重写start方法
 */
- (void)start
{
    [self.lock lock];
    if ([self isCancelled]) {
        [self performSelector:@selector(cancelConnection) onThread:[[self class] savemessageThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    } else if ([self isReady]) {
        self.state = LSGMOperationExecutingState;
        
        [self performSelector:@selector(operationDidStart) onThread:[[self class] savemessageThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
    }
    [self.lock unlock];
}
/**
 * @brief 任务开启方法
 */
- (void)operationDidStart {
    [self.lock lock];
    if (![self isCancelled]) {
        self.saveMessageInfo = [[LSGiftDisplayInfo alloc]init];
        NSLog(@"self.saveMessageInfo is %p",self.saveMessageInfo);
        [self finish];//任务结束调用以执行回调CompletionBlock
    }
    [self.lock unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LSGiftMessageOperationDidStartNotification object:self];
    });
}
/**
 * @brief 任务结束
 */
- (void)finish {
    [self.lock lock];
    self.state = LSGMOperationFinishedState;
    [self.lock unlock];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:LSGiftMessageOperationDidFinishNotification object:self];
    });
}
/**
 * @brief 任务取消
 */
- (void)cancel {
    [self.lock lock];
    if (![self isFinished] && ![self isCancelled]) {
        [super cancel];
        
        if ([self isExecuting]) {
            [self performSelector:@selector(cancelConnection) onThread:[[self class] savemessageThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        }
    }
    [self.lock unlock];
}
/**
 * @brief 取消消息存储
 */
- (void)cancelConnection {
    if (![self isFinished]) {
        if (self.saveMessageInfo) {
            self.saveMessageInfo = nil;
        } else {
            [self finish];
        }
    }
}
#pragma mark -  任务管理
/**
 * @brief 设置任务状态
 */
- (void)setState:(LSGMOperationState)state {
    if (!AFStateTransitionIsValid(self.state, state, [self isCancelled])) {
        return;
    }
    
    [self.lock lock];
    NSString *oldStateKey = AFKeyPathFromOperationState(self.state);
    NSString *newStateKey = AFKeyPathFromOperationState(state);
    
    [self willChangeValueForKey:newStateKey];
    [self willChangeValueForKey:oldStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
    [self.lock unlock];
}
/**
 * @brief 暂停
 */
- (void)pause {
    if ([self isPaused] || [self isFinished] || [self isCancelled]) {
        return;
    }
    
    [self.lock lock];
    if ([self isExecuting]) {
        [self performSelector:@selector(operationDidPause) onThread:[[self class] savemessageThread] withObject:nil waitUntilDone:NO modes:[self.runLoopModes allObjects]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:LSGiftMessageOperationDidFinishNotification object:self];
        });
    }
    
    self.state = LSGMOperationPausedState;
    [self.lock unlock];
}
/**
 * @brief 任务暂停方法
 */
- (void)operationDidPause {
    [self.lock lock];
    
    [self.lock unlock];
}
/**
 * @brief 任务是否暂停
 */
- (BOOL)isPaused {
    return self.state == LSGMOperationPausedState;
}

/**
 * @brief 任务重启
 */
- (void)resume {
    if (![self isPaused]) {
        return;
    }
    
    [self.lock lock];
    self.state = LSGMOperationReadyState;
    
    [self start];
    [self.lock unlock];
}

@end
