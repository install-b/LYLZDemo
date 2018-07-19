//
//  LZTabbarController.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/10.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LYLZChatManager.h"

@interface LZTabbarController : UITabBarController




- (instancetype)initWithChatIdentity:(LYLZChatIdentity)chatIdentity userId:(NSString *)userId;

/** <#des#> */
@property (nonatomic,copy,readonly)NSString * userId;

@end
