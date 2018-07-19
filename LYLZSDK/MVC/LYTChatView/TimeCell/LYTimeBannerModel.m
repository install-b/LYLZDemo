//
//  LYTimeBannerModel.m
//  LYLink
//
//  Created by SYLing on 2016/12/21.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYTimeBannerModel.h"

@implementation LYTimeBannerModel

+ (instancetype)bannerWithTimerString:(NSString *)string
{
   
    LYTimeBannerModel *banner = [[self alloc] init];
    banner.timerString = string;
    return banner;
}
@end
