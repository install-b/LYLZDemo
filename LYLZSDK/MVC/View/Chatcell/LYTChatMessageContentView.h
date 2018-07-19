//
//  LYTChatMessageContentView.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYTChatMessageCellFrame.h"

@class LYTChatMessageContentView;

@protocol LYTChatMessageContentViewDelegate <NSObject>

// 点击按钮
- (void)chatCellTapPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel;

// 长按
- (void)chartCellLongPress:(LYTChatMessageContentView *)contentView content:(LYTChatMessageCellFrame *)frameModel;

@end

@interface LYTChatMessageContentView : UIControl

@property (nonatomic,assign) id<LYTChatMessageContentViewDelegate> delegate;

@property (nonatomic,strong) LYTChatMessageCellFrame *cellFrame;

//设置数据
- (void)setupData;

/** 长按 */
- (void)longTap:(UILongPressGestureRecognizer *)tapGestureRecognizer;

@end
