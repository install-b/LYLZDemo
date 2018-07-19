//
//  LZChatMessageRecPacketCell.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LZChatMessageRecPacketCell.h"
#import "LZChatMessageOrderCell.h"
#import "UIColor+LYColor.h"
#import "UIImage+BundleImage.h"
#import "HPWYsonry.h"
#import "LYTCommonHeader.h"
#import "LYLZRedPacketMessageBody.h"

@interface LZRecPacketContentView : UIView
/** <#des#> */
@property (nonatomic,weak) UIImageView * imageView;

/** <#des#> */
@property (nonatomic,weak) UILabel * titleLable;

/** <#des#> */
@property (nonatomic,weak) UILabel * tailLable;

@end


@implementation LZRecPacketContentView

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.width = 0.656 * LYScreenW;
    frame.size.height = 60;
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor getColor:@"cccccc" alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self addLayouts];
    }
    return self;
}
- (void)addLayouts {
    
    [self.imageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.left.equalTo(self).offset(textMargin);
        make.height.with.equalTo(@40);
    }];
    
    [self.titleLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(self.imageView);
        make.left.equalTo(self.imageView.hpwys_right).offset(textMargin);
    }];
    
    [self.tailLable hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.left.equalTo(self.imageView.hpwys_right).offset(textMargin);
        make.bottom.equalTo(self.imageView);
    }];
    
}

- (void)setRedPacketBody:(LYLZRedPacketMessageBody *)redPacketBody {
    self.titleLable.text = redPacketBody.bodyMsg;
    self.tailLable.text = redPacketBody.tailMsg;
    
}


- (UILabel *)titleLable {
    if (!_titleLable) {
        UILabel *lable = [[UILabel alloc] init];
        _titleLable = lable;
        [self addSubview:lable];
        lable.font = titleFont;
        lable.textColor = [UIColor getColor:@"333333" alpha:1];
    }
    return _titleLable;
}

- (UILabel *)tailLable {
    if (!_tailLable) {
        UILabel *lable = [[UILabel alloc] init];
        _tailLable = lable;
        [self addSubview:lable];
        lable.font = bodyFont;
        lable.textColor = [UIColor getColor:@"999999" alpha:1];
    }
    return _tailLable;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage lyt_chatImageNamed:@"红包2"]];
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

@end






@interface LZChatMessageRecPacketCell ()
/** <#des#> */
@property (nonatomic,weak)  LZRecPacketContentView * recPacketContentView;
@end


@implementation LZChatMessageRecPacketCell
- (CGFloat)cellHeight {
    return  2 * contentYMargin + self.recPacketContentView.height;
}

- (void)setCellFrame:(LYLZmessageBody *)cellFrame {
    [super setCellFrame:cellFrame];
    self.recPacketContentView.redPacketBody = (LYLZRedPacketMessageBody *)cellFrame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.recPacketContentView.center = self.contentView.center;
}

- (LZRecPacketContentView *)recPacketContentView {
    if (!_recPacketContentView) {
        LZRecPacketContentView *recPacketContentView = [[LZRecPacketContentView alloc] init];
        _recPacketContentView = recPacketContentView;
        [self.contentView addSubview:recPacketContentView];
    }
    return _recPacketContentView;
}

@end
