//
//  LYRecordHUD.m
//  LYLink
//
//  Created by Lc on 16/4/6.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYRecordHUD.h"
#import "LYInputAudioRecordIndicatorView.h"
#import "LYAudioRecorderUtil.h"
#import "LYTCommonHeader.h"
#import "HPWYsonry.h"

@interface LYRecordHUD ()

@property (weak, nonatomic) NSTimer *timer;
@property (strong, nonatomic) LYInputAudioRecordIndicatorView *indicatorView;
@property (assign, nonatomic) NSInteger duration;
@property (weak, nonatomic) UILabel *timeLabel;
@property (assign, nonatomic) NSInteger timeLabelText;
@property (assign, nonatomic) NSInteger angle;
@end

@implementation LYRecordHUD

+ (LYRecordHUD *)sharedView {
    static dispatch_once_t once;
    static LYRecordHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[LYRecordHUD alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    });
    return sharedView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self indicatorView];
        self.timeLabelText = 100;
    }
    return self;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:25];
        label.layer.cornerRadius = 15;
        label.layer.masksToBounds = YES;
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        _timeLabel = label;
        [self addSubview:_timeLabel];
        LYWeakSelf
        [_timeLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.width.equalTo(@(30));
            make.top.equalTo(weakSelf.indicatorView.hpwys_bottom).offset (-15);
            make.centerX.equalTo(weakSelf.indicatorView.hpwys_centerX);
        }];
    }
    
    
    
    return _timeLabel;
}

- (LYInputAudioRecordIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[LYInputAudioRecordIndicatorView alloc] init];
        [self addSubview:_indicatorView];
        LYWeakSelf
        [self.indicatorView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.hpwys_centerX);
            make.centerY.equalTo(weakSelf.hpwys_centerY).offset(-50);
            make.width.equalTo(@(LYScreenW * 0.55));
            make.height.equalTo(@(LYScreenW * 0.55));
        }];
    }
    
    _indicatorView.alpha = 1;
    
    return _indicatorView;
}

- (void)showStartRecord
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self timer];
    self.indicatorView.phase = AudioRecordPhaseStart;
}

- (void)showEndRecord
{
    [_timer invalidate];
    _timer = nil;
    self.duration = 0;
    self.timeLabelText = 100;
    self.indicatorView.phase = AudioRecordPhaseEnd;
    [self.timeLabel removeFromSuperview];
    [self removeFromSuperview];
}

- (void)showDragExitRecord
{
    self.indicatorView.phase = AudioRecordPhaseCancelling;
}

- (void)showDragEnterRecord
{
    self.indicatorView.phase = AudioRecordPhaseStart;
}

// 监听音量的变换
- (NSTimer *)timer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
    return _timer;

}
- (void)updateMeters{
    // 录音
    if ([LYAudioRecorderUtil recorder]) {
        [[LYAudioRecorderUtil recorder] updateMeters];
    }
    float peakPower = [[LYAudioRecorderUtil recorder] averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    
    self.indicatorView.value = peakPowerForChannel;
    if (self.indicatorView.phase == AudioRecordPhaseCancelling) {
        return;
    }
    self.indicatorView.phase = AudioRecordPhaseRecording;
    
    self.duration ++;
    if (self.duration * 0.1 > 50.0) {
        [self timeLabel];
        self.timeLabel.text = [NSString stringWithFormat:@"%.f", self.timeLabelText-- * 0.1];
    }
    if (self.duration * 0.1 > 60.0) {
        // 自动发送
        !self.HUDTimerRecordTimeToolong ? : self.HUDTimerRecordTimeToolong();
    }
    if (self.duration * 0.1 > 60.0) {
        // 自动发送
        [[NSNotificationCenter defaultCenter] postNotificationName:@"recordDUrationToolong" object:nil];
    }
}


#pragma mark - 外部调用
+ (void)showStartRecord
{
    [[LYRecordHUD sharedView] showStartRecord];
}

+ (void)showEndRecord
{
    [[LYRecordHUD sharedView] showEndRecord];
}


+ (void)showDragExitRecord
{
    [[LYRecordHUD sharedView] showDragExitRecord];
}

+ (void)showDragEnterRecord
{
    [[LYRecordHUD sharedView] showDragEnterRecord];
}

@end
