//
//  UIView+Frame.h
//  PandVisa
//
//  Created by 邵银岭 on 16/1/29.
//  Copyright © 2016年 邵银岭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property(nonatomic,assign)CGFloat width;
@property(nonatomic,assign)CGFloat height;
@property(nonatomic,assign)CGFloat x;
@property(nonatomic,assign)CGFloat y;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

/** 尺寸 */
@property (nonatomic, assign) CGSize size;
@property (nonatomic) CGPoint origin;

@end
