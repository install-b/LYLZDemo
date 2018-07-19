//
//  LYTMessageTipView.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/9.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LYTMessage;
@protocol LYTMessageTipViewDelegate ;

@interface LYTMessageTipView : UIView

/** 代理 */
@property (nonatomic,weak) id<LYTMessageTipViewDelegate> delegate;

- (void)showWithMessage:(LYTMessage *)message;

/** 用户名 */
@property (nonatomic,copy)NSString * userName;

@end



@protocol LYTMessageTipViewDelegate <NSObject>

- (void)messageTipView:(LYTMessageTipView *)tipView didSelectMessage:(NSString *)message;

@end
