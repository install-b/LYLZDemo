//
//  AppDelegate+LZJump.m
//
//  Created by Shangen Zhang on 2017/9/19.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "AppDelegate+LZJump.h"
#import "AppDelegate+LZXGPush.h"

#import "LYNavigationController.h"
#import "LZLoginViewController.h"
#import "LZTabbarController.h"

@implementation AppDelegate (LZJump)
- (void)jumpWithLaunchingWithOption:(NSDictionary *)launchOptions withSystemVersion:(float)sytemVersion{
    
    if (!launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        // 常规跳转
        [self jumpWithNormalViewController];
    }
    else if(sytemVersion < 10){
        // 界面的跳转(针对应用程序被杀死的状态下的跳转)
        // iOS 10.0以下 杀死程序 接收到推送 以下在这跳转
        UILocalNotification *notiFication = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [self jumpWithAPNsNotificationUserInfo:notiFication.userInfo];
    }
}



- (void)jumpWithAPNsNotificationUserInfo:(NSDictionary *)jupmInfo {
    
    // 推送跳转
    if (jupmInfo[@"targetId"] && jupmInfo[@"chatType"]) {
        
        
        
        if ([self.window.rootViewController isKindOfClass:LYNavigationController.class]) {
            // 跳转
            
        }else {
            
           
        }
        
    }else {
        [self jumpWithNormalViewController];
    }
}

// 默认方式跳转
- (void)jumpWithNormalViewController {
    if (self.window.rootViewController) {
        return;
    }
    
//    NSString * userId = nil;//[[NSUserDefaults standardUserDefaults] objectForKey:@"_userId"]; //for test davidhuang 没有处理被踢消息，暂时保持每次输入
//    if (userId) {
//        LZTabbarController *ROOTVC =  [[LZTabbarController alloc] initWithChatIdentity:LYLZChatIdentityLawyer userId:userId];
//        
//        [UIApplication sharedApplication].keyWindow.rootViewController = ROOTVC;
//        return;
//    }
    
    // 设置根控制器
    self.window.rootViewController = [[LZLoginViewController alloc] init];
}


- (void)goToLoginVC {

    // 设置根控制器
    self.window.rootViewController = [[LZLoginViewController alloc] init];
    [self.window makeKeyAndVisible];

}




#pragma mark - LYLZChatManagerDelegate
/**
 根据用户ID返回 用户信息 回调  当用户体系中查不到改用户  调用

 @param userId 用户ID
 @return 用户信息 (userName不能为空  picture不能为空)
 */
- (id  <LYTUserBaseInfoProtocol>_Nonnull)userInfoWithUserId:(NSString *_Nonnull)userId {
    return nil;
}

/**
 给律师发送红包

 @param packetInfo 红包信息
 @param lawyer 律师ID
 */
- (void)sendRedPacket:(id _Nonnull )packetInfo toLawyer:(NSString *_Nonnull)lawyer {

}

/**
 自动退出登录 回调

 @param error 退出原因
 */
- (void)didAutoLogoutWithError:(LYTError *_Nullable)error {
    NSLog(@"接收到 被踢下线的回调,跳转到登录界面重新登录。");
    [self goToLoginVC];
}


@end
