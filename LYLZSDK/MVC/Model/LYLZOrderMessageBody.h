//
//  LYLZOrderMessageBody.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZmessageBody.h"

@interface LYLZOrderMessageBody : LYLZmessageBody
//{
//    "title":"这是一个转账消息",
//    "bodyMsg":"支付完成，请查收",
//    "tailMsg":"立即前往",
//    "jumpMsg":"跳转消息"
//}

/** title */
@property (nonatomic, copy) NSString *title;

/** jumpMsg */
@property (nonatomic, copy) NSString *jumpMsg;

@end
