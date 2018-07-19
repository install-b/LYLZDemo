//
//  LYInputAudioRecordIndicatorView.h
//  TaiYangHua
//
//  Created by Vieene on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NIMAudioRecordPhase) {
    AudioRecordPhaseStart,
    AudioRecordPhaseRecording,
    AudioRecordPhaseCancelling,
    AudioRecordPhaseEnd
    
};

@interface LYInputAudioRecordIndicatorView : UIView

@property (nonatomic, assign) NIMAudioRecordPhase phase;
//音量值
@property (nonatomic, assign) CGFloat value;

@end
