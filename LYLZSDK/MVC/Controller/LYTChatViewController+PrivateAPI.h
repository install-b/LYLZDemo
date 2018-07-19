//
//  LYTChatViewController+PrivateAPI.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/4.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#ifndef LYTChatViewController_PrivateAPI_h
#define LYTChatViewController_PrivateAPI_h
#import "LYTChatViewController.h"

#import "LYInputToolBar.h"
#import "LYAudioPlayerHelper.h"


#import "LYTSDK.h"

#import "LYAssetGridViewController.h"

#import "UIImage+Utility.h"
#import "NSData+Utility.h"

#import "LYFileManagerVC.h"
#import "LYTimeBannerModel.h"
#import "LYTChatMessageCell.h"
#import "LYSessionTimeBannerCell.h"
#import "LYTChatVoiceContentView.h"
#import "LYTChatImageContentView.h"
#import "LYTChatFileContentView.h"

#import "LYFileObjModel.h"
#import "LYAsset.h"
#import "LYFlieLookUpVC.h"

#import "UIColor+LYColor.h"
#import "LYTCommonHeader.h"
#import "NSString+LYMessageStr.h"
#import "UIView+Frame.h"
#import "HPWYsonry.h"

#import "LYLZSDK.h"

//
#define _sharedSDK [LYLZSDK sharedSDK]


// 单行默认高度
#define inputToolBarDefailtHeight 50

typedef NS_ENUM(NSUInteger,LYTSendMessageType) {
    LYTSendMessageTypeNormal,
    LYTSendMessageTypeWillTip,
    LYTSendMessageTypeTip,
};

typedef NS_ENUM(NSInteger,LYkeyBoradSwitchState) {
    LYkeyBoradSwitchStateTextInput   = -1, // 点击了要切换到输入框
    LYkeyBoradSwitchStateNormal      = 0,  // 常规状态
    LYkeyBoradSwitchStateUpcoming    = 1,  // 即将切换状态
};



static BOOL DestructMessageMode = NO;
@protocol LYTChatRoomViewControllerProtocol
<
UITableViewDelegate,
UITableViewDataSource,
LYInputToolBarDelegate,
LYTSDKChatManagerDelegate,
LYTChatMessageCellDelegate
>
@end

@interface LYTChatViewController () <LYTChatRoomViewControllerProtocol>
/** tableView */
@property (nonatomic ,strong) UITableView *tableView;
/** 聊天记录 */
@property (nonatomic ,strong) NSMutableArray *messageArray;

/** 输入框视图 */
@property (nonatomic,weak) UIView * inputContainer;

/** 输入框顶部视图 */
@property (nonatomic,weak) UIView * inputTopView;

/** 输入框底部视图 */
@property (nonatomic,weak) UIView * inputBottomView;

/** 输入框 */
@property (nonatomic ,weak) LYInputToolBar *toolBar;

/** 键盘高度 */
@property(nonatomic,assign) CGFloat keyBoardHeight;

/** 键盘切换状态 */
@property(nonatomic,assign) LYkeyBoradSwitchState keyBoradSwitchState;

/** 聊天内容视图 */
@property (nonatomic,strong) LYTChatMessageContentView *tempContentView;

// 更多按钮
- (NSArray *)moreItemArray;

/** 选择点击的是哪一行 */
@property (nonatomic,strong) NSIndexPath *indexPath;

// 发送消息总入口
- (void)sendMessageWithMessage:(LYTMessage *)message;

/************** 配置两条消息相隔多久显示一条时间戳 ***************/
@property (nonatomic,assign) int64_t showTimeInterval;

@property (nonatomic,assign) int64_t lastTimeInterval;

/** 更多按钮 */
@property (nonatomic,strong) NSArray<NSDictionary *> * moreItems;

// 重新加载
- (void)reloadToolBar;

/**
 聊天类型
 */
@property(nonatomic,assign,readonly) LYTChatType chatType;


- (void)didReceiveAMessage:(LYTMessage *)message ;

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageFrame:(LYTChatMessageCellFrame *)frame;

// 设置tabalview
- (void)addRefreshActionWithTableview:(UITableView *)tableView;

// 插入条消息到最前面
- (void)insertMessage:(LYTMessage *)message;

// 添加一条消息到最后
- (void)addMessage:(LYTMessage *)message scrollToBottom:(BOOL)isScroll;
@end

#endif /* LYTChatViewController_PrivateAPI_h */
