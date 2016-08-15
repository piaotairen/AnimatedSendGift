//
//  LSGiftDisplayView.m
//  Radar.TV
//
//  Created by Cobb on 16/6/13.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import "LSGiftDisplayView.h"
#import "LSGiftDisplayItem.h"

@interface LSGiftDisplayView ()

@property (nonatomic,readwrite,strong) NSMutableArray *displayViewsUpArray;//复用池保存上方出现的视图

@property (nonatomic,readwrite,strong) NSMutableArray *displayViewsBottomArray;//复用池保存下方出现的视图

@property (nonatomic,readwrite,strong) LSGiftDisplayItem *upGiftDisplayItem;//上方正在显示的视图

@property (nonatomic,readwrite,strong) LSGiftDisplayItem *downGiftDisplayItem;//下方正在显示的视图

@property (nonatomic,readwrite,assign) NSTimeInterval fadeInAnimationDuration;//动画显示时间

@property (nonatomic,readwrite,assign) NSTimeInterval fadeOutAnimationDuration;//动画隐藏时间

@property (nonatomic,readwrite,assign) BOOL *isUpShow;//上方是否显示

@property (nonatomic,readwrite,assign) BOOL *isDownShow;//下方是否显示

@end

@implementation LSGiftDisplayView

#pragma mark - 实例化
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self customInitial];
    return self;
    
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self customInitial];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self customInitial];
    return self;
}
/**
 * @brief 自定义配置
 */
- (void)customInitial
{
    self.backgroundColor = [UIColor clearColor];
    self.displayViewsUpArray = [NSMutableArray array];
    self.displayViewsBottomArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        LSGiftDisplayItem *reusedItemUp = [[LSGiftDisplayItem alloc]init];
        reusedItemUp.frame = CGRectMake(-kLSGiftDisplayItemWidth, 5, kLSGiftDisplayItemWidth,kLSGiftDisplayItemHeight);
        [self.displayViewsUpArray addObject:reusedItemUp];
        
        LSGiftDisplayItem *reusedItemBottom = [[LSGiftDisplayItem alloc]init];
        reusedItemBottom.frame = CGRectMake(-kLSGiftDisplayItemWidth, (kGiftDisplayViewHeight-15)/2+10, kLSGiftDisplayItemWidth, kLSGiftDisplayItemHeight);
        [self.displayViewsBottomArray  addObject:reusedItemBottom];
    }
    self.fadeInAnimationDuration = 0.35;
    self.fadeOutAnimationDuration = 0.2;
}
#pragma mark - 复用池取出视图
/**
 * @brief 取出上方视图
 */
- (LSGiftDisplayItem *)upGiftDisplayItemFromReuseArray
{
    for (LSGiftDisplayItem *item in self.displayViewsUpArray) {
        if (item.isReadyToMove) {
            return item;
        }
    }
    return nil;
}
/**
 * @brief 取出下方视图
 */
- (LSGiftDisplayItem *)downGiftDisplayItemFromReuseArray
{
    for (LSGiftDisplayItem *item in self.displayViewsBottomArray) {
        if (item.isReadyToMove) {
            return item;
        }
    }
    return nil;
}
#pragma mark - 动画设计
/**
 * @brief 左侧抽屉显示
 */
- (void)animatedShowFromLeft
{
    self.upGiftDisplayItem = [self upGiftDisplayItemFromReuseArray];
    [self addSubview:self.upGiftDisplayItem];
    
    [UIView animateWithDuration:self.fadeInAnimationDuration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        self.upGiftDisplayItem.transform =  CGAffineTransformMakeTranslation(kLSGiftDisplayItemWidth, 0);
    } completion:^(BOOL finished) {
    }];
    
    
//    [CATransaction begin];
//    self.upGiftDisplayItem.isAnimatedMoving = YES;
    
//    //弹簧动画
//    CASpringAnimation *springAnimation = [CASpringAnimation animation];
//    springAnimation.duration = self.fadeInAnimationDuration;
//    springAnimation.damping = 0.35;
//    springAnimation.initialVelocity = 1.0/0.55;
//    springAnimation.stiffness = 100;
//    springAnimation.mass = 1;
//    springAnimation.keyPath = @"transform.translation.x";
//    springAnimation.toValue = @(100);
//    springAnimation.removedOnCompletion = NO;
//    springAnimation.fillMode = kCAFillModeForwards;
    
    // 组动画
//    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
//    groupAnima.duration = 0.35;
//    groupAnima.animations = @[springAnimation];
//    groupAnima.removedOnCompletion = NO;
//    [self.upGiftDisplayItem.layer addAnimation:springAnimation forKey:nil];
    
//    [CATransaction commit];
//    [CATransaction setCompletionBlock:^(){
//        self.upGiftDisplayItem.isFinishMoving = YES;
////        [self dimissFromScreen];
//    }];
    
//    // 平移动画
//    CABasicAnimation *a1 = [CABasicAnimation animation];
//    a1.keyPath = @"transform.translation.x";
//    a1.toValue = @(100);
//    
//    // 缩放动画
//    CABasicAnimation *a2 = [CABasicAnimation animation];
//    a2.keyPath = @"transform.scale";
//    a2.toValue = @(0.0);
//    // 旋转动画
//    CABasicAnimation *a3 = [CABasicAnimation animation];
//    a3.keyPath = @"transform.rotation";
//    a3.toValue = @(M_PI_2);
    
//    // 组动画
//    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
//    groupAnima.animations = @[a1, a2, a3];
//    
//    //设置组动画的时间
//    groupAnima.duration = 2;
//    groupAnima.fillMode = kCAFillModeForwards;
//    groupAnima.removedOnCompletion = NO;
//    
//    [self.iconView.layer addAnimation:groupAnima forKey:nil];
}
/**
 * @brief 显示完成后隐藏
 */
- (void)dimissFromScreen
{
    [UIView animateWithDuration:self.fadeOutAnimationDuration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
        self.upGiftDisplayItem.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.upGiftDisplayItem removeFromSuperview];
        self.upGiftDisplayItem.isReadyToMove = YES;
    }];
}


@end
