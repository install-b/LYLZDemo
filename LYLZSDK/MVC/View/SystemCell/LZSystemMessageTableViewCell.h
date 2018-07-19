//
//  LZSystemMessageTableViewCell.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYTChatMessageCellFrame.h"
#define contentYMargin 15
#define contentXMargin 12
#define textMargin 10
#define btnHeight 40

#define orderWith LYScreenW * 0.666667

#define titleFont [UIFont systemFontOfSize:16]
#define bodyFont [UIFont systemFontOfSize:13]
#define tailFont [UIFont systemFontOfSize:13]

@class LZChatMessageOrderCell;
@protocol LYTChatMessageOrderCellDelegate <NSObject>
@optional

- (void)chatMessageOrderCell:(LZChatMessageOrderCell *)orderCell didClickJumpWithInfo:(id)jumpInfo;

@end

@interface LZSystemMessageTableViewCell : UITableViewCell
+ (instancetype)cellInTable:(UITableView*)tableView forMessageMode:(LYLZmessageBody *)model;

/**  */
@property (nonatomic,strong) LYLZmessageBody * cellFrame;

/** delegate */
@property (nonatomic,weak) id<LYTChatMessageOrderCellDelegate> delegate;

- (CGFloat)cellHeight;

@end
