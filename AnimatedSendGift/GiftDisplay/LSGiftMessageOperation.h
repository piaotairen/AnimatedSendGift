//
//  LSGiftMessageOperation.h
//  AnimatedSendGift
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSGiftMessageOperation : NSOperation

/**
 The run loop modes in which the operation will run on the network thread. By default, this is a single-member set containing `NSRunLoopCommonModes`.
 */
@property (nonatomic, strong) NSSet *runLoopModes;

@property (nonatomic,readonly,strong) NSString *message;//消息信息

/**
 The dispatch queue for `completionBlock`. If `NULL` (default), the main queue is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

/**
 The dispatch group for `completionBlock`. If `NULL` (default), a private dispatch group is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_group_t completionGroup;
#else
@property (nonatomic, assign) dispatch_group_t completionGroup;
#endif

/**
 * @brief 实例化
 * @param message 消息信息
 */
- (instancetype)initWithMessage:(NSString *)message;

///----------------------------------
/// @name Pausing / Resuming task
///----------------------------------

/**
 * @brief 暂停消息存储，直到resume 获取取消任务
 */
- (void)pause;

/**
 * @return `YES` 存储暂停
 */
- (BOOL)isPaused;

/**
 * @brief 重启暂停的任务
 */
- (void)resume;

/**
 * @brief 设置结束回调
 */
- (void)setCompletionBlockWithSuccess:(void (^)(LSGiftMessageOperation *operation, id message))success;

@end


///--------------------
/// @name Notifications
///--------------------

/**
 Posted when an operation begins executing.
 */
extern NSString * const LSGiftMessageOperationDidStartNotification;

/**
 Posted when an operation finishes.
 */
extern NSString * const LSGiftMessageOperationDidFinishNotification;


