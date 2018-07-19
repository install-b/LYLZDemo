//
//  AppDelegate+XGPush.m
//  LYTSoketSDKDemo
//
//  Created by Shangen Zhang on 2017/9/19.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "AppDelegate+LZXGPush.h"
#import "LYTPush.h"
//#import "LYTRemoteInfo.h"
#import "LYLZChatManager.h"
#import "AppDelegate+LZJump.h"



@implementation AppDelegate (LZXGPush)
// 程序 启动
- (void)setUpXGPushWithLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 获取 系统信息
    NSInteger sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
    
    // 开启信鸽推送
    [LYTPush lyt_startApp:xingeLZAppId appKey:xingeLZAppkey appSecret:xingeLZAppSecretKey environment:LYTPushEnvironmentDebug];
    //[LYTPush lyt_startApp:xingeLZAppId appKey:xingeLZAppkey];
    
    // 注册APNs
     [self registerAPNSWithSytemVersion:sysVer];
    
    // 用于信鸽 推送反馈
//    [LYTPush lyt_handleLaunching:launchOptions successCallback:^{
//        //LYTLog(@"[XGDemo] Handle launching success");
//    } errorCallback:^{
//        //LYTLog(@"[XGDemo] Handle launching error");
//    }];
    
    // 设置跳转
    [self jumpWithLaunchingWithOption:launchOptions withSystemVersion:sysVer];
    
}


#pragma mark - registerAPNS
// 通过系统版本 注册推送
- (void)registerAPNSWithSytemVersion:(NSInteger)systemVersion {
    if (systemVersion >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (systemVersion >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    }
}
// iOS 10 及 以后的注册方式
- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
     // 设置通知代理
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;

    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

// iOS 8-9 注册方式
- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}


#pragma mark - remote push register callback
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // 获取token
    NSString *deviceTokenStr = [LYTPush lyt_registerDevice:deviceToken successCallback:^{
        
    } errorCallback:^{
        
    }];
    
    //设置远程推送的token
//    if (deviceTokenStr.length) {
//        LYTRemoteInfo *remoteInfo = [[LYTRemoteInfo alloc] initWithAccessId:[NSString stringWithFormat:@"%ld",xingeLZAppId] secretKey:xingeLZAppSecretKey deviceToken:deviceTokenStr];
//#ifdef DEBUG
//        remoteInfo.xingeEnvironment = LYTRemoteEnvironmentTypeDebug;
//#endif
//        [[LYLZChatManager shareManager] chartManagerConfigXingeRemotePushInfo:remoteInfo];
//    }
}

// 注册失败 回调
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"davidhuang«=%@",error);
    
}



#pragma mark - app receive notification call back
#pragma mark iOS 8-9 call back
/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //LYTLog(@"[XGDemo] receive Notification");
//    [LYTPush lyt_handleReceiveNotification:userInfo
//                      successCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive success");
//                      } errorCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive error");
//                      }];
    
    // 跳转
    [self jumpWithAPNsNotificationUserInfo:userInfo];
}


/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 信鸽统计
//    [XGPush handleReceiveNotification:userInfo
//                      successCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive success");
//                      } errorCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive error");
//                      }];
    
    // 跳转
    [self jumpWithAPNsNotificationUserInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark iOS 10 call back
// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
    
    // 获取跳转信息
    NSDictionary *jumpInfo = response.notification.request.content.userInfo;
    
    // 自定义跳转
    [self jumpWithAPNsNotificationUserInfo:jumpInfo];
    
    // 信鸽统计
//    [XGPush handleReceiveNotification:jumpInfo
//                      successCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive success");
//                      } errorCallback:^{
//                          //LYTLog(@"[XGDemo] Handle receive error");
//                      }];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionNone);
}
#endif
@end

