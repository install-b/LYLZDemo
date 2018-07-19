//
//  UIImage+BundleImage.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/4.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BundleImage)

// 加载表情
+ (UIImage *)lyt_emotionImageNamed:(NSString *)name;

// 加载聊天的界面图片
+ (UIImage *)lyt_chatImageNamed:(NSString *)name;

@end
