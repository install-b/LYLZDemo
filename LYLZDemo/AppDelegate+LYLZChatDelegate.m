//
//  AppDelegate+LYLZChatDelegate.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "AppDelegate+LYLZChatDelegate.h"
#import "LYLZUserInfo.h"
#import "LYLZChatManager.h"

@implementation AppDelegate (LYLZChatDelegate)
/**
 根据用户ID返回 用户信息 回调
 
 @param userId 用户ID
 @return 用户信息
 */
- (id <LYTUserBaseInfoProtocol>)userInfoWithUserId:(NSString *)userId {
    LYLZUserInfo * userInfo = [[LYLZUserInfo alloc] init];
    userInfo.userId = userId;
    userInfo.userName = @"资深律师";
    return userInfo;
}

/**
 给律师发送红包
 
 @param packetInfo 红包信息
 @param lawyer 律师ID
 */
- (void)sendRedPacket:(id)packetInfo toLawyer:(NSString *)lawyer {
    // 发送红包逻辑
    NSLog(@"在这里发送红包");
}

/**
 
 未读数改变
 */
- (void)allUnreadCountDidChanged:(NSInteger)unreadCount {
    // 总未读数发生改变
    NSLog(@"总未读数%zd",unreadCount);
    
}


/**
 发给律师的常规金额面值是多少 单位：RMB
 
 @param lawyer 律师
 @return 返回一个数组
 -- 例如: @[@"5",@"10",@"15",@"25"]; 或者 @[@5,@10,@15,@25];
 */
- (NSArray <NSCopying>*)normalAmountOfPacketToLawyer:(NSString *)lawyer {
    return  @[@5,@10,@15,@25];
}


/**
 接收到消息  可以做 震动 语音 提示用户
 
 @param userId 用户Id  律师 或者 咨询者的ID
 
 @param messageType 消息类型
 */
- (void)chatManagerDidReciveMessageFromUser:(NSString *)userId withMessageType:(LYLZMessageType)messageType{
    NSLog(@"接收到%@ --- %zd消息",userId,messageType);
}
@end
