//
//  LYAddOperationButton.m
//  TaiYangHua
//
//  Created by admin on 16/11/1.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYAddOperationButton.h"

#define ratio 0.7

@interface LYAddOperationButton ()


@end


@implementation LYAddOperationButton

+ (instancetype)buttonWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title {

    return [[self alloc] initWithFrame:frame image:image title:title];
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title {
    
    if (self = [super initWithFrame:frame]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setImage:image forState:UIControlStateNormal];
    }
    
    return self;
}


#pragma 重新布局
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGRect titleRect = contentRect;
    
    titleRect.size.height = contentRect.size.height * (1 - ratio);
    
    titleRect.origin.y = contentRect.origin.y + contentRect.size.height * ratio;
    
    return titleRect;
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGRect imageRect = contentRect;
    CGFloat ratioHeight = contentRect.size.height * ratio;
    
    
    if (ratioHeight > contentRect.size.width) {
        
        imageRect.size.height = contentRect.size.width;
        imageRect.origin.y = contentRect.origin.y + (ratioHeight - contentRect.size.width) * 0.5;
        
    }else {
        
        imageRect.size.height = contentRect.size.height * ratio;
        imageRect.origin.x = contentRect.origin.x + (contentRect.size.width - ratioHeight) * 0.5;
        
    }
    
    return imageRect;

}
@end
