//
//  LSGiftDisplayItem.m
//  Radar.TV
//
//  Created by Cobb on 16/6/13.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import "LSGiftDisplayItem.h"
#import "LSGiftDisplayBlurView.h"
#import "Masonry.h"

@interface LSGiftDisplayItem ()

/**
 * 底部的blur毛玻璃视图
 */
@property (nonatomic,readwrite,strong) LSGiftDisplayBlurView *blurView;
/**
 * 发送礼物用户头像
 */
@property (nonatomic,readwrite,strong) UIImageView *portraitImageView;
/**
 * 发送礼物用户昵称
 */
@property (nonatomic,readwrite,strong) UILabel *nickNameLabel;
/**
 * 发送礼物名称
 */
@property (nonatomic,readwrite,strong) UILabel *giftNameLabel;
/**
 * 礼物图标
 */
@property (nonatomic,readwrite,strong) UIImageView *giftImageView;
/**
 * 发送礼物combo连击数
 */
@property (nonatomic,readwrite,strong) UILabel *giftComboLabel;

@end

@implementation LSGiftDisplayItem

#pragma mark - 实例化
- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self loadCustomViews];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self loadCustomViews];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    [self loadCustomViews];
    return self;
}
/**
 * @brief 加载自定义视图
 */
- (void)loadCustomViews
{
    self.backgroundColor = [UIColor clearColor];
    self.isReadyToMove = YES;
    
    //加载子视图
    self.blurView =  ({
        _blurView = [[LSGiftDisplayBlurView alloc]init];
        _blurView.backgroundColor = [UIColor clearColor];
        _blurView;
    });//发送礼物用户头像
    
    self.portraitImageView = ({
        _portraitImageView = [[UIImageView alloc]init];
        _portraitImageView.backgroundColor = [UIColor clearColor];
        _portraitImageView;
    });//发送礼物用户头像
    
    self.nickNameLabel = ({
        _nickNameLabel = [[UILabel alloc]init];
        _nickNameLabel.backgroundColor = [UIColor clearColor];
        _nickNameLabel.textColor = [UIColor whiteColor];
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel;
    });//发送礼物用户昵称
    
    self.giftNameLabel = ({
        _giftNameLabel = [[UILabel alloc]init];
        _giftNameLabel.backgroundColor = [UIColor clearColor];
        _giftNameLabel.textColor = [UIColor whiteColor];
        _giftNameLabel.textAlignment = NSTextAlignmentCenter;
        _giftNameLabel;
    });//发送礼物名称
    
    self.giftImageView = ({
        _giftImageView = [[UIImageView alloc]init];
        _giftImageView.backgroundColor = [UIColor clearColor];
        _giftImageView;
    });//礼物图标
    
    self.giftComboLabel = ({
        _giftComboLabel = [[UILabel alloc]init];
        _giftComboLabel.backgroundColor = [UIColor clearColor];
        _giftComboLabel;
    });//发送礼物combo连击数
    
    [self addSubview:self.blurView];
    [self addSubview:self.portraitImageView];
    [self addSubview:self.nickNameLabel];
    [self addSubview:self.giftNameLabel];
    [self addSubview:self.giftImageView];
    [self addSubview:self.giftComboLabel];
    
    [self setNeedsUpdateConstraints];
}
#pragma mark - 约束
/**
 * @breif 更新约束
 */
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_blurView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.width.mas_equalTo(kLSGiftDisplayItemWidth);
        make.height.mas_equalTo(kLSGiftDisplayItemHeight);
    }];
    
    [_portraitImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(4);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.portraitImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.mas_top).offset(4);
        make.height.mas_equalTo(15);
    }];
    
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.portraitImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(0);
        make.top.equalTo(self.nickNameLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(15);
    }];
}

@end
