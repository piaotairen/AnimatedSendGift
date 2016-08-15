//
//  LSGiftFIFOManager.m
//  AnimatedSendGift
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import "LSGiftFIFOManager.h"
#import "LSGiftDisplayInfo.h"
#import "LSGiftMessageOperation.h"

@interface LSGiftFIFOManager ()

@property (nonatomic,readwrite,strong) NSMutableArray *giftMessageQueue;//礼物消息池子

@end

@implementation LSGiftFIFOManager

static dispatch_queue_t _concurrentQueue;

#pragma mark - 获取实例
+ (instancetype)manager
{
    static dispatch_once_t once;
    static LSGiftFIFOManager *manager;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
        [manager initialSettings];
    });
    return manager;
}
/**
 * @brief 初始化设置
 */
- (void)initialSettings
{
    self.giftMessageQueue = [NSMutableArray array];
    self.operationQueue = [[NSOperationQueue alloc]init];
    _concurrentQueue = dispatch_queue_create("com.FIFO.syncQueue", DISPATCH_QUEUE_CONCURRENT);
}

#pragma mark - 对礼物消息池子操作
/**
 * @brief 保存礼物消息
 */
- (void)saveGiftMessage:(NSString *)giftMessage
{
    [self saveGiftMessage:giftMessage success:^(LSGiftMessageOperation *operation, id MessageInfo){
        [self.giftMessageQueue addObject:giftMessage];
        NSLog(@"addObject success");
    }];
}
/**
 * @brief 保存消息到池子里
 * @param giftMessage 消息模型
 * @param success 完成后回调
 */
- (void)saveGiftMessage:(NSString *)giftMessage
                success:(void (^)(LSGiftMessageOperation *operation, id MessageInfo))success
{
    LSGiftMessageOperation *operation = [[LSGiftMessageOperation alloc]initWithMessage:@"测试礼物信息"];
    [operation setCompletionBlockWithSuccess:success];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    [self.operationQueue addOperation:operation];
}

/**
 * @brief 获取排在最前面的消息
 */
- (void)popFirstMessageWithCompletion:(void (^)(LSGiftDisplayInfo *info))completion
{
    //栅栏控制消息数组操作
    __weak __typeof(self)weakSelf = self;
    dispatch_barrier_async(_concurrentQueue,^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.giftMessageQueue.count > 0){
            LSGiftDisplayInfo *info = strongSelf.giftMessageQueue[0];
            [strongSelf.giftMessageQueue removeObjectAtIndex:0];
            completion(info);
        }else{
            completion(nil);
        }
    });
}

/**
 * @brief 获取排在最前面的两条消息
 */
- (void)popFirstTwoMessgesWithCompletion:(void (^)(NSArray *messages))completion
{
    __weak __typeof(self)weakSelf = self;
    dispatch_barrier_async(_concurrentQueue,^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (strongSelf.giftMessageQueue.count > 1){
            NSMutableArray *copyMessages = [NSMutableArray array];
            [copyMessages addObject:strongSelf.giftMessageQueue[0]];
            [strongSelf.giftMessageQueue removeObjectAtIndex:0];
            [copyMessages addObject:strongSelf.giftMessageQueue[0]];
            [strongSelf.giftMessageQueue removeObjectAtIndex:0];
            completion([copyMessages copy]);
        }else{
            completion(nil);
        }
    });
}


@end
