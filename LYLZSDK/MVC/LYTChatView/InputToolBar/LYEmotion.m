//
//  LYEmotion.m
//  TaiYangHua
//
//  Created by Lc on 16/2/26.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYEmotion.h"

@implementation LYEmotion

+ (instancetype)emotionWithDict:(NSDictionary *)dict
{
    LYEmotion *emotion = [[LYEmotion alloc] init];
    emotion.chs = dict[@"chs"];
    emotion.png = dict[@"png"];
    
    return emotion;
}

@end
