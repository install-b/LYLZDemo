//
//  LYTCommonConfig.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/6.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYTCommonConfig.h"

@implementation LYTCommonConfig
+ (instancetype)shareConfig {
    static LYTCommonConfig *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void)configNavBackGroudColor:(UIColor *)color tintColor:(UIColor *)tintColor titleTextAttributes:(NSDictionary *)attr {
    _navBackGroudColor = color;
    _navTextAttr = attr;
    _navTintColor = tintColor;
}
@end
