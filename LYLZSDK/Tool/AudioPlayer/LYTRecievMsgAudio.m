//
//  LYTRecievMsgAudio.m
//  LeYingTong
//
//  Created by shangen on 17/1/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "LYTRecievMsgAudio.h"
#import <AudioToolbox/AudioToolbox.h>
static SystemSoundID receiveMsgSuccessed;

@implementation LYTRecievMsgAudio

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initerateAudio];
    });
}

+ (void)initerateAudio {
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"receive_msg"
                                              withExtension:@"caf"];
    OSStatus err = AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                                    &receiveMsgSuccessed);
    if (err != kAudioServicesNoError)
        NSLog(@"Could not load %@, error code: %d", soundURL, (int)err);
}

+ (void)playReciveMsgSuccessed {

    //播放声音
    AudioServicesPlaySystemSound(receiveMsgSuccessed);

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}
+ (void)sourcePlay {
     AudioServicesPlaySystemSound(receiveMsgSuccessed);
}

+ (void)sharkStart
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
