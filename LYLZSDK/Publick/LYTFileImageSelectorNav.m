//
//  LYTFileImageSelectorNav.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/6.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYTFileImageSelectorNav.h"
#import "UIImage+Utility.h"
#import "UIColor+LYColor.h"
#import "LYTCommonConfig.h"

@interface LYTFileImageSelectorNav ()

@end

@implementation LYTFileImageSelectorNav

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpNav];
}

- (void)setUpNav {
    UINavigationBar *bar = self.navigationBar;
    
    bar.translucent = NO;
    
    LYTCommonConfig *config = [LYTCommonConfig shareConfig];
    UIColor *navBgColor = [config.navBackGroudColor isKindOfClass:UIColor.class] ? config.navBackGroudColor : LYColor(47, 176, 252);
    
    [bar setBackgroundImage: [UIImage imageWithColor:navBgColor] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
    
    if ([config.navTextAttr isKindOfClass:NSDictionary.class]) {
        [bar setTitleTextAttributes:config.navTextAttr];
    } else {
        // 设置导航条字体
        NSMutableDictionary *attri = [NSMutableDictionary dictionary];
        attri[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attri[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
        [bar setTitleTextAttributes:attri];
    }
    
    
    //导航条主题颜色
    bar.tintColor = [config.navTintColor isKindOfClass:UIColor.class] ? config.navTintColor : [UIColor whiteColor];
}
@end
