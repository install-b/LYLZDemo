//
//  NSString+Time.m
//  LYTCommonLib
//
//  Created by Shangen Zhang on 2017/9/14.
//  Copyright © 2017年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)
- (NSString *)lyt_timeString
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000];
    NSDateComponents * messageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:messageDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *yestoday = nil;
    
    if (currentComponents.year == messageComponents.year
        && currentComponents.month == messageComponents.month
        && currentComponents.day == messageComponents.day) {
        
        dateFormatter.dateFormat= @"HH:mm";
        
    }else if(currentComponents.year == messageComponents.year
             && currentComponents.month == messageComponents.month
             && currentComponents.day - 1 == messageComponents.day){
        yestoday = @"昨天";
        dateFormatter.dateFormat= [NSString stringWithFormat:@"HH:mm"];
    }else{
        
        dateFormatter.dateFormat= @"yyy-MM-dd HH:mm";
    }
    
    NSString *dateString = [dateFormatter stringFromDate:messageDate];
    return yestoday?[yestoday stringByAppendingFormat:@" %@", dateString]:dateString;
}

@end
