//
//  LYMoreInputView.m
//  LYLink
//
//  Created by SYLing on 2016/12/19.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYMoreInputView.h"
#import "LYAddOperationButton.h"
#import "UIImage+BundleImage.h"

#define cols 4
#define btnW 60
#define btnH 80
#define space 10

#define LYScreenW [UIScreen mainScreen].bounds.size.width
#define margin (LYScreenW - cols * btnW) / (cols + 1)

@interface LYMoreInputView()

/** 按钮数组 */
@property (nonatomic ,strong) NSArray *buttonArray;
@end
@implementation LYMoreInputView

- (instancetype)initAddButtonWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.buttonArray = buttonArray;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    for (int i = 0; i < self.buttonArray.count; i++) {
        NSDictionary *buttonDic = self.buttonArray[i];//selectedTitle selectedTitle
        
        //UIImage *image = [UIImage lyt_chatImageNamed:buttonDic[@"image"]];
        
        UIButton *btn = [self addButtonWithImage:[UIImage lyt_chatImageNamed:buttonDic[@"image"]] title:buttonDic[@"title"] selectedTitle:buttonDic[@"selectedTitle"]  atIdex:i];
        if (buttonDic[@"selectedTitle"] && buttonDic[@"sessionId"]) {
            btn.selected =  YES;
        }
    }
}

// 快速添加按钮
- (LYAddOperationButton *)addButtonWithImage:(UIImage *)image title:(NSString *)title selectedTitle:(NSString *)selectedTitle atIdex:(NSInteger)index {
    
    NSInteger col  = index % cols;
    NSInteger line = index / cols;
    CGRect frame = CGRectMake(margin + (btnW + margin) * col, space + (btnH + space) * line, btnW, btnH);
    LYAddOperationButton *btn = [LYAddOperationButton buttonWithFrame:frame image:image  title:title];
    [btn setTitle:selectedTitle forState:UIControlStateSelected];
//    if (iPhone6SP) {
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
//    } else {
//    }
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    btn.tag = index + 10;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)btnClick:(UIButton *)sender {
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(moreInputView:didClicMoreButtonWithIndex:)]) {
        [self.delegate moreInputView:self didClicMoreButtonWithIndex:sender.tag - 10];
    }
    
}
#pragma mark - click events
- (UIImage *)compressImage:(UIImage *)sourceImage toTargetWidth:(CGFloat)targetWidth {
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)setSelecte:(BOOL)selected ForAddButtonWithIndex:(NSInteger)index {
    LYAddOperationButton *btn = (LYAddOperationButton*)[self viewWithTag:index + 10];
    if ([btn isKindOfClass:[LYAddOperationButton class]]) {
        btn.selected = selected;
    }
}
@end
