//
//  LSGiftFIFOManager.h
//  AnimatedSendGift
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 Cobb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LSGiftMessageOperation;
@class LSGiftDisplayInfo;

@interface LSGiftFIFOManager : NSObject

/**
 The dispatch queue for the `completionBlock` of request operations. If `NULL` (default), the main queue is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_queue_t completionQueue;
#else
@property (nonatomic, assign) dispatch_queue_t completionQueue;
#endif

/**
 The dispatch group for the `completionBlock` of request operations. If `NULL` (default), a private dispatch group is used.
 */
#if OS_OBJECT_HAVE_OBJC_SUPPORT
@property (nonatomic, strong) dispatch_group_t completionGroup;
#else
@property (nonatomic, assign) dispatch_group_t completionGroup;
#endif

//线程池
@property (nonatomic, strong) NSOperationQueue *operationQueue;

/**
 * @brief 获取实例
 */
+ (instancetype)manager;
/**
 * @brief 保存礼物消息
 */
- (void)saveGiftMessage:(NSString *)giftMessage;
/**
 * @brief 获取排在最前面的消息
 */
- (void)popFirstMessageWithCompletion:(void (^)(LSGiftDisplayInfo *info))completion;
/**
 * @brief 获取排在最前面的两条消息
 */
- (void)popFirstTwoMessgesWithCompletion:(void (^)(NSArray *messages))completion;

@end
