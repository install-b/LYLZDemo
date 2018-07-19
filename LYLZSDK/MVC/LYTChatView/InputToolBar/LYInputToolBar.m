//
//  LYInputToolBar.m
//  LYLink
//
//  Created by SYLing on 2016/12/17.
//  Copyright © 2016年 HHLY. All rights reserved.
//
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVFAudio.h>
#import "LYInputToolBar.h"
#import "LYEmotionInputView.h"
#import "LYMoreInputView.h"
#import "LYRecordHUD.h"
#import "LYCDDeviceManager.h"
#import "LYTCommonHeader.h"

#import "HPWYsonry.h"
#import "LYTCommonHeader.h"
#import "UIImage+Utility.h"
#import "UIColor+LYColor.h"
#import "UIView+Frame.h"
#import "NSString+LYMessageStr.h"
#import "UIImage+BundleImage.h"

#define maxTextLength 500

// 输入框高度
static CGFloat textViewH = 0;
static CGFloat mintextViewH = 26;
static CGFloat maxtextViewH = 74;


@interface LYInputToolBar()<UITextViewDelegate,LYMoreInputViewDelegate>

@property (weak, nonatomic) UIButton *voiceButton;   // 录音按钮
@property (weak, nonatomic) UIButton *emotionButton; // 表情按钮
@property (weak, nonatomic) UIButton *addButton;     // 添加更多 按钮
@property (weak, nonatomic) UIView *separatorView;   // 分割线
@property (weak, nonatomic) UIButton *recordButton;  // 开始录音按钮
// 更多键盘
@property (weak, nonatomic) LYMoreInputView *inputAddView;
// 表情键盘
@property (weak, nonatomic) LYEmotionInputView *inputEmotionView;

/** 录音是否时间过长 */
@property (assign, nonatomic) BOOL durationToolong;
@end
@implementation LYInputToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initalized];
    }
    return self;
}

#pragma mark - 初始化
- (void)initalized {
    self.backgroundColor = [UIColor whiteColor];
    // 添加子控件
    [self textView];
    [self voiceButton];
    [self emotionButton];
    [self addButton];
    // 发送按钮
    [self sendButton];
    [self separatorView];
    // 开始录音按钮
    [self recordButton];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    LYWeakSelf
    [LYRecordHUD sharedView].HUDTimerRecordTimeToolong = ^{
        weakSelf.recordButton.tag = 60;
        [self endRecord:weakSelf.recordButton];
        weakSelf.durationToolong = YES;
    };
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 布局控件
    [self layoutSubBtns];
}

- (void)layoutSubBtns {
    LYWeakSelf
    
    CGSize btnSize = CGSizeMake(34, 44);
    
    [self.voiceButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(5);
        make.centerY.equalTo(weakSelf);
        if ([weakSelf.delegate respondsToSelector:@selector(inputToolBarShouldShowVoiceBtn:)] &&
            ![weakSelf.delegate inputToolBarShouldShowVoiceBtn:weakSelf]) {
            make.size.hpwys_equalTo(CGSizeZero);
        }else {
             make.size.hpwys_equalTo(btnSize);
        }
       
    }];
    
    [self.addButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.trailing.equalTo(weakSelf).offset(-5);
        make.centerY.equalTo(weakSelf);
        if ([weakSelf.delegate respondsToSelector:@selector(inputToolBarShouldShowAddMoreBtn:)] &&
            ![weakSelf.delegate inputToolBarShouldShowAddMoreBtn:weakSelf]) {
            make.size.hpwys_equalTo(CGSizeZero);
        }else {
            make.size.hpwys_equalTo(btnSize);
        }
        
    }];
    
    [self.sendButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.height.equalTo(weakSelf.addButton.hpwys_height).offset(-8);
        make.left.equalTo(weakSelf.emotionButton);
        make.right.equalTo(weakSelf.addButton);
        make.top.equalTo(weakSelf.addButton).offset(4);
    }];
    
    [self.emotionButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.addButton.hpwys_leading).offset(-5);
        make.centerY.equalTo(weakSelf);
        if ([weakSelf.delegate respondsToSelector:@selector(inputToolBarShouldShowEmojiBtn:)] &&
            ![weakSelf.delegate inputToolBarShouldShowEmojiBtn:weakSelf]) {
            make.size.hpwys_equalTo(CGSizeZero);
        }else {
          make.size.hpwys_equalTo(btnSize);
        }
        
    }];
    
    [self.recordButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.leading.equalTo(weakSelf.voiceButton.hpwys_trailing).offset(5);
        make.trailing.equalTo(weakSelf.emotionButton.hpwys_leading).offset(-5);
        make.top.equalTo(weakSelf).offset(7);
        make.bottom.equalTo(weakSelf).offset(-7);
    }];
    
    [self.textView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.leading.equalTo(weakSelf.voiceButton.hpwys_trailing).offset(5);
        make.trailing.equalTo(weakSelf.emotionButton.hpwys_leading).offset(-5);
        make.top.equalTo(weakSelf).offset(7);
        make.bottom.equalTo(weakSelf).offset(-7);
    }];
    
    [self.separatorView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.hpwys_equalTo(0.3);
    }];
}

- (void)clickVoiceButton:(UIButton *)voiceButton
{
    self.addButton.selected = NO;
    self.emotionButton.selected = NO;
    
    if (self.inputBarHeight) {
        if (voiceButton.isSelected) {
            // 键盘状态
            [self textViewDidchangeHeight:self.textView];
            
            // 延迟弹出键盘
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.textView becomeFirstResponder];
            });
        }
        else {
            // 录音状态
            self.inputBarHeight(50);
            [self.textView resignFirstResponder];
        }
    }
    [self.textView setEditable:YES];
    [self.textView endEditing:YES];
    self.textView.inputView = nil;
    
    voiceButton.selected = !voiceButton.isSelected;
    self.recordButton.hidden = !voiceButton.isSelected;
}

- (void)textViewDidchangeHeight:(LYTextView *)textView;
{
    CGFloat contentHeight = textView.contentSize.height;
    if (contentHeight < mintextViewH) {
        textViewH = mintextViewH;
    } else if (contentHeight > maxtextViewH){
        textViewH = maxtextViewH;
    } else {
        textViewH = contentHeight;
    }
    
    if (self.inputBarHeight) {
        // 我也不知道为什么是24
        self.inputBarHeight(textViewH + 24);
    }
    [textView setContentOffset:CGPointZero animated:YES];
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

#pragma mark - lazy load 添加子控件
- (LYTextView *)textView {
    if (!_textView) {
        LYTextView *textView = [[LYTextView alloc] init];
        textView.layer.cornerRadius = 2;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = LYColor(180, 180, 180).CGColor;
        textView.font = [UIFont systemFontOfSize:15];
        textView.textContainerInset = UIEdgeInsetsMake(8, 0, 0, 0);
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeySend;
        textView.enablesReturnKeyAutomatically = YES;
        _textView = textView;
        [self addSubview:_textView];
    }
    
    return _textView;
}

// 语音按钮
- (UIButton *)voiceButton {
    if (!_voiceButton) {
        UIButton *voiceButton = [[UIButton alloc] init];
        [voiceButton setAdjustsImageWhenHighlighted:NO];
        [voiceButton setBackgroundImage:[UIImage lyt_chatImageNamed:@"语音"] forState:UIControlStateNormal];
        [voiceButton setBackgroundImage:[UIImage lyt_chatImageNamed:@"键盘-聊天输入框"] forState:UIControlStateSelected];
        [voiceButton addTarget:self action:@selector(clickVoiceButton:) forControlEvents:UIControlEventTouchDown];
        _voiceButton = voiceButton;
        [self addSubview:_voiceButton];
    }
    
    return _voiceButton;
}
// 表情按钮
- (UIButton *)emotionButton {
    if (!_emotionButton) {
        UIButton *emotionButton = [[UIButton alloc] init];
        [emotionButton setAdjustsImageWhenHighlighted:NO];
        [emotionButton setImage:[UIImage lyt_chatImageNamed:@"表情-1"] forState:UIControlStateNormal];
        [emotionButton setImage:[UIImage lyt_chatImageNamed:@"键盘-聊天输入框"] forState:UIControlStateSelected];
        [emotionButton addTarget:self action:@selector(clickEmotionButton:) forControlEvents:UIControlEventTouchDown];
        _emotionButton = emotionButton;
        [self addSubview:_emotionButton];
    }
    
    return _emotionButton;
}

// 更多
- (UIButton *)addButton {
    if (!_addButton) {
        UIButton *addButton = [[UIButton alloc] init];
        [addButton setAdjustsImageWhenHighlighted:NO];
        
        [addButton setImage:[UIImage lyt_chatImageNamed:@"更多-1"] forState:UIControlStateNormal];
        [addButton setImage:[UIImage lyt_chatImageNamed:@"更多-聊天输入框-2"] forState:UIControlStateSelected];
        [addButton addTarget:self action:@selector(clickAddButton:) forControlEvents:UIControlEventTouchDown];
        _addButton = addButton;
        [self addSubview:_addButton];
    }
    
    return _addButton;
}

// 更多
- (UIButton *)sendButton {
    if (!_sendButton) {
        UIButton *sentButton = [[UIButton alloc] init];
        [sentButton setAdjustsImageWhenHighlighted:NO];
        sentButton.hidden = YES;
        [sentButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]] forState:UIControlStateNormal];
        [sentButton setTitle:@"发送" forState:UIControlStateNormal];
        [sentButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchDown];
        _sendButton = sentButton;
        _sendButton.layer.cornerRadius = 5;
        _sendButton.layer.masksToBounds = YES;
        [self addSubview:_sendButton];
    }
    return _sendButton;
}

- (UIView *)separatorView {
    if (!_separatorView) {
        UIView *separatorView = [[UIView alloc] init];
        separatorView.backgroundColor = LYColor(209, 209, 209);
        _separatorView = separatorView;
        [self addSubview:_separatorView];
    }
    
    return _separatorView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        UIButton *recordButton = [[UIButton alloc] init];
        recordButton.layer.cornerRadius = 2;
        recordButton.layer.borderWidth = 0.5;
        recordButton.layer.borderColor = LYColor(180, 180, 180).CGColor;
        [recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
        [recordButton setTitleColor:LYColor(100, 100, 100) forState:UIControlStateNormal];
        [recordButton setBackgroundColor:[UIColor whiteColor]];
        [recordButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [recordButton setHidden:YES];
        [recordButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [recordButton addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
        [recordButton addTarget:self action:@selector(dragExitRecord:) forControlEvents:UIControlEventTouchDragExit];
        [recordButton addTarget:self action:@selector(cancelRecord:) forControlEvents:UIControlEventTouchUpOutside];
        [recordButton addTarget:self action:@selector(dragEnterRecord:) forControlEvents:UIControlEventTouchDragEnter];
        _recordButton = recordButton;
        [self addSubview:_recordButton];
    }
    
    return _recordButton;
}

- (LYMoreInputView *)inputAddView
{
    if (!_inputAddView) {
        LYMoreInputView *inputView = [[LYMoreInputView alloc] initAddButtonWithFrame:CGRectMake(self.width, 0, 0, 200) buttonArray:self.AddButtonArray];
        inputView.delegate = self;
        _inputAddView = inputView;
        self.textView.inputView = _inputAddView;
    }
    return _inputAddView;
}

#pragma mark - imageChoose

- (void)resetKeyWordInput
{
    self.addButton.selected = NO;
    [self.textView setEditable:YES];
    // 键盘更改为系统键盘
    self.textView.inputView = nil;
}

- (void)moreInputView:(LYMoreInputView *)moreInputView didClicMoreButtonWithIndex:(NSInteger)btnIndex {
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didSelectMoreItemIndex:)]) {
        [self.delegate inputToolBar:self didSelectMoreItemIndex:btnIndex];
    }
}
- (LYEmotionInputView *)inputEmotionView
{
    if (!_inputEmotionView) {
        LYEmotionInputView *inputView = [[LYEmotionInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, 200)];
        // 发送
        LYWeakSelf
        inputView.didclickSenderEmotion = ^{
            if (weakSelf.textView.attributedText.length == 0) return; // 无数据则返回
            if ([weakSelf.delegate respondsToSelector:@selector(inputToolBar:didSendTextString:)]) {
                [_delegate inputToolBar:self didSendTextString:self.textView.fullText];
            }
            weakSelf.textView.text = nil;
        };
        // 删除表情
        inputView.didclickDeleteEmotion = ^{
            [weakSelf.textView deleteBackward];
            [self textViewDidchangeHeight:weakSelf.textView];
        };
        
        /** 选择表情 */
        inputView.didclickEmotionButton = ^(LYEmotion *emotion){
            if (weakSelf.textView.text.length + 6 > maxTextLength) {
//#warning HUD
                [HPWYSProgressHUD showErrorWithStatus:@"字符超过500字符"];
                //[MBProgressHUD showError:@"字符超过500字符"];
                return ;
            }
            [self.textView insertEmotion:emotion];
            [self textViewDidchangeHeight:self.textView];
        };
        _inputEmotionView = inputView;
        self.textView.inputView = _inputEmotionView;
    }
    return _inputEmotionView;
}

// 添加表情
- (void)clickEmotionButton:(UIButton *)buttonEmotion
{
    self.voiceButton.selected = NO;
    self.recordButton.hidden = YES;
    // 更多按钮非选中状态
    self.addButton.selected = NO;
    buttonEmotion.selected = !buttonEmotion.isSelected;
    
    
    
    if (buttonEmotion.isSelected) { // 弹出新键盘
        
        if ([self.delegate respondsToSelector:@selector(inputToolBarWillSwitchEmotion:)]) {
            [self.delegate inputToolBarWillSwitchEmotion:self];
        }
        // 退出之间的键盘,并允许编辑
        [self.textView setEditable:YES];
        [self.textView endEditing:YES];
        
        self.textView.inputView = self.inputEmotionView;
        
        [self.textView becomeFirstResponder];
    } else { // 系统默认的键盘
        if ([self.delegate respondsToSelector:@selector(inputToolBarWillSwitchKeyBorad:)]) {
            [self.delegate inputToolBarWillSwitchKeyBorad:self];
        }
        
        // 退出之间的键盘,并允许编辑
        [self.textView setEditable:YES];
        [self.textView endEditing:YES];
        self.textView.inputView = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
        

    }
}

#pragma mark - button addTarget
- (void)clickAddButton:(UIButton *)addButton
{
    // 表情按钮非选中状态
    self.emotionButton.selected = NO;
    self.voiceButton.selected = NO;
    self.recordButton.hidden = YES;
    addButton.selected = !addButton.isSelected;
    if (addButton.isSelected) { // 选中状态
        
        // 弹出新的键盘,并禁止编辑
        // 通知代理 add by zhangsg 2017.1.19
        if ([self.delegate respondsToSelector:@selector(inputToolBarWillSwitchAddView:)]) {
            [self.delegate inputToolBarWillSwitchAddView:self];
        }
        // 退出之前的键盘
        [self.textView endEditing:YES];
        self.textView.inputView = self.inputAddView;
        [self.textView setEditable:NO];
        
        [self.textView becomeFirstResponder];
        
    } else { //非选中状态
        
        if ([self.delegate respondsToSelector:@selector(inputToolBarWillSwitchKeyBorad:)]) {
            [self.delegate inputToolBarWillSwitchKeyBorad:self];
        }
        // 允许编辑
        [self.textView setEditable:YES];
        // 结束编辑
        [self.textView endEditing:YES];
        // 键盘更改为系统键盘
        self.textView.inputView = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
        });
        
        //[self.textView becomeFirstResponder];
    }
}

#pragma mark - 录音
// 开始录音
- (void)startRecord:(UIButton *)recordButton {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined) {// 没有询问
        self.isOpenMicrophoneInput = YES;
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            self.isOpenMicrophoneInput = NO;
        }];
        self.durationToolong = YES;
        return;
    } else if (status != AVAuthorizationStatusAuthorized ) {
        self.isOpenMicrophoneInput = YES;
        if ([self.delegate respondsToSelector:@selector(inputToolBarMicrophoneUnAvailability:)]) {
            [self.delegate inputToolBarMicrophoneUnAvailability:self];
            
        }
        
        self.durationToolong = YES;
        return;
    }

    self.durationToolong = NO;
    [LYRecordHUD showStartRecord];
    [recordButton setTitle:@"松开发送语音" forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(inputToolBarDidStartRecord:)]) {
        [self.delegate inputToolBarDidStartRecord:self];
    }
    
    int x = arc4random() % 100000;
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
    [[LYCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName completion:^(NSError *error) {
        if (!error) {
            
        }
    }];

}

// 录音结束并上传音频
- (void)endRecord:(UIButton *)recordButton {
    if (self.durationToolong) return; // 防止录音过长,自动发送后,再次执行
    [recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [LYRecordHUD showEndRecord];
    if ([self.delegate respondsToSelector:@selector(inputToolBarDidEndRecord:)]) {
        [self.delegate inputToolBarDidEndRecord:self];
    }
    
    [[LYCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (aDuration < 1) {

            [HPWYSProgressHUD showErrorWithStatus:@"录音时间过短"];
            
        }
        if (!error) {
            if (recordButton.tag == 60) aDuration = 60;
            if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendVoiceDuration:recordPath:)]) {
                NSString *scr = [recordPath lastPathComponent];
                [self.delegate inputToolBar:self didSendVoiceDuration:aDuration recordPath:scr];
                recordButton.tag = 0;
            }
        }
        if ([self.delegate respondsToSelector:@selector(inputToolBarDidEndRecord:)]) {
            [self.delegate inputToolBarDidEndRecord:self];
        }
    }];
}


/** 录音太长 */
- (void)recordIsTooLong {
    [HPWYSProgressHUD showErrorWithStatus:@"录音时间过长"];
    self.recordButton.tag = 60;
    [self endRecord:self.recordButton];
    self.durationToolong = YES;
}

// 离开按钮范围
- (void)dragExitRecord:(UIButton *)recordButton
{
    if (!self.isOpenMicrophoneInput) {
        [recordButton setTitle:@"松开手指,取消发送语音" forState:UIControlStateNormal];
        [LYRecordHUD showDragExitRecord];
        if ([self.delegate respondsToSelector:@selector(dragExitRecord:)]) {
            [self.delegate inputToolBarDragExitRecord:self];
        }
    }
}

// 取消录音
- (void)cancelRecord:(UIButton *)recordButton
{
    [recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [LYRecordHUD showEndRecord];
    
    //取消麦克风录音
    if ([LYCDDeviceManager sharedInstance].isRecording) {
        [[LYCDDeviceManager sharedInstance] cancelCurrentRecording];
    }
   
     
    if ([self.delegate respondsToSelector:@selector(inputToolBarCancelRecord:)]) {
        [self.delegate inputToolBarCancelRecord:self];
    }
    if ([self.delegate respondsToSelector:@selector(inputToolBarDidEndRecord:)]) {
        [self.delegate inputToolBarDidEndRecord:self];
    }
}

// 移动回按钮范围
- (void)dragEnterRecord:(UIButton *)recordButton
{
    if (!self.isOpenMicrophoneInput) {
        [recordButton setTitle:@"松开发送语音" forState:UIControlStateNormal];
        [LYRecordHUD showDragEnterRecord];
        if ([self.delegate respondsToSelector:@selector(inputToolBarDragEnterRecord:)]) {
            [_delegate inputToolBarDragEnterRecord:self];
        }
    }
}

// 进入后台
- (void)didEnterBackgroundNotification
{
    [LYRecordHUD showEndRecord];
    [self.recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing
{
    self.textView.editable = YES;
    self.addButton.selected = NO;
    self.emotionButton.selected = NO;
    self.textView.inputView = nil;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (self.textView.text.length > maxTextLength) {
        NSString *fullText = [self.textView.text substringToIndex:maxTextLength];
        self.textView.attributedText = [fullText emotionStringWithWH:24];
        self.textView.font = [UIFont systemFontOfSize:16];
//#warning HUD
        [HPWYSProgressHUD showErrorWithStatus:@"字符超过500字符"];
        //[MBProgressHUD showError:@"字符超过500字符"];
        return;
    }
    [self textViewDidchangeHeight:self.textView];
}

// 点击发送
- (BOOL)textView:(LYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //  发送
    if ([text isEqualToString:@"\n"]){
        // 纯空格禁止发送
        NSString *spaceString = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (![textView.text isEqualToString:@""] && textView.text != nil && spaceString.length != 0) {
            if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendTextString:)]) {
                [_delegate inputToolBar:self didSendTextString:self.textView.fullText];
            }
            textView.text = @"";
        }
        return NO;
    }
    [self textViewDidchangeHeight:self.textView];
    if ([text isEqualToString:@"@"]) {
        if ([self.delegate respondsToSelector:@selector(inputToolBarDidInputAT:)]) {
            [self.delegate inputToolBarDidInputAT:self];
        }
    }
    return YES;
}


/** 发送按钮 */
- (void)sendButtonClick:(UIButton *)sentButton {
    NSString *spaceString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (spaceString.length == 0) return;
    
    if ([self.delegate respondsToSelector:@selector(inputToolBar:didSendTextString:)]) {
        [_delegate inputToolBar:self didSendTextString:self.textView.text];
    }
    self.textView.text = nil;
    
}

- (void)setSelecte:(BOOL)selected ForAddButtonWithIndex:(NSInteger)index {
    [self.inputAddView setSelecte:selected ForAddButtonWithIndex:index];
}
- (void)resumeToTextKeyinput
{
    [self bringSubviewToFront:self.sendButton];
    self.sendButton.hidden =NO;
    self.voiceButton.enabled = NO;
    self.textView.editable = NO;
    self.recordButton.hidden = YES;
}
- (void)activeTextKeyinput
{
    self.userInteractionEnabled = YES;
    self.voiceButton.enabled = YES;
    self.textView.editable = YES;
    self.addButton.enabled = YES;
    self.emotionButton.enabled = YES;
    
}

- (void)endInputEditing {
    // 表情按钮非选中状态
    self.emotionButton.selected = NO;
    self.voiceButton.selected = NO;
    self.recordButton.hidden = YES;
    // 允许编辑
    [self.textView setEditable:YES];
    // 结束编辑
    [self.textView endEditing:YES];
    // 键盘更改为系统键盘
    self.textView.inputView = nil;
    // 取消选中
    self.addButton.selected = NO;
}

/**
 *  界面不可用
 */
- (void)becomeinActive{
    
    self.userInteractionEnabled = NO;
    self.voiceButton.enabled = NO;
    self.textView.editable = NO;
    self.addButton.enabled = NO;
    self.emotionButton.enabled = NO;
    
}
@end
