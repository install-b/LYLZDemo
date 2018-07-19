//
//  LYLZmessageBody.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZmessageBody.h"
#import "NSObject+SGExtention.h"

@implementation LYLZmessageBody
- (instancetype)initWithContent:(id)content {
    if (self = [super init]) {
       
        [self setValuesForKeysWithDictionary:[content sg_JSONDictionary]];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"设置未知的属性: %@",key);
}

@end
