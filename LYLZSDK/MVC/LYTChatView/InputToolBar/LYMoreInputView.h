//
//  LYMoreInputView.h
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYMoreInputView;

@protocol LYMoreInputViewDelegate <NSObject>

//  点击了视图
- (void)moreInputView:(LYMoreInputView *)moreInputView didClicMoreButtonWithIndex:(NSInteger)btnIndex;

@end

@interface LYMoreInputView : UIView
// 初始化方法
- (instancetype)initAddButtonWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray;

@property (weak, nonatomic) id<LYMoreInputViewDelegate> delegate;

// 设置选择转态
- (void)setSelecte:(BOOL)selected ForAddButtonWithIndex:(NSInteger)index;
@end
