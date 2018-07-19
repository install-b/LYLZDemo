//
//  LYTContacetChatContentView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatContentView.h"
#import "MLEmojiLabel.h"

#import "UIColor+LYColor.h"
#import "LYTSDK.h"


#define kContentStartMargin 25

@interface LYTChatContentView()

@property (nonatomic,strong) MLEmojiLabel *contentLabel;

@end
@implementation LYTChatContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView=[[UIImageView alloc]init];
        self.backImageView.userInteractionEnabled=YES;
        [self addSubview:self.backImageView];
        [self contentLabel];

    }
    return self;
}
- (MLEmojiLabel *)contentLabel{
    if (_contentLabel == nil) {
        _contentLabel=[MLEmojiLabel new];
        //下面是自定义表情正则和图像plist的例子
        _contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        _contentLabel.customEmojiPlistName = @"ClippedExpression.bundle/expression.plist";
         //@"Frameworks/LYLZSDK.framework/ClippedExpression.bundle/expression.plist";
        _contentLabel.customEmojiBundleName = @"ClippedExpression";
        _contentLabel.isNeedAtAndPoundSign = YES;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:_contentLabel];
    }
    return _contentLabel;
}
- (void)setChatMessage:(LYTMessage *)chatMessage
{
    
    
    _chatMessage = chatMessage;
    UIColor *color ;
    if (chatMessage.isSender) {
        color = [UIColor whiteColor];
    }else{
        color = [UIColor getColor:@"333333"];
    }
    [self setFontColor];
    LYTTextMessageBody *textBody = (LYTTextMessageBody *)chatMessage.messageBody;
    self.contentLabel.text = textBody.showText;
    
}
- (void)setFontColor
{
    if (self.chatMessage.isSender) {
        self.contentLabel.textColor = [UIColor whiteColor];
    }else{
        self.contentLabel.textColor = [UIColor getColor:@"333333"];
    }
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backImageView.frame=self.bounds;
    CGFloat contentLabelX=0;
    
    if(self.chatMessage.isSender){
        contentLabelX=kContentStartMargin*0.5;
    }else{
        contentLabelX=kContentStartMargin*0.85;
    }
    self.contentLabel.frame=CGRectMake(contentLabelX, 0, self.frame.size.width-kContentStartMargin-5, self.frame.size.height);
}

@end
