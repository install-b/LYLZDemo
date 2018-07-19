//
//  LYLZUserInfo.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/9.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZUserInfo.h"

@implementation LYLZUserInfo
+ (NSArray <LYLZUserInfo *>*)objectArrayFromJsonArray:(NSArray <NSDictionary *>*)array {
    if (array.count == 0) {
        return nil;
    }
    NSMutableArray *arryM = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LYLZUserInfo *userInfo = [[self.class alloc] init];
        [userInfo setValuesForKeysWithDictionary:obj];
        [arryM addObject:userInfo];
    }];
    return [NSArray arrayWithArray:arryM];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
