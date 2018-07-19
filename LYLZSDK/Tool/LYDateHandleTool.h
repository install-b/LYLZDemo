//
//  LYDateHandleTool.h
//  LYLink
//
//  Created by SYLing on 2016/12/14.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYDateHandleTool : NSObject
/**
 *  根据时间戳返回时间
 */
+ (NSString *)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail;

/**
 *  根据距离时间段，计算过去时间
 *  eg. now am 9:00 过去3600秒就是 am 8:00
 *  @param distanseTime 流逝的时间
 */
+ (NSString *)distanceNowTime:(NSString *)distanseTime showDetail:(BOOL )showDetail;

/**
 *  根据流逝的时间秒数计算是多少分钟之前
 *
 */
+ (NSString *)passTimeWithElapseTime:(NSString *)elapseTime;

/**
 *  获取时间戳字符串
 *
 *  @param waitTime 流逝的时间
 *
 *  @return 过去的绝对时间的字符串
 */
+ (NSString *)distanceNowTime:(NSString *)waitTime;
/**
 *  计算今天，昨天，前天，过去多少天
 */
+ (int)howManyDayDistanceToday:(NSString *)oldTime;
/**
 *  计算多少分钟之前
 */
+ (NSString *)howminuteDayDistanceNow:(NSString *)oldTime;
@end
