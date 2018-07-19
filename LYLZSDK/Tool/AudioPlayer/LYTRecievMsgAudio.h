//
//  LYTRecievMsgAudio.h
//  LeYingTong
//
//  Created by shangen on 17/1/19.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYTRecievMsgAudio : NSObject


/**
 收到消息播放声音及震动
 */
+ (void)playReciveMsgSuccessed;


/**
 播放声音
 */
+ (void)sourcePlay;


/**
 震动
 */
+ (void)sharkStart;

@end
