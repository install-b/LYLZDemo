//
//  LYLZChatManager.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZChatManager+Private.h"
#import "LYTCommonConfig.h"
#import "NSObject+SGExtention.h"
#import <LYMqttSDK/LYTUserBaseInfo.h>

static LYLZChatManager *_instanceManager;

@implementation LYLZChatManager

#pragma mark - LYLZChatManager单利方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceManager = [[super allocWithZone:zone] init];
        
        // 初始化配置
        [_instanceManager initLYTSDKSetUp];
    });
    return _instanceManager;
}

+ (instancetype)shareManager {
    return [[self alloc] init];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return _instanceManager;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
     return _instanceManager;
}

#pragma mark - 添加代理
- (void)initLYTSDKSetUp {
    // 添加代理
    [_instanceSDK.chatManager addDelegate:self];
//    [_instanceSDK.chatListManager addDelegate:self];
//    [_instanceSDK.userManager addDelegate:self];
    _instanceSDK.delegate = self;
}

#pragma mark - 初始化SDK
- (void)configSDKCompany:(NSString *)company appKey:(NSString *)appKey appSecret:(NSString *)appSecret netWork:(BOOL)isProduct {
    
    //使用LYLZSDK进行相关的初始化
    [_instanceSDK configSDKCompany:company appKey:appKey appSecret:appSecret];
    
    //启动同步会话列表
//    [_instanceSDK needSyncSessionList:YES];
    
    //设置系统消息ID
    _systemNotiId = [NSString stringWithFormat:@"%@%@",appKey,company];

    //设置互动消息ID
    _interactiveNotiId = [NSString stringWithFormat:@"%@%@3996",company,appKey];
    
    //设置评论消息ID
    _commentNotiId = [NSString stringWithFormat:@"%@%@3995",company,appKey];
    
    //设置网络类型
    [LYTSDKSetting setProductNetWork:isProduct];

}

#pragma mark - 登录
- (void)loginWithUserId:(NSString *)userId showCMTandInterMessage:(BOOL)showOrNot complete:(void (^)(LYTError *))complete {
    
    //用户为空的时候返回一个错误信息
    if (!userId) {
        LYTError *myError = [LYTError errorWithErrorCode:LYTErrorCodeMessageMissValue domain:@"用户ID为空" errorInfo:nil];
        !complete ?: complete(myError);
    }
    
    //记录当前的userId
    _currentUserId = userId;
   
    //记录是否展示评论、互动消息栏
    _showCMTandInterMessage = showOrNot;
    
    //使用LYLZSDK进行登录
    [_instanceSDK loginSDKWithUserId:userId forceLogin:YES complete:^(LYTError *error) {
        
        //登录完成
        [self loginComplete:error];
        
        //更新未读数
        [self updateChatListUnreadNumber];
        
        !complete ?: complete(error);
    }];
}

#pragma mark - 更新未读数
- (void)updateChatListUnreadNumber {
    //annotation by ys 2017.11.06
    //查询聊天所有列表
//    [_instanceSDK.chatListManager queryAllchatListNeedFresh:^(NSArray<LYTMessageList *> *array) {
//        __block NSInteger totalCount = 0;
//        [array enumerateObjectsUsingBlock:^(LYTMessageList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //评论消息或者互动消息(计算未读数)
//            if ([obj.targetId isEqualToString:self.commentNotiId] ||
//                [obj.targetId isEqualToString:self.interactiveNotiId]) {
//                NSDictionary *dict = [obj.lastMessage.content sg_JSONDictionary];
//                NSDictionary *content = [dict[@"content"] sg_JSONDictionary];
//
//                NSInteger count = [content[@"num"] integerValue];
//                NSLog(@"hjl- 获取的评论/互动未读数据是(%zd)  obj.targetId(%@)",count,obj.targetId);
//                totalCount += [content[@"num"] integerValue];
//
//            } else { //其他消息(计算未读数)
//                totalCount += obj.unreadCount;
//            }
//        }];
////        NSLog(@"hjl- 即将修改未读数据是 原始(%zd)  修改后(%zd)",self.unreadCount,totalCount);//逻辑测试稳定  后续优化版本中 可以删除该日志 hjl
//
//        self.unreadCount = totalCount;
//    }];
}

#pragma mark - 退出登录
- (void)logoutSDK {
    //未读数清0
    self.unreadCount = 0;
    //调用LYLZSDK退出登录
    [_instanceSDK logoutWithComplete:^(LYTError *error) {
        
    }];
}

#pragma mark - 登录完成
- (void)loginComplete:(LYTError *)error {
    if (error) {
        return;
    }
    //annotation by ys 2017.11.06
    //从网络获取用户信息
//    [_instanceSDK.userManager fetchUserInfoWithUserID:_currentUserId complete:^(NSArray * _Nullable arr, LYTError * _Nullable error) {
//
//        if (error == nil && arr && [arr count]) {
//            //同步用户信息到数据库
//            [_instanceSDK.contactManager updateContactWithContactsInfo:arr complete:nil];
//        }
//    }];
}

#pragma mark - update contact
- (void)updateContactWithContactInfo:(id <LYTUserBaseInfoProtocol>)userInfo complete:(LYLZCompleteBlock)complete {
    
    
    LYTUserExpanInfo *selfUser = [[LYTUserExpanInfo alloc] init];
    selfUser.userId = userInfo.userId;
    selfUser.userName = userInfo.userName;
    selfUser.picture = userInfo.picture;
    NSLog(@"上传的用户信息-----\n%@",selfUser.sg_keyValues);
    if ([userInfo.userId isEqualToString:_currentUserId]) {
        self.currentUser = userInfo;
    }
    //annotation by ys 2017.11.06
    // 更新数据库
//    [_instanceSDK.contactManager updateContactWithContactInfo:userInfo complete:complete];
    
    // 通过网络上传当前用户信息
//    [_instanceSDK.userManager batchUploadUserInfo:selfUser complete:nil];

}

#pragma mark - 批量上传用户信息
- (void)updateContactWithContactsInfo:(NSArray <id <LYTUserBaseInfoProtocol>> *)userInfos complete:(LYLZCompleteBlock)complete {
    //annotation by ys 2017.11.06
    // 更新数据库
//    [_instanceSDK.contactManager updateContactWithContactsInfo:userInfos complete:complete];
    
    [userInfos enumerateObjectsUsingBlock:^(id<LYTUserBaseInfoProtocol>  _Nonnull userInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        LYTUserExpanInfo *selfUser = [[LYTUserExpanInfo alloc] init];
        selfUser.userId = userInfo.userId;
        selfUser.userName = userInfo.userName;
        selfUser.picture = userInfo.picture;
        //annotation by ys 2017.11.06
        //通过网络上传用户信息
//        [_instanceSDK.userManager batchUploadUserInfo:selfUser complete:nil];
    }];
    
}

#pragma mark -  查询用户基本信息 
- (void)queryContactInfoWithUserId:(NSString *)userId complete:(void(^)(id <LYTUserBaseInfoProtocol> userInfo, LYTError *error))complete {
    //annotation by ys 2017.11.06
    //从数据库查询
//    [_instanceSDK.contactManager queryContactInfoWithUserId:userId complete:^(LYTUserBaseInfo *userInfo, LYTError *error) {
//        !complete ?: complete(userInfo,error);
//    }];
}

#pragma mark - 查询保存过用户基本信息列表
- (void)queryAllContactInfoscomplete:(void(^)(NSArray<id <LYTUserBaseInfoProtocol>> * userInfos, LYTError *error))complete {
    //annotation by ys 2017.11.06
    //从数据库查询
//    [_instanceSDK.contactManager queryAllContactInfoscomplete:complete];
}

#pragma mark - 查询会话列表的未读数
- (void)queryChatListAllUnreadNum:(void (^)(NSInteger num))block {
    //annotation by ys 2017.11.06
    //从数据库查询
//    [_instanceSDK.chatListManager queryChatListAllUnreadNum:block];
}

- (void)setUnreadCount:(NSInteger)unreadCount {
    if (_unreadCount == unreadCount) {
        return;
    }
    _unreadCount = unreadCount;
    // 未读数更改
    if ([self.delegate respondsToSelector:@selector(allUnreadCountDidChanged:)]) {
        [self.delegate allUnreadCountDidChanged:unreadCount];
    }
}

#pragma mark - SDK delegate
- (void)didAutoLoginOutWithError:(LYTError *)error {
    if ([self.delegate respondsToSelector:@selector(didAutoLogoutWithError:)]) {
        [self.delegate didAutoLogoutWithError:error];
    }
}

#pragma mark - session list
//annotation by ys 2017.11.06
//- (void)chatListNeedRefreshNotification:(NSArray<LYTMessageList *> *)data {
//    // 更新未读数
//    [self updateChatListUnreadNumber];
//}

#pragma mark - chat manager delegate 
- (void)didReceiveAMessage:(LYTMessage *)message {
    if ([self.delegate respondsToSelector:@selector(chatManagerDidReciveMessageFromUser:withMessageType:)]) {
        [self.delegate chatManagerDidReciveMessageFromUser:message.sendUserId withMessageType:(LYLZMessageType)message.messageType];
    }
}


- (void)didReceiveOfflineMessages:(NSArray <LYTMessage *> *)messages {
    if ([self.delegate respondsToSelector:@selector(chatManagerDidReciveMessageFromUser:withMessageType:)]) {
         LYTMessage *message = messages.lastObject;
        [self.delegate chatManagerDidReciveMessageFromUser:message.sendUserId withMessageType:(LYLZMessageType)message.messageType];
    }
}

- (void)didReceiveRevokeMessage:(LYTMessage *)revokeMessage byUser:(NSString *)userId {
    
}

- (BOOL)shouldSaveMessageInDBwithMessage:(LYTMessage *)message {
    //自己发送的消息/订单消息/红包消息
    if ([message.sendUserId isEqualToString:_instanceSDK.currentUser] &&
        (message.messageType == LYLZMessageTypeOrder ||
         message.messageType == LYLZMessageTypeRePacket)) {
        return NO;
    }
    //结束会话的弹窗消息
    if (message.messageType == LYLZMessageTypeSessionBox) {
        return NO;
    }

    return YES;
}

#pragma mark - UI Config
- (void)configNavBackGroudColor:(UIColor *)bgColor
                      tintColor:(UIColor *)tintColor
            titleTextAttributes:(NSDictionary *)attr {
    [[LYTCommonConfig shareConfig] configNavBackGroudColor:bgColor tintColor:tintColor titleTextAttributes:attr];
}

#pragma mark - Private方法
- (NSArray <NSCopying>*)normalAmountOfPacketToLawyer:(NSString *)lawyer {
    
    if ([self.delegate respondsToSelector:@selector(normalAmountOfPacketToLawyer:)]) {
        return  [self.delegate normalAmountOfPacketToLawyer:lawyer];
    }
    // 默认金额
    return @[@"5",@"15",@"50",@"100"];
}


- (void)sendRedPacket:(id)packetInfo toLawyer:(NSString *)lawyer {
    if ([self.delegate respondsToSelector:@selector(sendRedPacket:toLawyer:)]) {
        [self.delegate sendRedPacket:packetInfo toLawyer:lawyer];
    }
}

- (id <LYTUserBaseInfoProtocol>)userInfoWithUserId:(NSString *)userId {
    if ([self.delegate respondsToSelector:@selector(userInfoWithUserId:)]) {
        // 通过代理方法获取当前用户
        id <LYTUserBaseInfoProtocol> userInfo = [self.delegate userInfoWithUserId:userId];
        //annotation by ys 2017.11.06
        //  更新用户信息到数据库
//        [_instanceSDK.contactManager updateContactWithContactInfo:userInfo complete:nil];
        return userInfo;
    }
    return nil;
}

- (id<LYTUserBaseInfoProtocol>)currentUser {
    if (!_currentUser) {
        _currentUser = [self userInfoWithUserId:_instanceSDK.currentUser];
    }
    return _currentUser;
}

//annotation by ys 2017.11.06
//- (void)getUserInfoWithUserID:(NSString *)userID complete:(void (^)(NSArray * _Nullable, LYTError * _Nullable))complete {
//    //从网络获取
//    [_instanceSDK.userManager fetchUserInfoWithUserID:userID complete:complete];
//}

#pragma mark - 通过网络上传用户信息
//annotation by ys 2017.11.06
//- (void)uploadUserName:(NSString *)name userPicture:(NSString *)picture complete:(void (^)(BOOL, LYTError * _Nullable))block {
//    LYTUserExpanInfo *info = [[LYTUserExpanInfo alloc] init];
//    info.picture = picture;
//    info.userName = name;
//    info.userId = [_instanceSDK currentUser];
//    //通过网络上传
//    [_instanceSDK.userManager batchUploadUserInfo:info complete:block];
//}


#pragma mark - YTSDKUserManagerDelegate
/**
 接收到用户状态的变更

 @param status 用户状态
 */
- (void)didReceiveAuthStatusChange:(LYTAuthStatus)status {

    if (status == LYTAuthStatusLogOutForce) {
        NSLog(@"hjl-用户被提下线了。");

        LYTError *error = [LYTError errorWithErrorCode:LYTErrorCodeDidLoginOnOtherWays domain:@"当前用户在其他端登录了。" errorInfo:nil];
        if ([self.delegate respondsToSelector:@selector(didAutoLogoutWithError:)]) {
            [self.delegate didAutoLogoutWithError:error];
        }
    }
}
@end
