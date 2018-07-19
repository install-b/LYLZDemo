//
//  LYInputEmotionViewCell.m
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#define column 7
#define row 3

#import "LYInputEmotionViewCell.h"
#import "LYEmotion.h"
#import "LYTCommonHeader.h"
#import "UIView+Frame.h"
#import "UIImage+BundleImage.h"


@implementation LYInputEmotionViewCell

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    CGFloat width = 38;
    if (iPhone4S || iPhone5) {
        width = 33;
    };
    if (iPhone6s) {
        width = 35;
    }
    CGFloat height = width;
    
    CGFloat columnMargin = (self.contentView.width - width * column) / (column + 1);
    CGFloat rowMargin = (self.contentView.height - height * row) / (row + 1);
    
    for (int i = 0; i < emotions.count + 1; i++) {
        UIButton *button = [[UIButton alloc] init];
        
        CGFloat x = i % column * (width + columnMargin) + columnMargin;
        CGFloat y = i / column * (height + rowMargin) + rowMargin;
        button.frame = CGRectMake(x, y, width, height);
        
        if (i == self.emotions.count) {
            
            [button addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage lyt_emotionImageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
            [self.contentView addSubview:button];
            
            return;
        }
        
        LYEmotion *emotion = self.emotions[i];
        
        [button addTarget:self action:@selector(clickEmotion:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage lyt_emotionImageNamed:emotion.png] forState:UIControlStateNormal];
        button.tag = i;
        [self.contentView addSubview:button];
    }
}

- (void)clickEmotion:(UIButton *)button {
    LYEmotion *emotion = self.emotions[button.tag];
    if ([self.delegate respondsToSelector:@selector(inputEmotionCell:didClickEmotion:)]) {
        [self.delegate inputEmotionCell:self didClickEmotion:emotion];
    }
}

// 删除
- (void)clickDeleteButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(inputEmotionCellClickDeleteEmotion:)]) {
        [self.delegate inputEmotionCellClickDeleteEmotion:self];
    }
}

@end
