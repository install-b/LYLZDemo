//
//  LYTCommonHeader.h
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/3.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#ifndef LYTCommonHeader_h
#define LYTCommonHeader_h
#import "UIView+Frame.h"
#import "UIColor+LYColor.h"
#import "UIImage+BundleImage.h"
#import "HPWYSProgressHUD.h"
#import "HPWYSWebImageManager.h"
#import "HPWYSImageCache.h"
#import "UIImageView+HPWYSWebCache.h"
#import "HPWYsonry.h"
#import "LYTSDK.h"
#import "LYTFileImageSelectorNav.h"

/** self的弱引用 */
#define LYWeakSelf __weak typeof(self) weakSelf = self;
// 主窗口
#define LYKeyWindow [UIApplication sharedApplication].keyWindow

//判断是什么型号的手机
#define iPhone6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6SP ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#pragma mark -手机屏幕尺寸
/** 手机屏幕尺寸 */
#define LYScreenH [UIScreen mainScreen].bounds.size.height
#define LYScreenW [UIScreen mainScreen].bounds.size.width


#endif /* LYTCommonHeader_h */
