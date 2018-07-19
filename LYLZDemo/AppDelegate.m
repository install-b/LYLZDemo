//
//  AppDelegate.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/3.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "AppDelegate.h"

#import "AppDelegate+LZXGPush.h"
#import "AppDelegate+SDKConfig.h"
#import "AppDelegate+LZJump.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 初始化SDK
    [self configSDK];
    
    // 设置信鸽 推送 跳转
    [self setUpXGPushWithLaunchingWithOptions:launchOptions];
       
    return YES;
}

// 进入前台 获取到焦点
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 角标变为0
    application.applicationIconBadgeNumber = 0;
}




@end
