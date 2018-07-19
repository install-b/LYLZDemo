//
//  LYLZmessageBody.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
// 消息类型
typedef NS_ENUM(NSUInteger,LYLZmessageBodyType) {
    LYLZmessageBodyTypeOrder        = 3997, // 订单
    LYLZmessageBodyTypeRedPacket    = 3998, // 红包
    LYLZmessageBodyTypeSystem       = 3999, // 系统
};



@interface LYLZmessageBody : NSObject
/*
 {
 "title":"这是一个转账消息",
 "bodyMsg":"支付完成，请查收",
 "tailMsg":"立即前往",
 "jumpMsg":"跳转消息"
 }
 
 {
 "bodyMsg":"您向对方发了一个红包",
 "tailMsg":"￥5.00元",
 "imageUrl":"www.71ant.com/fdf.png"
 }
 */
- (instancetype)initWithContent:(id)content;

/** 消息类型 */
@property(nonatomic,assign) LYLZmessageBodyType messageType ;

/** tailMsg */
@property (nonatomic,copy)NSString * tailMsg;

/** bodyMsg */
@property (nonatomic,copy)NSString * bodyMsg;


@end
