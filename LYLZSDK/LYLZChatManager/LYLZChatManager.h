//
//  LYLZChatManager.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//
#define lyt_ui_sdk_version @"4.5.1" //2017-10-18 17:30:00

#import "LYTLZChatViewController.h"
#import "LYLZChatListView.h"
#import "LYTUserBaseInfo.h"
#import <LYMqttSDK/LYTError.h>
//#import "LYTRemoteInfo.h"

// 消息类型
typedef NS_ENUM(NSUInteger,LYLZMessageType) {
    LYLZMessageTypeText                 = 1001,    // 文本消息
    LYLZMessageTypeImage                = 1002,    // 图片消息
    LYLZMessageTypeVoice                = 1003,    // 语音消息
    LYLZMessageTypeFile                 = 1005,    // 文件消息
    LYLZMessageTypeOrder                = 3997,    // 订单消息
    LYLZMessageTypeRePacket             = 3998,    // 红包消息
    LYLZMessageTypeSystem               = 3999,    // 系统消息
    LYLZMessageTypeInteractive          = 3996,    // 互动消息
    LYLZMessageTypeComment              = 3995,    // 评论消息
    LYLZMessageTypePush                 = 3994,    // 推送消息
    LYLZMessageTypeSessionBox           = 3993     // 结束会话的弹窗消息
};

typedef void(^LYLZCompleteBlock)(LYTError * _Nullable error);
@protocol LYLZChatManagerDelegate;

@interface LYLZChatManager : NSObject

/**
 单例方法
 @return 实例化对象
 */
+ (instancetype _Nonnull)shareManager;


/** delegate */
@property (nonatomic,weak) id  <LYLZChatManagerDelegate>_Nullable delegate;


/**
 配置SDK导航控制器主题 （如图片选择器、文件选择器的导航颜色）

 @param bgColor 背景颜色 默认(r:47 g:176 b:252)淡蓝色
 @param tintColor tintColor 默认白色
 @param attr item字体 默认18号加粗白色
 */
- (void)configNavBackGroudColor:(UIColor *_Nullable)bgColor
                      tintColor:(UIColor *_Nullable)tintColor
            titleTextAttributes:(NSDictionary *_Nullable)attr;

/**
 初始化SDK
    -- 正常登录SDK之前必须调用该方法
 
 @param company 公司代码（注册）
 @param appKey APPKey
 @param appSecret app密钥
 @param isProduct 设置是否为生产环境
 */
- (void)configSDKCompany:(NSString *_Nonnull)company
                  appKey:(NSString *_Nonnull)appKey
               appSecret:(NSString *_Nonnull)appSecret
                 netWork:(BOOL)isProduct;

/**
 SDK登录 登录成功默认会连接通讯功能
 
 @param userId 用户名 非空字符串
 
 @param complete 完成回调 有error 登录失败 没有error登录成功
    -- 注意: 当 error的code为 ‘LYTErrorCodeDidLogin’ 时 表示SDK 已登录  error info中会返回userId表示已登录的账号
    -- 如果需要切换账号需要 先调用 ‘loginOut’ 再调用登录接口
 */
- (void)loginWithUserId:(NSString *_Nonnull)userId showCMTandInterMessage:(BOOL)showOrNot complete:(void(^_Nullable)(LYTError * _Nullable error))complete;


/**
 退出登录
 */
- (void)logoutSDK;


/**
 更新用户信息到数据库
 
 @param userInfo 用户信息表
 @param complete 完成回调 有error即为失败
 */
- (void)updateContactWithContactInfo:(id  <LYTUserBaseInfoProtocol>_Nonnull)userInfo complete:(LYLZCompleteBlock _Nullable )complete;


/**
 批量更新用户的信息到数据库
 
 @param userInfos 用户信息列表
 @param complete 完成回调 有error即为失败
 */
- (void)updateContactWithContactsInfo:(NSArray <id <LYTUserBaseInfoProtocol>> *_Nonnull)userInfos complete:(LYLZCompleteBlock _Nullable )complete;



/**
 查询用户基本信息 （保存了联系人才会查到）
 
 @param userId 用户Id
 @param complete 完成回调  有error即为失败 ,error 为空时 userInfo 不一定有值
 */
- (void)queryContactInfoWithUserId:(NSString *_Nonnull)userId complete:(void(^_Nullable)(id  <LYTUserBaseInfoProtocol> _Nullable userInfo, LYTError * _Nullable error))complete;

/**
 查询保存过用户基本信息列表 （保存了联系人才会查到）
 
 @param complete 完成回调  有error即为失败 ,error 为空时 userInfos 不一定有值(可能没保存)
 */
- (void)queryAllContactInfoscomplete:(void(^_Nonnull)(NSArray<id <LYTUserBaseInfoProtocol>> *_Nullable userInfos, LYTError * _Nullable error))complete;


/**
 查询所有的会话未读数
 
 @param block block回调
 */
- (void)queryChatListAllUnreadNum:(void (^_Nonnull)(NSInteger num))block;

@end











#pragma mark - protocol LYLZChatManagerDelegate
@protocol LYLZChatManagerDelegate <NSObject>
@required
/**
 根据用户ID返回 用户信息 回调  当用户体系中查不到改用户  调用
 
 @param userId 用户ID
 @return 用户信息 (userName不能为空  picture不能为空)
 */
- (id  <LYTUserBaseInfoProtocol>_Nonnull)userInfoWithUserId:(NSString *_Nonnull)userId;

/**
  给律师发送红包

 @param packetInfo 红包信息
 @param lawyer 律师ID
 */
- (void)sendRedPacket:(id _Nonnull )packetInfo toLawyer:(NSString *_Nonnull)lawyer;


@optional


/**
 总的未读数发生改变

 @param unreadCount 当前总未读数
 */
- (void)allUnreadCountDidChanged:(NSInteger)unreadCount;

/**
 自动退出登录 回调

 @param error 退出原因
 */
- (void)didAutoLogoutWithError:(LYTError *_Nullable)error;


/**
 发给律师的常规金额面值是多少 单位：RMB

 @param lawyer 律师
 @return 返回一个数组
    -- 例如: @[@"5",@"10",@"15",@"25"]; 或者 @[@5,@10,@15,@25];
 */
- (NSArray <NSCopying>*_Nullable)normalAmountOfPacketToLawyer:(NSString *_Nonnull)lawyer;



/**
 接收到消息  可以做 震动 语音 提示用户

 @param userId 用户Id  律师 或者 咨询者的ID
 
 @param messageType 消息类型
 */
- (void)chatManagerDidReciveMessageFromUser:(NSString *_Nonnull)userId withMessageType:(LYLZMessageType)messageType;


@end



