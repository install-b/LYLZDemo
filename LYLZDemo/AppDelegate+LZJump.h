//
//  AppDelegate+LZJump.h

//
//  Created by Shangen Zhang on 2017/9/19.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

// 负责控制器跳转

#import "AppDelegate.h"

@interface AppDelegate (LZJump)

// 程序启动跳转
- (void)jumpWithLaunchingWithOption:(NSDictionary *)launchOptions withSystemVersion:(float)sytemVersion;

// 通过推送信息跳转
- (void)jumpWithAPNsNotificationUserInfo:(NSDictionary *)userInfo;

@end
