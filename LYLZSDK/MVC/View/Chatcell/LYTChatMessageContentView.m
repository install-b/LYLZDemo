//
//  LYTChatMessageContentView.m
//  LYTDemo
//
//  Created by SYLing on 2017/2/7.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "LYTChatMessageContentView.h"
#import "HPWYsonry.h"
#import "UIImage+BundleImage.h"

@interface LYTChatMessageContentView()

@property (nonatomic,strong) UIImageView * bubbleImageView;

@end

@implementation LYTChatMessageContentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _bubbleImageView  = [[UIImageView alloc] init];
        
        [self addSubview:_bubbleImageView];
        [_bubbleImageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)]];
        // 加入长按手势
        [self addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTap:)]];
    }
    return self;
}
- (void)setupData {
    //LYTLog(@"子类实现----")
}
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    //LYTLog(@"子类实现----")
    
}

-(void)longTap:(UILongPressGestureRecognizer *)tapGestureRecognizer{
    [self becomeFirstResponder]; //self默认是不能响应事件的，所以要让它成为第一响应者
}

- (BOOL)canBecomeFirstResponder { //指定self可以成为第一响应者 切忌不要把这个方法不小心写错了哟， 不要写成 becomeFirstResponder
    return YES;
}

//- (void)layoutSubviews{
//    [super layoutSubviews];
//    
//}

#define LeftCapWidthAngle 0.3
#define topCapHeightAngle 0.8
- (void)setCellFrame:(LYTChatMessageCellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    UIImage *normal = (!self.cellFrame.chartMessage.isSender) ? [UIImage lyt_chatImageNamed:@"气泡-左"] : [UIImage lyt_chatImageNamed:@"气泡-右"];
    
    //UIEdgeInsets insets = UIEdgeInsetsMake(49,10,30,20);
    UIEdgeInsets insets =  UIEdgeInsetsMake(normal.size.height * 0.7, normal.size.width * 0.3, normal.size.height * 0.2, normal.size.width * 0.3);
    
    self.bubbleImageView.image = [normal resizableImageWithCapInsets:insets resizingMode: UIImageResizingModeStretch];
}
@end
