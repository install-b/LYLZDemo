//
//  LYTMessageTipView.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/9.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYTMessageTipView.h"
#import "LYTCommonHeader.h"
#import "MLEmojiLabel.h"

NSString  * const LYTMessageTipViewFrameWillChangeNoti = @"LYTMessageTipViewFrameWillChangeNoti";

@interface LYTMessageTipView ()

/** 消息展示标签 */
@property (nonatomic,weak) UILabel * promptLabel;

/** <#des#> */
@property (nonatomic,weak) NSTimer * timer;

/** <#des#> */
@property (nonatomic,strong) LYTMessage * currentMessage;

/** <#des#> */
@property(nonatomic,assign,getter=isHiddenSelf) BOOL hiddenSelf;
@end

@implementation LYTMessageTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self initializedSubviews];
    }
    return self;
}

- (void)initializedSubviews {
    LYWeakSelf
    [self.promptLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(12);
        make.trailing.equalTo(weakSelf).offset(-12);
    }];
    self.hiddenSelf = YES;
    self.backgroundColor = [UIColor whiteColor];
    self.userInteractionEnabled = YES;
}

#pragma mark - 
#define animaTime 0.25
- (void)showInSuperView {
    if (self.isHiddenSelf == NO) {
        return;
    }
    self.hiddenSelf = NO;
    self.hidden = NO;
   
    [self postMessageTipViewFrameChangedWithHeight:self.height duration:animaTime];
    [UIView animateWithDuration:animaTime animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.bounds));
    }];
}

- (void)hideFromSuperView {
    [self postMessageTipViewFrameChangedWithHeight:0 duration:animaTime];
    self.hiddenSelf = YES;
    [UIView animateWithDuration:animaTime animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}

- (void)postMessageTipViewFrameChangedWithHeight:(CGFloat)height duration:(NSTimeInterval)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:LYTMessageTipViewFrameWillChangeNoti object:nil userInfo:@{@"height" : @(height),@"duration" : @(duration)}];
    
}

#pragma mark - 
- (void)showWithMessage:(LYTMessage *)message {
    
    self.promptLabel.text = [self tipStringWithMessage:message];
    self.currentMessage = message;
    [self showInSuperView];
    [self startTimerHiddenSelfWithDuration:[self timeIntervalForMessage:message]];
}

#pragma mark - 定时隐藏
- (void)startTimerHiddenSelfWithDuration:(NSTimeInterval)duration {
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideFromSuperView) userInfo:nil repeats:NO];
}

#pragma mark - 提示消息内容及时间  用于 子类重写
- (NSTimeInterval)timeIntervalForMessage:(LYTMessage *)message {
    return 3.5f;
}

- (NSString *)tipStringWithMessage:(LYTMessage *)message {
    NSString *userName = message.sendUserName ? : self.userName;
    switch (message.messageType) {
        case LYTMessageTypeText:
            if (userName.length) {
                return [NSString stringWithFormat:@"%@: %@",userName,[(LYTTextMessageBody *)message.messageBody text]];
            } else {
                return [NSString stringWithFormat:@"%@",[(LYTTextMessageBody *)message.messageBody text]];
            }
            break;
        case LYTMessageTypeImage:
            if (userName.length) {
                return [NSString stringWithFormat:@"%@: 发来一张[图片]",userName];
            } else {
                 return [NSString stringWithFormat:@"发来一张[图片]"];
            }
            
        case LYTMessageTypeVoice:
            if (userName.length) {
                return [NSString stringWithFormat:@"%@: 发来一条[语音]",userName];
            } else {
                return [NSString stringWithFormat:@"发来一条[语音]"];
            }
            
        case LYTMessageTypeFile:
            if (userName.length) {
                return [NSString stringWithFormat:@"%@: 发来一个文件‘%@’",userName,[(LYTFileMessageBody *)message.messageBody fileName]];
            } else {
                return [NSString stringWithFormat:@"发来一个文件‘%@’",[(LYTFileMessageBody *)message.messageBody fileName]];
            }
            
        case (LYTMessageType)3999:
            return @"收到一条系统消息";
        default:
            break;
    }
    if (userName.length) {
         return [NSString stringWithFormat:@"%@: 发来一条消息",userName];
    } else {
         return [NSString stringWithFormat:@"发来一条消息"];
    }
   
}

#pragma mark - Lazy
- (UILabel *)promptLabel {
    if (!_promptLabel) {
        MLEmojiLabel *emojiLable = [MLEmojiLabel new];
        //_contentLabel = emojiLable;
        //下面是自定义表情正则和图像plist的例子
        emojiLable.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        emojiLable.customEmojiPlistName = @"ClippedExpression.bundle/expression.plist";
        emojiLable.customEmojiBundleName = @"ClippedExpression";
        emojiLable.isNeedAtAndPoundSign = YES;
        emojiLable.numberOfLines=0;
        emojiLable.textAlignment=NSTextAlignmentLeft;
        emojiLable.font = [UIFont systemFontOfSize:12];
        emojiLable.textColor = [UIColor getColor:@"22aeff" alpha:1];
        _promptLabel = emojiLable;
        [self addSubview:_promptLabel];
    }
    return _promptLabel;
}


@end
