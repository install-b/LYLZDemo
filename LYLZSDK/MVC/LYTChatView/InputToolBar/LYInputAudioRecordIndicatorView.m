//
//  NIMInputAudioRecordIndicatorView.h
//  TaiYangHua
//
//  Created by Vieene on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import "LYInputAudioRecordIndicatorView.h"
#import "HPWYsonry.h"
#import "UIImage+Utility.h"
#import "LYTCommonHeader.h"
#import "UIView+Frame.h"
#import "UIImage+BundleImage.h"

static CGFloat NIMKit_ViewWidth;

static CGFloat NIMKit_TipFontSize;

@interface LYInputAudioRecordIndicatorView(){
    UIImageView *_backgrounView;
    UIImageView *_tipImageView;
}


@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation LYInputAudioRecordIndicatorView
- (instancetype)init {
    self = [super init];
    if(self) {
        NIMKit_ViewWidth = LYScreenW * 0.55;
        _backgrounView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithWhite:0.392 alpha:1.000]];
        _backgrounView.image = image;
        _backgrounView.alpha = 0.3f;
        self.layer.cornerRadius = NIMKit_ViewWidth /2.0;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self addSubview:_backgrounView];
        _tipImageView = [[UIImageView alloc] init];
        
        [self addSubview:_tipImageView];
        
        if (iPhone4S || iPhone5 ) {
            NIMKit_TipFontSize = 13;
        }else{
            NIMKit_TipFontSize = 15;
        }
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipLabel.font = [UIFont systemFontOfSize:NIMKit_TipFontSize];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = @"手指上滑，取消发送";
        [self addSubview:_tipLabel];
        
        
        
        self.phase = AudioRecordPhaseStart;
    }
    return self;
}


- (void)setValue:(CGFloat)value
{
    _value = value;
    if (self.phase == AudioRecordPhaseCancelling) {
        return;
    }
    if (value < 0.1 ) {
        _tipImageView.image = [UIImage lyt_chatImageNamed:@"value1"];

        return;
    }
    if (value < 0.15) {
        _tipImageView.image = [UIImage lyt_chatImageNamed:@"value2"];

        return;
    }
    if (value < 0.25) {
        _tipImageView.image = [UIImage lyt_chatImageNamed:@"value3"];

        return;
    }
    if (value < 0.35) {
        _tipImageView.image = [UIImage lyt_chatImageNamed:@"value4"];

        return;
    }
    if (value < 0.9 ) {
        _tipImageView.image = [UIImage lyt_chatImageNamed:@"value5"];
        return;
    }
    
    
}
- (void)setPhase:(NIMAudioRecordPhase)phase {
    _phase = phase;
    switch (phase) {
        case AudioRecordPhaseStart:
        {
            self.hidden = NO;
            _tipImageView.image = [UIImage lyt_chatImageNamed:@"value0"];
            _tipLabel.layer.cornerRadius = 8;
            _tipLabel.layer.masksToBounds = YES;
            _tipLabel.alpha = 1;
            _tipLabel.backgroundColor = [UIColor clearColor];
            _tipLabel.text = @"手指上滑，取消发送";
        }
            break;
        case AudioRecordPhaseRecording:{
            _tipLabel.layer.cornerRadius = 8;
            _tipLabel.layer.masksToBounds = YES;
            _tipLabel.alpha = 1;
            _tipLabel.backgroundColor = [UIColor clearColor];
            _tipLabel.text = @"手指上滑，取消发送";

        }break;
            case AudioRecordPhaseCancelling:
        {
            _tipLabel .text =  @"松开手指，取消发送";
            _tipLabel.layer.cornerRadius = 8;
            _tipLabel.layer.masksToBounds = YES;
            _tipLabel.backgroundColor = [UIColor colorWithRed:0.996 green:0.188 blue:0.000 alpha:1.000];
            _tipLabel.alpha = 0.7;
            _tipImageView.image = [UIImage lyt_chatImageNamed:@"voicecancle"];

        } break;
            case AudioRecordPhaseEnd:
        {
            self.hidden = YES;
        }break;
    }

}


- (void)layoutSubviews {
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [_backgrounView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(weakSelf.hpwys_top);
        make.left.equalTo(weakSelf.hpwys_left);
        make.right.equalTo(weakSelf.hpwys_right);
        make.bottom.equalTo(weakSelf.hpwys_bottom);
    }];
    
    [_tipImageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.hpwys_centerX);
        make.centerY.equalTo(weakSelf.hpwys_centerY).offset(-15);
        make.width.equalTo(@(NIMKit_ViewWidth * 0.5));
        make.height.equalTo(@(NIMKit_ViewWidth * 0.5));
    }];
    
    _tipImageView.backgroundColor = [UIColor clearColor];
    [_tipLabel hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(_tipImageView.hpwys_bottom).offset(15);
        make.centerX.equalTo(weakSelf.hpwys_centerX);
        make.width.equalTo(@(NIMKit_ViewWidth * 0.7));
    }];
    _tipLabel.backgroundColor = [UIColor clearColor];
}


@end
