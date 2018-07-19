//
//  LZChatMessageOrderCell.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZChatMessageOrderCell.h"
#import "UIColor+LYColor.h"

#import "LYTCommonHeader.h"
#import "NSString+TextSize.h"
#import "UIImage+Utility.h"

@interface LZOrderContenView : UIView

/** <#des#> */
@property (nonatomic,weak) UILabel * titleLable;

/** <#des#> */
@property (nonatomic,weak) UILabel * bodyMsgLable;

/** <#des#> */
@property (nonatomic,weak) UIButton * tailButton;

/** <#des#> */
@property (nonatomic,weak) LYLZOrderMessageBody * orderBody;

/** <#des#> */
@property(nonatomic,assign,readonly) CGSize contenSize;
@end

@implementation LZOrderContenView

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame target:nil selector:NULL];
}

- (instancetype)initWithFrame:(CGRect)frame target:(id)target selector:(SEL)seleotor {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self addLayouts];
        [self.tailButton addTarget:target action:seleotor forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addLayouts {
    CGFloat titleWidth = orderWith - 2 * contentXMargin;
    [self.titleLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(contentYMargin);
        make.width.hpwys_lessThanOrEqualTo(@(titleWidth));
    }];
    
    [self.bodyMsgLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(self.titleLable.hpwys_bottom).offset(textMargin);
        make.left.equalTo(self).offset(contentXMargin);
        make.right.equalTo(self).offset(-contentXMargin);
    }];
    
    [self.tailButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(@(btnHeight));
    }];
}

- (void)setOrderBody:(LYLZOrderMessageBody *)orderBody {
    _orderBody = orderBody;
    
    CGFloat width = orderWith;
    
    CGFloat height = 0;
    self.titleLable.text = orderBody.title;
    height += [orderBody.title heightWithFont:titleFont MaxWidth:width - 2 * contentXMargin];
    self.bodyMsgLable.text = orderBody.bodyMsg;
    height += [orderBody.bodyMsg heightWithFont:bodyFont MaxWidth:width - 2 * contentXMargin];
    if (orderBody.tailMsg.length) {
        self.tailButton.hidden = NO;
        [self.tailButton setTitle:orderBody.tailMsg forState:UIControlStateNormal];
        height += btnHeight;
    }else {
        self.tailButton.hidden = YES;
    }
    
    height += 2 * contentYMargin + textMargin;
    
    self.width = width;
    self.height = height;
}


- (UILabel *)titleLable {
    
    if (!_titleLable) {
        UILabel *lable = [[UILabel alloc] init];
        _titleLable = lable;
        [self addSubview:lable];
        lable.textColor = [UIColor getColor:@"333333" alpha:1];
        lable.font = [UIFont systemFontOfSize:16];
        lable.numberOfLines = 0;
        lable.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLable;
}

- (UILabel *)bodyMsgLable {
    
    if (!_bodyMsgLable) {
        
        UILabel *lable = [[UILabel alloc] init];
        _bodyMsgLable = lable;
        [self addSubview:lable];
        lable.textColor = [UIColor getColor:@"999999" alpha:1];
        lable.font = [UIFont systemFontOfSize:13];
        lable.numberOfLines = 0;
        
    }
    
    return _bodyMsgLable;
}

- (UIButton *)tailButton {
    
    if (!_tailButton) {
        UIButton * btn = [[UIButton alloc] init];
        _tailButton = btn;
        [self addSubview:btn];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor getColor:@"cccccc" alpha:0.3];
        [btn addSubview:lineView];
        [lineView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.top.left.right.equalTo(btn);
            make.height.equalTo(@1);
        }];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor getColor:@"cccccc" alpha:0.6]] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor getColor:@"333333" alpha:1] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor getColor:@"cccccc" alpha:1] forState:UIControlStateHighlighted];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _tailButton;
}


@end








@interface LZChatMessageOrderCell ()
/** <#des#> */
@property (nonatomic,weak)  LZOrderContenView * orderContendView;
@end

@implementation LZChatMessageOrderCell

- (void)setCellFrame:(LYLZmessageBody *)cellFrame {
    [super setCellFrame:cellFrame];
    self.orderContendView.orderBody = (LYLZOrderMessageBody *)cellFrame;
}
- (void)jumpBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatMessageOrderCell:didClickJumpWithInfo:)]) {
        id jumpInfo = nil;
        @try {
            jumpInfo = [self.cellFrame valueForKey:@"jumpMsg"];
        } @catch (NSException *exception) {
#ifdef DEBUG
            [exception raise];
            
#endif
        };
        
        [self.delegate chatMessageOrderCell:self didClickJumpWithInfo:jumpInfo];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.orderContendView.center = self.contentView.center;
}

- (CGFloat)cellHeight {
    return self.orderContendView.height + 2 * contentYMargin;
}

- (LZOrderContenView *)orderContendView {

    if (!_orderContendView) {
        LZOrderContenView *contendView = [[LZOrderContenView alloc] initWithFrame:CGRectZero target:self selector:@selector(jumpBtnClick:)];
        _orderContendView = contendView;
        [self.contentView addSubview:contendView];
    }
    return _orderContendView;
}



@end



