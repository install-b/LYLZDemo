//
//  LYLZChatManager+Private.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/6.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#ifndef LYLZChatManager_Private_h
#define LYLZChatManager_Private_h
#import "LYLZChatManager.h"
#import "LYLZSDK.h"

#define _instanceSDK [LYLZSDK sharedSDK]


@interface LYLZChatManager () <LYTSDKChatManagerDelegate,LYTSDKDelegate>

/**
 系统消息ID
 */
@property (nonatomic, copy, readonly) NSString * systemNotiId;

/**
 互动消息ID
 */
@property (nonatomic, copy, readonly) NSString *interactiveNotiId;

/**
 评论消息ID
 */
@property (nonatomic, copy, readonly) NSString *commentNotiId;

/**
 金额红包
 */
- (NSArray <NSCopying>*)normalAmountOfPacketToLawyer:(NSString *)lawyer;

/**
 发红包
 */
- (void)sendRedPacket:(id)packetInfo toLawyer:(NSString *)lawyer;

/**
 获取用户体系
 */
- (id <LYTUserBaseInfoProtocol>)userInfoWithUserId:(NSString *)userId;

/**
 未读数
 */
@property(nonatomic,assign) NSInteger unreadCount;

/**
 当前用户
 */
@property (nonatomic,strong) id <LYTUserBaseInfoProtocol> currentUser;


/**
 当前登录的用户ID
 */
@property (nonatomic, copy, readonly) NSString *currentUserId;


/**
是否展示评论、互动消息栏
 */
@property (nonatomic, assign,readonly,getter=isShowCMTandInterMessage) BOOL showCMTandInterMessage;

@end

#endif /* LYLZChatManager_Private_h */
