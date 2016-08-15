//
//  LSGiftDisplayView.h
//  Radar.TV
//
//  Created by Cobb on 16/6/13.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LSUserInfoData;

// 礼物视图高
static const CGFloat kGiftDisplayViewHeight = 100.f;
// 礼物视图宽
static const CGFloat kGiftDisplayViewWidth = 250;

/**
 * 直播中礼物展示区域
 */
@interface LSGiftDisplayView : UIView

/**
 * @brief 左侧抽屉显示
 */
- (void)animatedShowFromLeft;
/**
 * @brief 显示完成后隐藏
 */
- (void)dimissFromScreen;

@end
