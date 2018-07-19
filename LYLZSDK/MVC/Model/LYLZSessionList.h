//
//  LYLZSessionList.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,LYLZSessionListType) {
    LYLZSessionListTypeSystem,       // 系统消息
    LYLZSessionListTypePerson,       // 个人消息
    LYLZSessionListTypeInteractive,  // 互动消息
    LYLZSessionListTypeComment,      // 评论消息
};

@interface LYLZSessionList : NSObject

/**
 消息类型
 */
@property(nonatomic,assign) LYLZSessionListType sessionListType;

/**
 对方ID
 */
@property (nonatomic,copy)NSString * targetId;

/**
 对方Name
 */
@property(nonatomic,assign) NSString *targetName;

/**
 消息索引
 */
@property(nonatomic,assign) NSUInteger rowIndex;

@end
