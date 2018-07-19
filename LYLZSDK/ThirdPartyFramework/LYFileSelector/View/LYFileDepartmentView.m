//
//  CJDepartmentView.m
//  Antenna
//
//  Created by HHLY on 16/6/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYFileDepartmentView.h"
#import "HPWYsonry.h"

#import "UIColor+HexColor.h"

#define LYScreenWidth  [UIScreen mainScreen].bounds.size.width
#define DepartmentWidth LYScreenWidth/4.0
#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]

@interface LYFileDepartmentView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *indicatorView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation LYFileDepartmentView

#pragma mark - Lazy
- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,46, DepartmentWidth, 2)];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"22aeff"];
    }
    return _indicatorView;
}

#pragma mark - Property
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    UIButton *lastBtn = [self viewWithTag:100+_selectedIndex];
    UIButton *btn = [self viewWithTag:100+selectedIndex];
    lastBtn.selected = NO;
    btn.selected = YES;
    _selectedIndex = selectedIndex;
    [UIView animateWithDuration:0.15 animations:^{
        self.indicatorView.frame = CGRectMake(CGRectGetMinX(btn.frame) + 1, (46), CGRectGetWidth(btn.frame), 2);
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.selectedIndex == 0) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else {
                [self scrollRightPosition];
            }
        }
    }];
}

- (void)reloadData {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initializeSubviews];
}

#pragma mark - Initialize
- (instancetype)init {
    return [self initWithParts:nil withFrame:CGRectZero];
}

- (instancetype)initWithParts:(NSArray *)partArr {
    return [self initWithParts:partArr withFrame:CGRectZero];
}

- (instancetype)initWithParts:(NSArray *)partArr withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.departmentArr = partArr;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
    
    UIButton *lastBtn = nil;
    
    
    CGFloat totalWidth = 0;
    for (int i = 0; i < self.departmentArr.count; ++i) {
        NSString *title = self.departmentArr[i];
        
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        UIButton *partBtn = [[UIButton alloc] init];
        partBtn.tag = 100 + i;
        [partBtn setTitle:title forState:UIControlStateNormal];
        [partBtn setTitle:title forState:UIControlStateSelected];
        
        [partBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [partBtn setTitleColor:[UIColor colorWithHexString:@"22aeff"]  forState:UIControlStateSelected];
        [partBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [partBtn addTarget:self action:@selector(clickDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:partBtn];
        
        if (i == 0) {
            partBtn.selected = YES;
        }
        
        CGFloat buttonWidth = size.width > DepartmentWidth ? size.width + 2: DepartmentWidth;
        totalWidth += buttonWidth;
        
        __weak typeof(self) weakSelf = self;
        [partBtn hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.width.hpwys_equalTo(buttonWidth);
            make.height.hpwys_equalTo((48));
            
            if (lastBtn) {
                make.left.equalTo(lastBtn.hpwys_right);//.offset(2);
            }
            else {
                make.left.equalTo(weakSelf);//.offset(2);
            }
        }];
        lastBtn = partBtn;
    }
    
    [self addSubview:self.indicatorView];
    
    self.bounces = NO;
    self.delegate = self;
    
    self.contentSize = CGSizeMake(totalWidth > LYScreenWidth ? totalWidth: LYScreenWidth, CGRectGetHeight(self.bounds));
}

#pragma mark - Actions
- (void)clickDepartmentButton:(UIButton *)sender {
    self.selectedIndex = sender.tag - 100;
    if ([self.lyt_delegate respondsToSelector:@selector(departmentView:didScrollToIndex:)]) {
        [self.lyt_delegate departmentView:self didScrollToIndex:self.selectedIndex];
    }
}

- (void)scrollRightPosition {
    UIButton *btn = [self viewWithTag:100 + self.selectedIndex - 1];
    if (btn) {
        UIButton *lastBtn = [self viewWithTag:100 + self.departmentArr.count - 1];
        if (CGRectGetMaxX(lastBtn.frame) - CGRectGetMinX(btn.frame) <= LYScreenWidth) {
            [self setContentOffset:CGPointMake(self.contentSize.width - LYScreenWidth, 0) animated:YES];
            return;
        }
        [self setContentOffset:CGPointMake(CGRectGetMinX(btn.frame), 0) animated:YES];
    }
}
@end
