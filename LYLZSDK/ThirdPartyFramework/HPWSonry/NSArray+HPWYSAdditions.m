//
//  NSArray+HPWYSAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+HPWYSAdditions.h"
#import "View+HPWYSAdditions.h"

@implementation NSArray (HPWYSAdditions)

- (NSArray *)hpwys_makeConstraints:(void(^)(HPWYSConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HPWYS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HPWYS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hpwys_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)hpwys_updateConstraints:(void(^)(HPWYSConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HPWYS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HPWYS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hpwys_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)hpwys_remakeConstraints:(void(^)(HPWYSConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HPWYS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HPWYS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view hpwys_remakeConstraints:block]];
    }
    return constraints;
}

- (void)hpwys_distributeViewsAlongAxis:(HPWYSAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HPWYS_VIEW *tempSuperView = [self hpwys_commonSuperviewOfViews];
    if (axisType == HPWYSAxisTypeHorizontal) {
        HPWYS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HPWYS_VIEW *v = self[i];
            [v hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.hpwys_right).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        HPWYS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HPWYS_VIEW *v = self[i];
            [v hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.hpwys_bottom).offset(fixedSpacing);
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)hpwys_distributeViewsAlongAxis:(HPWYSAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HPWYS_VIEW *tempSuperView = [self hpwys_commonSuperviewOfViews];
    if (axisType == HPWYSAxisTypeHorizontal) {
        HPWYS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HPWYS_VIEW *v = self[i];
            [v hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.width.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                    make.width.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
    else {
        HPWYS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HPWYS_VIEW *v = self[i];
            [v hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
                if (prev) {
                    CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                    make.height.equalTo(@(fixedItemLength));
                    if (i == (CGFloat)self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                    make.height.equalTo(@(fixedItemLength));
                }
            }];
            prev = v;
        }
    }
}

- (HPWYS_VIEW *)hpwys_commonSuperviewOfViews
{
    HPWYS_VIEW *commonSuperview = nil;
    HPWYS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[HPWYS_VIEW class]]) {
            HPWYS_VIEW *view = (HPWYS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view hpwys_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
