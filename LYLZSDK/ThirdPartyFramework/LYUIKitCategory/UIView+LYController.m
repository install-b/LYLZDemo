//
//  UIView+LYController.m
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/4/5.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "UIView+LYController.h"

@implementation UIView (LYController)

- (nullable UIViewController *)selfController {
    
    id nextResponder = self.nextResponder;
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    }else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder selfController];// 递归
    }
    
    return nil;
}

@end
