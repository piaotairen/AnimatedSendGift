//
//  LSGiftDisplayItem.h
//  Radar.TV
//
//  Created by Cobb on 16/6/13.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLSGiftDisplayItemWidth 280.f  //视图宽度
#define kLSGiftDisplayItemHeight 80.f  //视图高度

/**
 * 直播中单个静态礼物弹出视图
 */
@interface LSGiftDisplayItem : UIView

/**
 * 礼物图标
 */
@property (nonatomic,readonly,strong) UIImageView *giftImageView;

/**
 * 发送礼物combo连击数
 */
@property (nonatomic,readonly,strong) UILabel *giftComboLabel;

@property (nonatomic,readwrite,assign) BOOL isReadyToMove;//准备移动中

@property (nonatomic,readwrite,assign) BOOL isAnimatedMoving;//动画移动中

@property (nonatomic,readwrite,assign) BOOL isFinishMoving;//移动完成

@end
