//
//  LYTChatRoomViewController.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>


UIKIT_EXTERN  NSString * const LYTMessageTipViewFrameWillChangeNoti;


typedef NS_ENUM(NSInteger,LYTChatType) {
    LYTChatTypeUnkown,      // 未知
    LYTChatTypeP2P,         // 点对点聊天
    LYTChatTypeChatRoom,    // 聊天室
    LYTChatTypeComment,     // 评论
    LYTChatTypeGroup        // 讨论组
};


@interface LYTChatViewController : UIViewController

/** 
 聊天对象 groupId、chatRoomId、userId 
 */
@property(nonatomic,copy,readonly) NSString * targetId;

/**
 会话ID
 */
@property (nonatomic,copy) NSString *sessionId;//add by ys 2017.11.05

/**
 最后一条消息的ID
 */
@property (nonatomic,copy) NSString *messageID;


/**
 每次查询消息记录的条数
 */
@property (nonatomic,assign) NSInteger count;

/** 聊天内容视图 */
@property(nonatomic,assign) UIEdgeInsets chatInsets;



/**
 聊天控制器构造方法
 
 @param targetId 聊天对象 groupId、chatRoomId、userId
 @param chatType  聊天类型
 @return 实例对象 可能为nil（targetId 不为空、sessionType 不为0）
 */
- (instancetype)initWithTargetId:(NSString *)targetId sessionType:(LYTChatType)chatType;


/** 不能直接使用 init */
- (instancetype)init __attribute__((unavailable("LYTChatViewController: Forbidden use! using 'initWithTargetId:sessionType:'")));



/**
 重新布局输入框:是用该方法前必须调用 [super layoutInputViewWithToolBarHeight:keyboardHeight];

 @param toolBarHeight 输入框高度
 @param keyboardHeight 键盘高度
 */
- (void)layoutInputViewWithToolBarHeight:(CGFloat)toolBarHeight keyboardHeight:(CGFloat)keyboardHeight;
@end
