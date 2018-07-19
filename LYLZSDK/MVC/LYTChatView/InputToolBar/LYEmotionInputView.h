//
//  LYEmotionInputView.h
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYEmotion;

typedef void(^didclickSender)(void);
typedef void(^didclickEmotion)(LYEmotion *);

@interface LYEmotionInputView : UIView

/** 发送 */
@property (copy, nonatomic) void(^didclickSenderEmotion)(void);
/** 选择表情 */
@property (copy, nonatomic) void(^didclickEmotionButton)(LYEmotion *);

/** 删除表情 */
@property (copy, nonatomic) void(^didclickDeleteEmotion)(void);

@end
