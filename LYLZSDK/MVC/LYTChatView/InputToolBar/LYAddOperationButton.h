//
//  LYAddOperationButton.h
//  TaiYangHua
//
//  Created by admin on 16/11/1.
//  Copyright © 2016年 hhly. All rights reserved.
//
//  添加按钮栏中的按钮  图片在上文字在下

#import <UIKit/UIKit.h>

@interface LYAddOperationButton : UIButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title;

@end
