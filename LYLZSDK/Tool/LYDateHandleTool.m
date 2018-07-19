//
//  LYDateHandleTool.m
//  LYLink
//
//  Created by SYLing on 2016/12/14.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYDateHandleTool.h"

@implementation LYDateHandleTool

+ (NSString *)distanceNowTime:(NSString *)distanseTime showDetail:(BOOL )showDetail
{
    NSDate *now = [NSDate date];
    double past = now.timeIntervalSince1970 - [distanseTime doubleValue];
    return [self showTime:past showDetail:showDetail];
}
+ (NSString *)distanceNowTime:(NSString *)waitTime
{
    NSDate *now = [NSDate date];
    double past = now.timeIntervalSince1970 - [waitTime doubleValue];
    NSString *pastTimeInterval = [NSString stringWithFormat:@"%f",past];
    if (pastTimeInterval.length >=10) {
        pastTimeInterval = [pastTimeInterval substringToIndex:10];
    }
    return pastTimeInterval;
}

+ (NSString*)showTime:(NSTimeInterval) msglastTime showDetail:(BOOL)showDetail
{
    //今天的时间
    NSDate * nowDate = [NSDate date];
    NSDate * msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSString *result = nil;
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSInteger hour = msgDateComponents.hour;
    NSTimeInterval gapTime = -msgDate.timeIntervalSinceNow;
    double onedayTimeIntervalValue = 24*60*60;  //一天的秒数
    result = [LYDateHandleTool getPeriodOfTime:hour withMinute:msgDateComponents.minute];
    if (hour > 12)
    {
        hour = hour - 12;
    }
    
    if (gapTime < onedayTimeIntervalValue * 2) {
        int gapDay = gapTime/(60*60*24) ;
        if(gapDay == 0) //在24小时内,存在跨天的现象. 判断两个时间是否在同一天内
        {
            BOOL isSameDay = msgDateComponents.day == nowDateComponents.day;
            result = isSameDay ? [[NSString alloc] initWithFormat:@"%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] : (showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] :@"昨天");
        } else if(gapDay == 1)//昨天
        {
            result = showDetail?  [[NSString alloc] initWithFormat:@"昨天%@ %zd:%02d",result,hour,(int)msgDateComponents.minute] :@"昨天";
        }else {
            NSString *day = [NSString stringWithFormat:@"%zd-%zd",msgDateComponents.month, msgDateComponents.day];
            
            result = showDetail? [day stringByAppendingFormat:@" %@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
        }
        
    } else {//显示日期
        NSString *day = [NSString stringWithFormat:@"%zd-%zd",msgDateComponents.month, msgDateComponents.day];
        
        result = showDetail? [day stringByAppendingFormat:@" %@ %zd:%02d",result,hour,(int)msgDateComponents.minute]:day;
    }
    
    return result;
}

#pragma mark - Private

+ (NSString *)getPeriodOfTime:(NSInteger)time withMinute:(NSInteger)minute
{
    NSInteger totalMin = time *60 + minute;
    NSString *showPeriodOfTime = @"";
    if (totalMin > 0 && totalMin <= 5 * 60)
    {
        showPeriodOfTime = @"凌晨";
    }
    else if (totalMin > 5 * 60 && totalMin < 12 * 60)
    {
        showPeriodOfTime = @"上午";
    }
    else if (totalMin >= 12 * 60 && totalMin <= 18 * 60)
    {
        showPeriodOfTime = @"下午";
    }
    else if ((totalMin > 18 * 60 && totalMin <= (23 * 60 + 59)) || totalMin == 0)
    {
        showPeriodOfTime = @"晚上";
    }
    return showPeriodOfTime;
}

+(NSString*)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    });
    
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}
+ (NSString *)passTimeWithElapseTime:(NSString *)elapseTime
{
    long elapseTimeInt = [elapseTime integerValue];
    int a =  elapseTimeInt/60.0;
    int h = elapseTimeInt/3600.0;
    NSString *str0 = @"%ld分钟前";
    if (a <= 2) {
        return @"刚刚";
    }else if (a <= 5) {
        return [NSString stringWithFormat:str0,5];
        return str0;
    }else if (a <=10){
        return [NSString stringWithFormat:str0,10];
    }else if (a <=20) {
        return [NSString stringWithFormat:str0,20];
    }else if (a <=30) {
        return [NSString stringWithFormat:str0,30];
    }else if (a <=40) {
        return [NSString stringWithFormat:str0,40];
    }else if (a <=50) {
        return [NSString stringWithFormat:str0,50];
    }else if (a <=60) {
        return [NSString stringWithFormat:str0,60];
    }else {
        NSString *str = @"%ld小时前";
        NSString *min = [NSString stringWithFormat:str,h];
        return min;
    }
}
+ (int)howManyDayDistanceToday:(NSString *)oldTime
{
    NSDate *now = [NSDate date];
    double past = now.timeIntervalSince1970 - [oldTime doubleValue];
    
    int days = past/(24*60*60);
    return days;
}

+ (NSString *)howminuteDayDistanceNow:(NSString *)oldTime
{
    if (oldTime.length == 0 || [oldTime isEqualToString:@""] || oldTime == nil) {
        return  [self passTimeWithElapseTime:@"0"];
    }
    NSDate *now = [NSDate date];
    NSString * past =[NSString stringWithFormat:@"%f",now.timeIntervalSince1970 - [oldTime doubleValue]];
    return  [self passTimeWithElapseTime:past];
    
}

@end
