//
//  LYTCommonConfig.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/6.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTCommonConfig : NSObject

+ (instancetype)shareConfig;


- (void)configNavBackGroudColor:(UIColor *)color tintColor:(UIColor *)tintColor titleTextAttributes:(NSDictionary *)attr;


/** <#des#> */
@property (nonatomic,strong) UIColor * navBackGroudColor;

/** <#des#> */
@property (nonatomic,strong) UIColor * navTintColor;

/** <#des#> */
@property (nonatomic,strong) NSDictionary * navTextAttr;


@end
