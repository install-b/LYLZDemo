//
//  LYAudioPlayTool.h
//  TaiYangHua
//
//  Created by Lc on 16/1/25.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYTVoiceMessageBody;

@interface LYAudioPlayTool : NSObject

/**
 播放语音

 @param completed 完成回调
 */
+ (void)playVoiceMessage:(LYTVoiceMessageBody *)voiceMsg completed:(void (^)(LYTVoiceMessageBody *voiceMessage))completed;

+ (void)stop;

+ (void)playingImageView;

+ (void)stopPlayingImageView;
@end
