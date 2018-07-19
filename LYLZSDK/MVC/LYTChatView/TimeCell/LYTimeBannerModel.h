//
//  LYTimeBannerModel.h
//  LYLink
//
//  Created by SYLing on 2016/12/21.
//  Copyright © 2016年 HHLY. All rights reserved.
//
//  聊天界面加入的时间数据

#import <Foundation/Foundation.h>

@interface LYTimeBannerModel : NSObject

@property (copy, nonatomic) NSString *timerString;

+ (instancetype)bannerWithTimerString:(NSString *)string;

@end
