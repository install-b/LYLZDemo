//
//  LYRecordHUD.h
//  LYLink
//
//  Created by Lc on 16/4/6.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYRecordHUD : UIView
+ (LYRecordHUD *)sharedView;
/**
 *  显示录音指示器
 */
+ (void)showStartRecord;
+ (void)showEndRecord;
+ (void)showDragExitRecord;
+ (void)showDragEnterRecord;

/** 录音唱过60秒 */
@property (copy, nonatomic) void(^HUDTimerRecordTimeToolong)(void);
@end
