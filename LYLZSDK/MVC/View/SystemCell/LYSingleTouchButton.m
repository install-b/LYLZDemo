//
//  LZOrderJumpButton.m
//  LZSDKDemo
//
//  Created by hhly on 2017/9/19.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "LYSingleTouchButton.h"
#import <objc/message.h>

static BOOL isTapAction = NO;
static UITouch *currentTouch = nil;


@implementation LYSingleTouchButton
+ (void)load {
    Method touchesBegan = class_getInstanceMethod(self, @selector(touchesBegan:withEvent:));
    Method ly_touchesBegan = class_getInstanceMethod(self, @selector(ly_touchesBegan:withEvent:));
    // 黑魔法 交换
    method_exchangeImplementations(touchesBegan, ly_touchesBegan);
    
    Method touchesEnded = class_getInstanceMethod(self, @selector(touchesEnded:withEvent:));
    Method ly_touchesEnded = class_getInstanceMethod(self, @selector(ly_touchesEnded:withEvent:));
    // 黑魔法 交换
    method_exchangeImplementations(touchesEnded, ly_touchesEnded);
    
    Method touchesCancelled = class_getInstanceMethod(self, @selector(touchesCancelled:withEvent:));
    Method ly_touchesCancelled = class_getInstanceMethod(self, @selector(ly_touchesCancelled:withEvent:));
    // 黑魔法 交换
    method_exchangeImplementations(touchesCancelled, ly_touchesCancelled);
}
#pragma mark - exchange method
- (void)ly_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (isTapAction) {
        return;
    }
    currentTouch = touches.anyObject;
    isTapAction = YES;
    // 回调原始方法
    [self ly_touchesBegan:touches withEvent:event];
}

- (void)ly_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (currentTouch && [touches containsObject:currentTouch]) {
        isTapAction = NO;
        currentTouch = nil;
    }
    // 回调原始方法
    [self ly_touchesEnded:touches withEvent:event];
}

- (void)ly_touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (currentTouch && [touches containsObject:currentTouch]) {
        isTapAction = NO;
        currentTouch = nil;
    }
    // 回调原始方法
    [self ly_touchesCancelled:touches withEvent:event];
}

#pragma mark - orgin method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
}

@end
