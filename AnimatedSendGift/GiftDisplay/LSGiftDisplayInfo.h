//
//  LSGiftDisplayInfo.h
//  Radar.TV
//
//  Created by Cobb on 16/6/13.
//  Copyright © 2016年 livestar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 用于展示的礼物的信息模型
 */
@interface LSGiftDisplayInfo : NSObject

/**
 * 礼物发送者昵称
 */
@property (nonatomic,readwrite,copy) NSString *fromNick;
/**
 * 礼物发送者头像
 */
@property (nonatomic,readwrite,copy) NSString *fromAvatar;
/**
 * 礼物发送是否连击
 */
@property (nonatomic,readwrite,assign) BOOL isCombo;
/**
 * 礼物发送时间
 */
@property (nonatomic,readwrite,assign) NSString *time;
/**
 * 发礼物的人当前等级
 */
@property (nonatomic,readwrite,assign) NSString *lvl;
/**
 * 发礼物的人是否升级
 */
@property (nonatomic,readwrite,assign) NSString *upgrade;
/**
 * 发礼物的人的UID
 */
@property (nonatomic,readwrite,assign) NSString *user_id;
/**
 * 礼物ID
 */
@property (nonatomic,readwrite,assign) NSString *gift_id;
/**
 * 礼物名称
 */
@property (nonatomic,readwrite,copy) NSString *gift_name;
/**
 * 礼物数量
 */
@property (nonatomic,readwrite,assign) NSInteger quantity;
/**
 * 主播最新的珍珠数（前端刷新时，取该值和显示的值比较的最大值）
 */
@property (nonatomic,readwrite,assign) NSString *buck;
/**
 * 用户标签，和聊天消息一样处理
 */
@property (nonatomic,readwrite,assign) NSString *user_tag;
/**
 * 发送礼物的文本消息
 */
@property (nonatomic,readwrite,assign) NSString *message;
/**
 * 类型，送礼物消息的type为send_gift
 */
@property (nonatomic,readwrite,assign) NSString *type;

@end
