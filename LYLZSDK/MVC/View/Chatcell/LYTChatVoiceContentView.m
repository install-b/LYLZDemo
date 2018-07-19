//
//  LYTChatVoiceContentView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatVoiceContentView.h"
#import "TYHVoiceBubble.h"
#import "LYTVoiceCacheTool.h"
#import "UIView+Frame.h"

@interface LYTChatVoiceContentView()
@property (nonatomic,strong) TYHVoiceBubble *voiceView;
@end

@implementation LYTChatVoiceContentView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.voiceView = [[TYHVoiceBubble alloc] init];
        self.voiceView.durationInsideBubble = YES;
        [self addSubview:self.voiceView];
        self.voiceView.userInteractionEnabled = YES;
        
    }
    return self ;
}

- (void)setupData {
    self.voiceView.width = self.cellFrame.bubbleViewFrame.size.width;
    self.voiceView.height = self.cellFrame.bubbleViewFrame.size.height;
    LYTVoiceMessageBody *voiceBody = (LYTVoiceMessageBody *)self.cellFrame.chartMessage.messageBody;
    self.voiceView.seconds = [NSString stringWithFormat:@"%li",(long)voiceBody.duration];
    if (self.cellFrame.chartMessage.isSender) {
        self.voiceView.invert = YES;
    } else {
        self.voiceView.invert = NO;
    }
    [self downloadVoice];
}

- (void)downloadVoice {
    LYTVoiceMessageBody *voiceMessage = (LYTVoiceMessageBody *)self.cellFrame.chartMessage.messageBody;
    if (voiceMessage.fileUrl) {//从网络获取的录音
        NSString *urlstr = [NSString stringWithFormat:@"%@",voiceMessage.fileUrl];;
        NSURL *fileUrl=[NSURL URLWithString:urlstr];
        if([[LYTVoiceCacheTool shareTools] searchLocalCache:urlstr]){
            
            voiceMessage.localPath = [LYTVoiceCacheTool getVoiceLocalPath:fileUrl];
            
        } else {
            //下载 没有 下载以后 再加载,延迟下载，解决可能不能完成下载完成的问题
            [[LYTVoiceCacheTool shareTools] cacheVoiceWithcontentUrl:fileUrl SuccessBlock:^(NSURL *cacheUrl) {
                //LYTLog(@"通过网络下载了录音，网络地址为%@",cacheUrl);
                voiceMessage.localPath = [LYTVoiceCacheTool getVoiceLocalPath:cacheUrl];
            } errorBlock:^(NSString *error) {
                //LYTLog(@"通过网络下载录音,下载失败");
            }];
        }
    }
}

- (void)stopAnimating {
    [self.voiceView stopAnimating];
}

- (void)startAnimating {
    [self.voiceView startAnimating];
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
