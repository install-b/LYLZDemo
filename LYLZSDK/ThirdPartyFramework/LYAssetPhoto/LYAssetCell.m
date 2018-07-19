//
//  LYAssetCell.m
//  TaiYangHua
//
//  Created by Lc on 16/2/16.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAssetCell.h"
#import "HPWYsonry.h"

@implementation LYAssetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        imageV.userInteractionEnabled = YES;
        _imageView = imageV;
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_imageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
}


//- (void)pinch:(UIPinchGestureRecognizer *)pinch
//{
//    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, pinch.scale, pinch.scale);
//    pinch.scale = 1;
//    
//}

//- (void)rotation:(UIRotationGestureRecognizer *)rotation
//{
//    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rotation.rotation);
//
//    rotation.rotation = 0;
//
//}

//- (void)pan:(UIPanGestureRecognizer *)pan
//{
//    
//    CGPoint transP = [pan translationInView:self.contentView];
//    
//    DLog(@"%f", transP.x);
//    self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, transP.x, transP.y);
//    
//    [pan setTranslation:CGPointZero inView:self.contentView];
//}
//
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}
@end
