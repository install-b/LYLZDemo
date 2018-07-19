//
//  LYTChatMessageCellFrame.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatMessageCellFrame.h"
#import "MLEmojiLabel.h"
#import "LZSystemMessageTableViewCell.h"

#import "SGDownloadManager.h"



#define kIconMarginX 6
#define kIconMarginY 2.5
#define kTipMaxWidth 240.0f

CGFloat contactImageViewH = 160;
CGFloat contactImageViewW = 120;

#import "UIView+Frame.h"

@interface LYTChatMessageCellFrame ()

@end

@implementation LYTChatMessageCellFrame

- (instancetype)initWithChartModel:(LYTMessage *)message {

    if (self = [super init]) {
        self.chartMessage = message;
    }
    return self;
}

- (void)setChartMessage:(LYTMessage *)chartMessage {
    
    LYTVoiceMessageBody *voiceBody = (LYTVoiceMessageBody *)chartMessage.messageBody;
    if ([chartMessage.messageBody isKindOfClass:LYTVoiceMessageBody.class] && voiceBody.audioUrl) {
        
        [[SGDownloadManager shareManager] downloadWithURL:[NSURL URLWithString:voiceBody.audioUrl] complete:^(NSDictionary *respose, NSError *error) {
            
            voiceBody.localPath = respose[@"filePath"];
            
        }];
        
    }
    
    _chartMessage = chartMessage;
    CGSize winSize = [UIScreen mainScreen].bounds.size;
    CGFloat iconX;
    CGFloat iconY = kIconMarginY;
    CGFloat iconWidth = 40;
    CGFloat iconHeight = 40;
    CGFloat voicew = [self calculateVoiceWwithModel:chartMessage];
    CGFloat voiceh = 40;
    
    CGFloat imageX;
    CGFloat contentX;
    CGFloat voiceX;
    CGFloat contentY=iconY;
    CGSize contentSize = contentSizeOftext(chartMessage);
    if (contentSize.width <= 40) {
        contentSize.width = 40;
    }
    
    //确定消息展示在cell的哪边
    if(!chartMessage.isSender){
        iconX = kIconMarginX;
        self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
        contentX = CGRectGetMaxX(self.iconRect)+kIconMarginX;
        voiceX = CGRectGetMaxX(self.iconRect) + kIconMarginX;
        imageX = CGRectGetMaxX(self.iconRect) + kIconMarginX;
    } else {
        iconX = winSize.width - kIconMarginX - iconWidth;
        self.iconRect = CGRectMake(iconX, iconY, iconWidth, iconHeight);
        contentX = iconX - kIconMarginX - contentSize.width - 35;
        voiceX = iconX - kIconMarginX-voicew;
        imageX = iconX - contactImageViewW - kIconMarginX ;
    }
    
    if (chartMessage.messageType > 3900) {
        if (chartMessage.messageType == LYLZmessageBodyTypeOrder) {
            self.messageBody = [[LYLZOrderMessageBody alloc] initWithContent:chartMessage.content];
            
        } else if (chartMessage.messageType == LYLZmessageBodyTypeRedPacket) {
            
            self.messageBody = [[LYLZRedPacketMessageBody alloc] initWithContent:chartMessage.content];
            
        } 
        self.cellHeight = calculateSystemCellHeightWithBody(self.messageBody);
        return;
    }
    
    
    LYTMessageType bodyType = chartMessage.messageBody.bodyType;
    
    switch (bodyType) {
        case LYTMessageTypeVoice: {
            self.bubbleViewFrame = CGRectMake(voiceX, contentY, voicew, voiceh);
            self.cellHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.bubbleViewFrame)) + kIconMarginY;
        } break;
            
        case LYTMessageTypeImage: {
            self.bubbleViewFrame = CGRectMake(imageX, contentY, contactImageViewW, contactImageViewH);
            self.cellHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.bubbleViewFrame)) + kIconMarginY ;
        } break;
            
//        case LYTMessageTypeTipMsg:{
//            // code here caculat cell height...
////#warning #error code here caculat cell height...
//            CGFloat height =  calculateTipContentWithModel(self);
//            self.bubbleViewFrame = CGRectMake(iconX-kIconMarginX- kTipMaxWidth, contentY, kTipMaxWidth, height);
//            self.cellHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.bubbleViewFrame)) + kIconMarginY + 70;
//        }break;
        case LYTMessageTypeFile: {
            contentX = chartMessage.isSender ? ( imageX = iconX- kTipMaxWidth - kIconMarginX ) : (CGRectGetMaxX(self.iconRect) + kIconMarginX);
            self.bubbleViewFrame = CGRectMake(contentX, contentY, kTipMaxWidth, [self fileContentViewHeight]);
            self.cellHeight = CGRectGetMaxY(self.bubbleViewFrame) + kIconMarginY ;
        } break;
            
        case LYTMessageTypeText: {
            self.bubbleViewFrame = CGRectMake(contentX, contentY,contentSize.width + 35 , contentSize.height + 20);
            self.cellHeight = MAX(CGRectGetMaxY(self.iconRect), CGRectGetMaxY(self.bubbleViewFrame)) + kIconMarginY;
        } break;
            
        default: {
            //LYTLog(@"未知的消息类型");
        } break;
    }
}

#pragma mark - 计算高度
- (CGFloat)calculateVoiceWwithModel:(LYTMessage *)chartMessage
{
    //default 40  每一秒多3点
    if (chartMessage.messageType != LYTMessageTypeVoice) return 0;
    LYTVoiceMessageBody *voiceMessageBody = (LYTVoiceMessageBody *)chartMessage.messageBody;
    CGFloat addW = voiceMessageBody.duration * 3;
    return  addW > 180 ? 180 + 65 :addW + 65;
}


- (CGFloat)fileContentViewHeight {
    return 78.0f;
}

static CGFloat calculateSystemCellHeightWithBody(LYLZmessageBody *messageBody) {
    static UITableView *testTableView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testTableView = [[UITableView alloc] init];
    });
    LZSystemMessageTableViewCell *cell = [LZSystemMessageTableViewCell cellInTable:testTableView forMessageMode:messageBody];
    
    return cell.cellHeight;
}

static CGSize contentSizeOftext(LYTMessage *message) {
    static MLEmojiLabel * contentLabel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        contentLabel=[MLEmojiLabel new];
        //下面是自定义表情正则和图像plist的例子
        contentLabel.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        contentLabel.customEmojiPlistName = @"ClippedExpression.bundle/expression.plist";
        contentLabel.customEmojiBundleName = @"ClippedExpression";
        contentLabel.isNeedAtAndPoundSign = YES;
        contentLabel.numberOfLines = 0;
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont boldSystemFontOfSize:16];
    });
    
    contentLabel.text = (LYTTextMessageBody *)message.messageBody.showText;
    return  [contentLabel preferredSizeWithMaxWidth:200];
}



@end
