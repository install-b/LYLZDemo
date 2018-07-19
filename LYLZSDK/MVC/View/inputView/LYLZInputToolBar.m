//
//  LYLZInputToolBar.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/5.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYLZInputToolBar.h"

#import "LYTCommonHeader.h"

@interface LYLZInputToolBar ()
/** <#des#> */
@property (nonatomic,weak) UIView * inputEnableView;
@end

@implementation LYLZInputToolBar

- (void)setInputEnable:(BOOL)inputEnable {
    _inputEnable = inputEnable;
    if (_inputEnable) {
        _inputEnableView.hidden = inputEnable;
       
    }else {
        [self endInputEditing];
        self.inputEnableView.hidden = inputEnable;
    }
}

- (UIView *)inputEnableView {
    if (!_inputEnableView) {
        UIView *cover = [[UIView alloc] init];
        [self addSubview:cover];
        cover.backgroundColor = [UIColor getColor:@"d9d9d9" alpha:0.6];
        
        UIButton *titleBtn = [[UIButton alloc] init];
        [cover addSubview:titleBtn];
        [titleBtn setImage:[UIImage lyt_chatImageNamed:@"锁"] forState:UIControlStateNormal];
        [titleBtn setTitle:@"您的服务已到期" forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor getColor:@"999999" alpha:1] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        titleBtn.userInteractionEnabled = NO;
        
        [cover hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        
        [titleBtn hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.center.equalTo(self.textView);
        }];
    }
    return _inputEnableView;
}

@end
