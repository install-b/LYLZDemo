//
//  FSVoiceBubble.h
//  Pods
//
//  Created by Wenchao Ding on 3/25/15.
//
//

#import <UIKit/UIKit.h>

@class TYHVoiceBubble;

#ifndef IBInspectable
#define IBInspectable
#endif

@protocol FSVoiceBubbleDelegate <NSObject>

- (void)voiceBubbleDidStartPlaying:(TYHVoiceBubble *)voiceBubble;

@end

@interface TYHVoiceBubble : UIView

@property (strong, nonatomic)  UIColor *textColor;
@property (strong, nonatomic)  UIColor *waveColor;
@property (strong, nonatomic)  UIColor *animatingWaveColor;
@property (strong, nonatomic)  UIImage *bubbleImage;
@property (assign, nonatomic)  BOOL    invert;//反向
@property (assign, nonatomic)  BOOL    exclusive;  //
@property (assign, nonatomic)  BOOL    durationInsideBubble;
@property (assign, nonatomic)  CGFloat waveInset;
@property (assign, nonatomic)  CGFloat textInset;
@property (assign, nonatomic)  id<FSVoiceBubbleDelegate> delegate;
@property (nonatomic,copy)NSString * seconds;//时长，用于在线下载音频时候
@property (readonly, getter=isPlaying) BOOL playing;

- (void)startAnimating;
- (void)stopAnimating;

@end
