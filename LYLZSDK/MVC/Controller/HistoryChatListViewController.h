//
//  LYTLZBaseChatViewController.h
//  LZSDKDemo
//
//  Created by hhly on 2017/8/30.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryChatListViewController : UIViewController

/**
 头部的视图
 */
@property (nonatomic, strong) UIView *headView;


/**
 会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

 /*聊天用户的ID
 */
@property (nonatomic, copy) NSString *userId;

/**
 聊天律师的ID
 */
@property (nonatomic, copy) NSString *lawyerId;

/**
 消息的起始索引
 */
@property (nonatomic, assign) NSInteger fromIndex;

/**
 每次查询的消息条数
 */
@property (nonatomic, assign) NSInteger chartCount;

/**
 消息界面的坐标y值
 */
@property (nonatomic, assign) CGFloat listViewY;

/**
 消息界面与屏幕底部的距离
 */
@property (nonatomic, assign) CGFloat bottomMargin;

/**
 第一条消息在左边展示或者右边展示
 */
@property (nonatomic, assign) BOOL isLeft;


/**
 设置第一条消息距头部视图的距离
 */
@property (nonatomic, assign) CGFloat headMargin;

@end
