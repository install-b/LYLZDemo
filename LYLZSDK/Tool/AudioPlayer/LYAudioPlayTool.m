//
//  LYAudioPlayTool.m
//  TaiYangHua
//
//  Created by Lc on 16/1/25.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYAudioPlayTool.h"
#import "LYTSDK.h"
#import "LYCDDeviceManager.h"
#import "NSString+LYMessageStr.h"

static UIImageView *animatingImageView;

// 判断上一个是否正在播放
static LYTVoiceMessageBody *lastVoiceMessage;

typedef void(^VoicePlayCompleted)(LYTVoiceMessageBody *voiceMessage);
static VoicePlayCompleted lastVoiceCompleted;

@implementation LYAudioPlayTool

+ (void)playVoiceMessage:(LYTVoiceMessageBody *)voiceMsg completed:(void (^)(LYTVoiceMessageBody *voiceMessage))completed {
    // 停止当前播放中的语音
    if ([[LYCDDeviceManager sharedInstance] isPlaying]) {
        [self stop];
        
        if (voiceMsg == lastVoiceMessage) {
            return;
        }
    }
    NSString *downloadURL = nil;
    if ([voiceMsg.audioUrl hasPrefix:@"http:"]) {  // 根据服务器返回结果判断.....
        downloadURL = voiceMsg.audioUrl;
    } else {
//        downloadURL = [NSString stringWithFormat:@"%@%@.mp3", kLYAppVoiceURLDownload, voiceMsg.audioUrl];
    }
    NSString *cachesPath = [NSString recordFileNameWithFileURL:downloadURL];
    NSString *path = cachesPath;
    lastVoiceMessage = voiceMsg;
    lastVoiceCompleted = completed;
    // 文件不存在不播放
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) return;
    [[LYCDDeviceManager sharedInstance] asyncPlayingWithPath:path completion:^(NSError *error) {
        completed(voiceMsg);
    }];
}

+ (void)stop
{
    lastVoiceMessage.playing = NO;
    [[LYCDDeviceManager sharedInstance] stopPlaying];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kReloadVoiceTableViewCellNotification" object:lastVoiceMessage];
    if (lastVoiceCompleted) {
        lastVoiceCompleted(lastVoiceMessage);
    }
}

+ (void)playingImageView
{
    [animatingImageView startAnimating];
}

+ (void)stopPlayingImageView
{
    [animatingImageView stopAnimating];
}
@end
