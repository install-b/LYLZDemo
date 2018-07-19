//
//  LYTChatMessageCellFrame.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYLZRedPacketMessageBody.h"
#import "LYLZOrderMessageBody.h"
#import "LYLZSDK.h"
@class LYTChatMessageCellFrame;
@protocol LYTChatMessageCellFrameDestrucDelegate <NSObject>

- (void)chatMessageModelWillDelete:(LYTChatMessageCellFrame *)model;

- (void)chatMessageModelWillRefreshStatu:(LYTChatMessageCellFrame *)model;

@end


@interface LYTChatMessageCellFrame : NSObject

- (instancetype)initWithChartModel:(LYTMessage *)message;

@property (nonatomic,strong) LYTMessage *chartMessage;

@property (nonatomic,assign) CGRect iconRect;

@property (nonatomic,assign) CGRect bubbleViewFrame;

@property (nonatomic, assign) CGFloat cellHeight; //cell高度

@property (nonatomic,weak) id <LYTChatMessageCellFrameDestrucDelegate> destrucDelegate;

@property (nonatomic,strong) LYLZmessageBody * messageBody;
@end
