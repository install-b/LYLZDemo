//
//  LYInputToolBar.h
//  LYLink
//
//  Created by SYLing on 2016/12/17.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYTextView.h"

@class LYInternalSessionModel,LYInputToolBar;

@protocol LYInputToolBarDelegate <NSObject>

@required

/** 发送文字 */
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSendTextString:(NSString *)textString;

/** 发送语音 */
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSendVoiceDuration:(NSInteger)aDuration recordPath:(NSString *)recordPath;

/** 选择了哪个更多按钮 */
- (void)inputToolBar:(LYInputToolBar *)inputToolBar didSelectMoreItemIndex:(NSInteger)itemIndex;

@optional

/** 开始录音 */
- (void)inputToolBarDidStartRecord:(LYInputToolBar *)inputToolBar;

/** 结束录音 */
- (void)inputToolBarDidEndRecord:(LYInputToolBar *)inputToolBar;

/** 离开按钮范围 */
- (void)inputToolBarDragExitRecord:(LYInputToolBar *)inputToolBar;

/** 取消录音 */
- (void)inputToolBarCancelRecord:(LYInputToolBar *)inputToolBar;

/** 移动回录音按钮范围 */
- (void)inputToolBarDragEnterRecord:(LYInputToolBar *)inputToolBar;

/** 麦克风不可用 */
- (void)inputToolBarMicrophoneUnAvailability:(LYInputToolBar *)inputToolBar;


//  新增键盘活动状态改变 add by zhangsg 2017.1.19
/** 即将切换到更多界面 */
- (void)inputToolBarWillSwitchAddView:(LYInputToolBar *)inputToolBar;

/** 即将切换到表情界面 */
- (void)inputToolBarWillSwitchEmotion:(LYInputToolBar *)inputToolBar;

/** 即将展示切换到输入键盘 */
- (void)inputToolBarWillSwitchKeyBorad:(LYInputToolBar *)inputToolBar;

/** 刚刚已经输入了@字符 */
- (void)inputToolBarDidInputAT:(LYInputToolBar *)inputToolBar;



/** 是否需要语音按钮 */
- (BOOL)inputToolBarShouldShowVoiceBtn:(LYInputToolBar *)inputToolBar;

/** 是否需要表情按钮 */
- (BOOL)inputToolBarShouldShowEmojiBtn:(LYInputToolBar *)inputToolBar;

/** 是否需要更多按钮 */
- (BOOL)inputToolBarShouldShowAddMoreBtn:(LYInputToolBar *)inputToolBar;
@end



@interface LYInputToolBar : UIView
// 为了快速添加文字
@property (strong, nonatomic) LYTextView *textView;    // 输入框

// 判断隐藏/显示，发送常用语
@property (weak, nonatomic) UIButton *sendButton;     // 发送 按钮

// 改变输入视图高度
@property (copy, nonatomic) void (^inputBarHeight)(CGFloat height);

/** 代理 */
@property (weak, nonatomic) id <LYInputToolBarDelegate> delegate;

/** 点击加号，出现的按钮属性数组 */
@property (nonatomic ,strong) NSArray *AddButtonArray;

/** 设置加号按钮中 更多按钮的选择状态 */
- (void)setSelecte:(BOOL)selected ForAddButtonWithIndex:(NSInteger)index;

/**设置输入框进入常用语模式*/
- (void)resumeToTextKeyinput;

/**
 *  激活按钮交互
 */
- (void)activeTextKeyinput;

/**
 *  界面不可用
 */
- (void)becomeinActive;

/** 结束编辑 */
- (void)endInputEditing;


/**
 是否拥有麦克风访问权限
 */
@property (nonatomic, assign) BOOL isOpenMicrophoneInput;

@end
