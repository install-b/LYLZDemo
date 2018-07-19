//
//  LYTChatContentView.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYTMessage;
@interface LYTChatContentView : UIView

@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) LYTMessage *chatMessage;

@end
