//
//  LYProgressView.h
//  LYPhotoBrowserDemo
//
//  Created by Shangen Zhang on 17/3/19.
//  Copyright © 2017年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTProgressView : UIView
/**  快速创建一个50 X 50的进度条View */
+ (instancetype)progressView;

/**  快速创建一个width X width的进度条View */
+ (instancetype)progressViewWithWidth:(CGFloat)width;

/** 进度值 */
@property (nonatomic,assign) CGFloat progress;

@end
