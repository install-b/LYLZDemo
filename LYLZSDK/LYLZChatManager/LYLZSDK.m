//
//  LYLZSDK.m
//  LYLZSDK
//
//  Created by Shangen Zhang on 2017/9/27.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZSDK.h"

@implementation LYLZSDK
+ (instancetype)sharedSDK {
    static LYLZSDK *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithProductId:@"LYLZSDKProductSDK" messageTypeRange:NSMakeRange(3900, 1900)];
    });
    return _instance;
}

- (instancetype)initWithProductId:(NSString *)productId messageTypeRange:(NSRange)range {
    if (self = [super initWithProductId:productId messageTypeRange:range]) {
        // 建立映射
        [self.chatManager setMessageTypeMapping:@{
                                                    @"3901" : @"1001",//文本
                                                    @"3902" : @"1002",//图片
                                                    @"3903" : @"1003",//语音
                                                    @"3904" : @"1005"}//文件
         ];
        // 开启回话列表同步功能
        //annotation by ys 2017.11.06
//        [self needSyncSessionList:YES];
#ifdef DEBUG
        [LYTSDKSetting isPrintDebugLog:YES];
#endif

    }
    return self;
}

@end
