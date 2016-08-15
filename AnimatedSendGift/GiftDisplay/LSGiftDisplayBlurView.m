//
//  LSGiftDisplayBlurView.m
//  Radar.TV
//
//  Created by Cobb on 16/6/15.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import "LSGiftDisplayBlurView.h"

@implementation LSGiftDisplayBlurView

/**
 * @brief 绘制后使用此方法实例化
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


/**
 * @brief 绘制自定义形状的毛玻璃视图
 */
- (void)drawRect:(CGRect)rect {
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画半个圆
    CGContextSetRGBStrokeColor(context,0,0,0,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, 0.0);//线的宽度
    UIColor *fillColor = [UIColor colorWithWhite:0.5 alpha:0.6];
    CGContextSetFillColorWithColor(context, fillColor.CGColor);//填充颜色
    CGContextAddArc(context, 40, 40, 40, M_PI/2, M_PI*3/2, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathEOFill); //绘制路径
    
    //上边线
    CGPoint upLinePoints[2];//坐标点
    upLinePoints[0] =CGPointMake(40, 0);//坐标1
    upLinePoints[1] =CGPointMake(140, 0);//坐标2
    CGContextAddLines(context, upLinePoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //画右边扇形
    CGContextAddArc(context, 140, 80, 80, M_PI*2-M_PI/24, M_PI*3/2, 1); //添加一个圆
    CGContextDrawPath(context, kCGPathEOFillStroke); //绘制路径
    
    //右下角
    CGContextMoveToPoint(context, 220, 80-10);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, 220, 80, 220-10, 80, 5);  // 右下角角度
    CGContextDrawPath(context, kCGPathEOFillStroke); //根据坐标绘制路径
    
    //下边线
    CGPoint downLinePoints[2];//坐标点
    downLinePoints[0] =CGPointMake(220-5, 80);//坐标1
    downLinePoints[1] =CGPointMake(40, 80);//坐标2
    CGContextAddLines(context, downLinePoints, 2);//添加线
    CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
    
    //填充中间多边形颜色
    CGContextSetRGBStrokeColor(context,0,0,0,1.0);//重设画笔线的颜色
    CGContextSetLineWidth(context, 0.0);//线的宽度
    CGContextMoveToPoint(context, 220, 80-10);  // 开始坐标右边开始
    CGContextAddArcToPoint(context, 220-5, 80, 40, 80, 0);  // 右下角角度
    CGContextAddArcToPoint(context, 40, 80, 40, 0, 0); // 左下角角度
    CGContextAddArcToPoint(context, 40, 0, 140, 0, 0); // 左上角
    CGContextAddArcToPoint(context, 140, 0, 220, 80-10, 0); // 左上角
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}


@end
