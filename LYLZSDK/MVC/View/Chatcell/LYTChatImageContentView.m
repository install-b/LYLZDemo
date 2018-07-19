//
//  LYTChatImageContentView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatImageContentView.h"
#import "LYTChatImageView.h"
#import "UIView+Frame.h"

@interface LYTChatImageContentView()

//@property (nonatomic,strong) LYTChatImageView *photoView;

@end
@implementation LYTChatImageContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoView = [[LYTChatImageView alloc]init];
        [self addSubview:_photoView];
        _photoView.userInteractionEnabled = YES;
    }
    return self ;
}
- (void)setupData
{
    _photoView.chatMessage = self.cellFrame.chartMessage;
    _photoView.width = self.cellFrame.bubbleViewFrame.size.width;
    _photoView.height = self.cellFrame.bubbleViewFrame.size.height;
    
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if ( tapGestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    if([self.delegate respondsToSelector:@selector(chatCellTapPress:content:)]){
        [self.delegate chatCellTapPress:self content:self.cellFrame];
    }
}

@end
