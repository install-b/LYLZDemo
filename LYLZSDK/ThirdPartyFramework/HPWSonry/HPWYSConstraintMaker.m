//
//  HPWYSConstraintBuilder.m
//  HPWYsonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSConstraintMaker.h"
#import "HPWYSViewConstraint.h"
#import "HPWYSCompositeConstraint.h"
#import "HPWYSConstraint+Private.h"
#import "HPWYSViewAttribute.h"
#import "View+HPWYSAdditions.h"

@interface HPWYSConstraintMaker () <HPWYSConstraintDelegate>

@property (nonatomic, weak) HPWYS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation HPWYSConstraintMaker

- (id)initWithView:(HPWYS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [HPWYSViewConstraint installedConstraintsForView:self.view];
        for (HPWYSConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (HPWYSConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - HPWYSConstraintDelegate

- (void)constraint:(HPWYSConstraint *)constraint shouldBeReplacedWithConstraint:(HPWYSConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (HPWYSConstraint *)constraint:(HPWYSConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    HPWYSViewAttribute *viewAttribute = [[HPWYSViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    HPWYSViewConstraint *newConstraint = [[HPWYSViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:HPWYSViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        HPWYSCompositeConstraint *compositeConstraint = [[HPWYSCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (HPWYSConstraint *)addConstraintWithAttributes:(HPWYSAttribute)attrs {
    __unused HPWYSAttribute anyAttribute = (HPWYSAttributeLeft | HPWYSAttributeRight | HPWYSAttributeTop | HPWYSAttributeBottom | HPWYSAttributeLeading
                                          | HPWYSAttributeTrailing | HPWYSAttributeWidth | HPWYSAttributeHeight | HPWYSAttributeCenterX
                                          | HPWYSAttributeCenterY | HPWYSAttributeBaseline
#if TARGET_OS_IPHONE || TARGET_OS_TV
                                          | HPWYSAttributeLeftMargin | HPWYSAttributeRightMargin | HPWYSAttributeTopMargin | HPWYSAttributeBottomMargin
                                          | HPWYSAttributeLeadingMargin | HPWYSAttributeTrailingMargin | HPWYSAttributeCenterXWithinMargins
                                          | HPWYSAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & HPWYSAttributeLeft) [attributes addObject:self.view.hpwys_left];
    if (attrs & HPWYSAttributeRight) [attributes addObject:self.view.hpwys_right];
    if (attrs & HPWYSAttributeTop) [attributes addObject:self.view.hpwys_top];
    if (attrs & HPWYSAttributeBottom) [attributes addObject:self.view.hpwys_bottom];
    if (attrs & HPWYSAttributeLeading) [attributes addObject:self.view.hpwys_leading];
    if (attrs & HPWYSAttributeTrailing) [attributes addObject:self.view.hpwys_trailing];
    if (attrs & HPWYSAttributeWidth) [attributes addObject:self.view.hpwys_width];
    if (attrs & HPWYSAttributeHeight) [attributes addObject:self.view.hpwys_height];
    if (attrs & HPWYSAttributeCenterX) [attributes addObject:self.view.hpwys_centerX];
    if (attrs & HPWYSAttributeCenterY) [attributes addObject:self.view.hpwys_centerY];
    if (attrs & HPWYSAttributeBaseline) [attributes addObject:self.view.hpwys_baseline];
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    if (attrs & HPWYSAttributeLeftMargin) [attributes addObject:self.view.hpwys_leftMargin];
    if (attrs & HPWYSAttributeRightMargin) [attributes addObject:self.view.hpwys_rightMargin];
    if (attrs & HPWYSAttributeTopMargin) [attributes addObject:self.view.hpwys_topMargin];
    if (attrs & HPWYSAttributeBottomMargin) [attributes addObject:self.view.hpwys_bottomMargin];
    if (attrs & HPWYSAttributeLeadingMargin) [attributes addObject:self.view.hpwys_leadingMargin];
    if (attrs & HPWYSAttributeTrailingMargin) [attributes addObject:self.view.hpwys_trailingMargin];
    if (attrs & HPWYSAttributeCenterXWithinMargins) [attributes addObject:self.view.hpwys_centerXWithinMargins];
    if (attrs & HPWYSAttributeCenterYWithinMargins) [attributes addObject:self.view.hpwys_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (HPWYSViewAttribute *a in attributes) {
        [children addObject:[[HPWYSViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    HPWYSCompositeConstraint *constraint = [[HPWYSCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (HPWYSConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (HPWYSConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (HPWYSConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (HPWYSConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (HPWYSConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (HPWYSConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (HPWYSConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (HPWYSConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (HPWYSConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (HPWYSConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (HPWYSConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (HPWYSConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (HPWYSConstraint *(^)(HPWYSAttribute))attributes {
    return ^(HPWYSAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HPWYSConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HPWYSConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (HPWYSConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (HPWYSConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HPWYSConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HPWYSConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HPWYSConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HPWYSConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (HPWYSConstraint *)edges {
    return [self addConstraintWithAttributes:HPWYSAttributeTop | HPWYSAttributeLeft | HPWYSAttributeRight | HPWYSAttributeBottom];
}

- (HPWYSConstraint *)size {
    return [self addConstraintWithAttributes:HPWYSAttributeWidth | HPWYSAttributeHeight];
}

- (HPWYSConstraint *)center {
    return [self addConstraintWithAttributes:HPWYSAttributeCenterX | HPWYSAttributeCenterY];
}

#pragma mark - grouping

- (HPWYSConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        HPWYSCompositeConstraint *constraint = [[HPWYSCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
