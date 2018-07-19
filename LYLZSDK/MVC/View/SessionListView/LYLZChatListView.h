//
//  LYLZChatListView.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYLZSessionList.h"

@protocol LYLZChatListViewDelegate;
@interface LYLZChatListView : UIView

/** delegate */
@property (nonatomic,weak) id<LYLZChatListViewDelegate> delegate;


/**
 刷新列表
 */
- (void)reloadData;

@end


@protocol LYLZChatListViewDelegate <NSObject>


/**
 点击了list列表回调

 @param chatListView 消息列表视图
 @param sessionList 列表模型
 */
- (void)chatListView:(LYLZChatListView *)chatListView didSelectedSessionList:(LYLZSessionList *)sessionList;


/**
 点击删除列表时是否需要清空聊天数据库

 @param chatListView  消息列表视图
 @param list 消息列表
 @return YES 表示清理 NO表示 不清理 （默认不清理）
 */
- (BOOL)shoudEmptyConversationWitChatListView:(LYLZChatListView *)chatListView whenDeleteList:(LYLZSessionList *)list;


@end
