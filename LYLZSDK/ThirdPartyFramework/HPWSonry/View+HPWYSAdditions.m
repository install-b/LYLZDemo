//
//  UIView+HPWYSAdditions.m
//  HPWYSonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+HPWYSAdditions.h"
#import <objc/runtime.h>

@implementation HPWYS_VIEW (HPWYSAdditions)

- (NSArray *)hpwys_makeConstraints:(void(^)(HPWYSConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HPWYSConstraintMaker *constraintMaker = [[HPWYSConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)hpwys_updateConstraints:(void(^)(HPWYSConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HPWYSConstraintMaker *constraintMaker = [[HPWYSConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)hpwys_remakeConstraints:(void(^)(HPWYSConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HPWYSConstraintMaker *constraintMaker = [[HPWYSConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (HPWYSViewAttribute *)hpwys_left {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (HPWYSViewAttribute *)hpwys_top {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (HPWYSViewAttribute *)hpwys_right {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (HPWYSViewAttribute *)hpwys_bottom {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (HPWYSViewAttribute *)hpwys_leading {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (HPWYSViewAttribute *)hpwys_trailing {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (HPWYSViewAttribute *)hpwys_width {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (HPWYSViewAttribute *)hpwys_height {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (HPWYSViewAttribute *)hpwys_centerX {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (HPWYSViewAttribute *)hpwys_centerY {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (HPWYSViewAttribute *)hpwys_baseline {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (HPWYSViewAttribute *(^)(NSLayoutAttribute))hpwys_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HPWYSViewAttribute *)hpwys_leftMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HPWYSViewAttribute *)hpwys_rightMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (HPWYSViewAttribute *)hpwys_topMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (HPWYSViewAttribute *)hpwys_bottomMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HPWYSViewAttribute *)hpwys_leadingMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HPWYSViewAttribute *)hpwys_trailingMargin {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HPWYSViewAttribute *)hpwys_centerXWithinMargins {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HPWYSViewAttribute *)hpwys_centerYWithinMargins {
    return [[HPWYSViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#pragma mark - associated properties

- (id)hpwys_key {
    return objc_getAssociatedObject(self, @selector(hpwys_key));
}

- (void)setHpwys_key:(id)key {
    objc_setAssociatedObject(self, @selector(hpwys_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)hpwys_closestCommonSuperview:(HPWYS_VIEW *)view {
    HPWYS_VIEW *closestCommonSuperview = nil;

    HPWYS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        HPWYS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
