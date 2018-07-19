//
//  LYLZUserInfo.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/9.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYLZChatManager.h"
@interface LYLZUserInfo : NSObject <LYTUserBaseInfoProtocol>

/** <#des#> */
@property (nonatomic,copy)NSString * userId;

/** <#des#> */
@property (nonatomic,copy)NSString * userName;


/** <#des#> */
@property (nonatomic,copy)NSString * picture;


/** <#des#> */
@property (nonatomic,copy)NSString * nikeName;


/** <#des#> */
@property (nonatomic,copy)NSString * sex;

/** <#des#> */
@property (nonatomic,copy)NSString * signature;


+ (NSArray <LYLZUserInfo *>*)objectArrayFromJsonArray:(NSArray <NSDictionary *>*)array;

@end
