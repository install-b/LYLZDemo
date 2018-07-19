//
//  LYTChatImageView.h
//  LYTDemo
//
//  Created by SYLing on 2017/2/8.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYTMessage;
@interface LYTChatImageView : UIImageView
@property (nonatomic,strong)UIImageView *imageContainer;
//消息模型（用于自己发送的图片URl和获取本地图片显示）
@property (nonatomic,strong) LYTMessage *chatMessage;
@end
