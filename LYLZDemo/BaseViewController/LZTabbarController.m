//
//  LZTabbarController.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZTabbarController.h"
#import "LYNavigationController.h"
#import "LZSessionListViewController.h"
#import "LZContactViewController.h"
#import "LYLZChatManager.h"
#import "LYLZUserInfo.h"

@interface LZTabbarController ()

@end

@implementation LZTabbarController

- (instancetype)initWithChatIdentity:(LYLZChatIdentity)chatIdentity userId:(NSString *)userId{
    
    if (self = [super init]) {
        
        _userId = userId;
        LZSessionListViewController *listVc = [[LZSessionListViewController alloc] init];
        listVc.chatIdentity = chatIdentity;
        
        
        [self addChildVc:listVc];
        
        LZContactViewController *contactVc = [[LZContactViewController alloc] init];
        contactVc.chatIdentity = chatIdentity;
        contactVc.title = _userId;
        

        [self addChildVc:contactVc];
    }
    return self;
}

- (void)addChildVc:(UIViewController *)vc{
    LYNavigationController *nav = [[LYNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    vc.tabBarController.title = vc.title;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self loginSDK];
}
- (void)loginSDK {

    // 登录
    [[LYLZChatManager shareManager] loginWithUserId:_userId showCMTandInterMessage:YES complete:^(LYTError *error) {
        if (error) {
            NSLog(@"登录SDK失败 %@",error);
            return ;
        }
        
        LYLZUserInfo *userInfo = [[LYLZUserInfo alloc] init];
        
        userInfo.userId = _userId;
        
        userInfo.userName = @"张三";
        
        userInfo.picture = @"http://ftp.71chat.com/C10086/2016-11-17/67909CD9-015E-4539-A7CD-BE26C841DB8A/7ec66d80e4fd4f3c85525bfb69655c2b.jpg";
        
        [[LYLZChatManager shareManager] updateContactWithContactInfo:userInfo complete:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:_userId forKey:@"_userId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}



@end
