//
//  AppDelegate+SDKConfig.m
//  LYLZSDKDemo
//
//  Created by Shangen Zhang on 2017/9/30.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "AppDelegate+SDKConfig.h"
#import "AppDelegate+LYLZChatDelegate.h"
#import "LYLZChatManager.h"
#import "LYLZConfigInfo.h"
@implementation AppDelegate (SDKConfig)
#pragma mark - data source
// 假数据
- (NSDictionary *)loginInfo {
    
    //    return @{
    //             @"company"  : @"1201100000000000038",
    //             @"appKey" : @"12011000000000000381201115",
    //             @"appSecret" : @"112bbbd292b2f0fa17509e9ab2f6406b",
    //             };
    
    //    return @{
    //             //@"appId":@"1011100000000000053",
    //             @"company": @"1011100000000000006",
    //             @"appKey": @"1011100000000000006101151",
    //             @"appSecret": @"a55434f86f9589a6ef0115a02f84c86f"
    //             };
    return @{
             @"appKey" : @"1011100000000000006101151",
             @"company" : @"1011100000000000006",
             @"appSecret" : @"a55434f86f9589a6ef0115a02f84c86f"
             };
}
- (void)configSDK {
    // 字典 --> 模型
    LYLZConfigInfo *info = [[LYLZConfigInfo alloc] init];
    [info setValuesForKeysWithDictionary:[self loginInfo]];
    

    // 配置SDK
    [[LYLZChatManager shareManager] configSDKCompany:info.company appKey:info.appKey appSecret:info.appSecret netWork:NO];
    // 设置代理
    [LYLZChatManager shareManager].delegate = self;
}
@end
