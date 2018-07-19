//
//  AppDelegate+XGPush.h
//  LYTSoketSDKDemo
//
//  Created by Shangen Zhang on 2017/9/19.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

// 配置推送信息

#import "AppDelegate.h"


#define xingeLZAppId  2200267231
#define xingeLZAppkey @"IR221HI28MJX"
#define xingeLZAppSecretKey @"3f27c5edf5af5fcd3693d177fb365cf0"
                              



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate(XGPush) <UNUserNotificationCenterDelegate>
// 开启信鸽推送
- (void)setUpXGPushWithLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
#else
@interface AppDelegate (LZXGPush)
// 开启信鸽推送
- (void)setUpXGPushWithLaunchingWithOptions:(NSDictionary *)launchOptions;
@end
#endif
