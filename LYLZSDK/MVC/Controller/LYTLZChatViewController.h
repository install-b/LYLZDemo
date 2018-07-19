//
//  LYTLZChatViewController.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/4.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYTChatViewController.h"




typedef NS_ENUM(NSUInteger,LYLZChatIdentity ) {
    LYLZChatIdentityUnkown,     // 未知身份
    LYLZChatIdentityLawyer,     // 律师
    LYLZChatIdentityConsultant, // 咨询者
};

typedef NS_ENUM(NSUInteger,LYLZChatSessionStatus) {
    ////会话状态（1进行中；2发起结束；3同意结束；4不同意结束）
    LYLZChatSessionStatus_Unknow = 0,     //未知状态
    LYLZChatSessionStatus_Is_Running,     //进行中
    LYLZChatSessionStatus_Sponsor_Ending, //发起结束
    LYLZChatSessionStatus_Agree_Ending,   //同意结束
    LYLZChatSessionStatus_NotAgree_Ending //不同意结束
};



@interface LYTLZChatViewController : LYTChatViewController

/** 
 输入是否禁用
 */
@property(assign,getter=isInputEnable) BOOL inputEnable;


/** 
 是否显示 倒计时控件 默认不显示 
 */
@property(assign,nonatomic,getter=isShowTimeDownView) BOOL showTimeDownView;



/**
 构造方法

 @param targetId 对方ID
 @param chatIdentity 聊天身份
 @return 实例化对象 可能为nil （targetId 不为空，chatIdentity身份必须明确）
 */
- (instancetype)initWithTargetId:(NSString *)targetId chatIdentity:(LYLZChatIdentity)chatIdentity;

/**
 不能直接使用 init 
 */
- (instancetype)init __attribute__((unavailable("LYTChatViewController: Forbidden use! using 'initWithTargetId:sessionType:'")));



#pragma mark - 子类重写 的方法
/**
 点击了订单跳转
    {
     "title":"这是一个转账消息",
     "bodyMsg":"支付完成，请查收",
     "tailMsg":"立即前往",
     "jumpMsg":"跳转消息"
    }
 
 @param jumpInfo 跳转信息 （jumpMsg 信息）
 */
- (void)didClickJumpWithInfo:(id)jumpInfo;

/**
 倒计时控件高度
 
 @return 控件高度
 */
- (CGFloat)heightForTimeDownView;


/**
 倒计时控件自定义子控件
 
 @return 自定义子控件
 */
- (UIView *)contentViewForTimeDownView;

/**
 根据结束会话  状态处理相应时间  （用户端实现）

 @param statu 律师端发起的会话状态
 */
- (void)didFetchSessionStatus:(LYLZChatSessionStatus)statu;
@end

