//
//  LYTChatTextContentView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatTextContentView.h"
#import "LYTChatContentView.h"

#import "UIView+Frame.h"

@interface LYTChatTextContentView()
@property (nonatomic,strong) LYTChatContentView *chatView;
@end
@implementation LYTChatTextContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _chatView = [[LYTChatContentView alloc]init];
        [self addSubview:_chatView];
        _chatView.userInteractionEnabled = NO;
    }
    return self ;
}

- (void)setupData {
    _chatView.chatMessage = self.cellFrame.chartMessage;
    _chatView.width = self.cellFrame.bubbleViewFrame.size.width;
    _chatView.height = self.cellFrame.bubbleViewFrame.size.height;
}

- (void)longTap:(UILongPressGestureRecognizer *)tapGestureRecognizer {
    [super longTap:tapGestureRecognizer];
    
    //判断手势状态,防止该方法不停重复调用
    if (tapGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if([self.delegate respondsToSelector:@selector(chartCellLongPress:content:)]){
            [self.delegate chartCellLongPress:self content:self.cellFrame];
        }
    }
    
}
@end
