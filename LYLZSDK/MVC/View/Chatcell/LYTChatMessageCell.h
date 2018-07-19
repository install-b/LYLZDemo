//
//  LYTChatMessageCell.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYTChatMessageContentView.h"

@class LYTChatMessageCellFrame,LYTChatMessageCell;

@protocol LYTChatMessageCellDelegate <NSObject>
@optional
// 点击按钮
-(void)messageCell:(LYTChatMessageCell *)messageCell chatCellTapPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel;
// 长按
-(void)messageCell:(LYTChatMessageCell *)messageCell chartCellLongPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel;

/** 重发 */
-(void)messageCell:(LYTChatMessageCell *)messageCell onRetryContent:(LYTChatMessageCellFrame *)frameModel;

// 复制
- (void)messageCellCopy:(LYTChatMessageCell *)messageCell;

// 删除
- (void)messageCellDelete:(LYTChatMessageCell *)messageCell;

// 点击阅后即焚蒙版
-(void)messageCell:(LYTChatMessageCell *)messageCell clickBurnMark:(UIView *)burnMark content:(LYTChatMessageCellFrame *)frameModel;
@end

@interface LYTChatMessageCell : UITableViewCell

@property (nonatomic,strong) LYTChatMessageContentView *bubbleView;           //内容区域

@property (nonatomic,strong) LYTChatMessageCellFrame *cellFrame;

@property (nonatomic,weak) id<LYTChatMessageCellDelegate> delegate;


+ (instancetype)cellInTable:(UITableView*)tableView forMessageMode:(LYTChatMessageCellFrame *)model;

@end
