 //
//  PrgressView.m
//  20161213
//
//  Created by Leon on 2016/12/13.
//  Copyright © 2016年 Leon. All rights reserved.
//

#import "PrgressView.h"

@implementation PrgressView


- (void)drawRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width * self.progerss, self.frame.size.height) cornerRadius:0];
    [[UIColor redColor] setFill];//进度条颜色
    [path fill];
}


- (void)setProgerss:(CGFloat)progerss{
    _progerss = progerss;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
