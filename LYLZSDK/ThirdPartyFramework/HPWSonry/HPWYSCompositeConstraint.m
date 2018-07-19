//
//  HPWYSCompositeConstraint.m
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSCompositeConstraint.h"
#import "HPWYSConstraint+Private.h"

@interface HPWYSCompositeConstraint () <HPWYSConstraintDelegate>

@property (nonatomic, strong) id hpwys_key;
@property (nonatomic, strong) NSMutableArray *childConstraints;

@end

@implementation HPWYSCompositeConstraint

- (id)initWithChildren:(NSArray *)children {
    self = [super init];
    if (!self) return nil;

    _childConstraints = [children mutableCopy];
    for (HPWYSConstraint *constraint in _childConstraints) {
        constraint.delegate = self;
    }

    return self;
}

#pragma mark - HPWYSConstraintDelegate

- (void)constraint:(HPWYSConstraint *)constraint shouldBeReplacedWithConstraint:(HPWYSConstraint *)replacementConstraint {
    NSUInteger index = [self.childConstraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.childConstraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (HPWYSConstraint *)constraint:(HPWYSConstraint __unused *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    id<HPWYSConstraintDelegate> strongDelegate = self.delegate;
    HPWYSConstraint *newConstraint = [strongDelegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    newConstraint.delegate = self;
    [self.childConstraints addObject:newConstraint];
    return newConstraint;
}

#pragma mark - NSLayoutConstraint multiplier proxies 

- (HPWYSConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        for (HPWYSConstraint *constraint in self.childConstraints) {
            constraint.multipliedBy(multiplier);
        }
        return self;
    };
}

- (HPWYSConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        for (HPWYSConstraint *constraint in self.childConstraints) {
            constraint.dividedBy(divider);
        }
        return self;
    };
}

#pragma mark - HPWYSLayoutPriority proxy

- (HPWYSConstraint * (^)(HPWYSLayoutPriority))priority {
    return ^id(HPWYSLayoutPriority priority) {
        for (HPWYSConstraint *constraint in self.childConstraints) {
            constraint.priority(priority);
        }
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (HPWYSConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attr, NSLayoutRelation relation) {
        for (HPWYSConstraint *constraint in self.childConstraints.copy) {
            constraint.equalToWithRelation(attr, relation);
        }
        return self;
    };
}

#pragma mark - attribute chaining

- (HPWYSConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    [self constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
    return self;
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (HPWYSConstraint *)animator {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        [constraint animator];
    }
    return self;
}

#endif

#pragma mark - debug helpers

- (HPWYSConstraint * (^)(id))key {
    return ^id(id key) {
        self.hpwys_key = key;
        int i = 0;
        for (HPWYSConstraint *constraint in self.childConstraints) {
            constraint.key([NSString stringWithFormat:@"%@[%d]", key, i++]);
        }
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(HPWYSEdgeInsets)insets {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        constraint.insets = insets;
    }
}

- (void)setOffset:(CGFloat)offset {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        constraint.offset = offset;
    }
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        constraint.sizeOffset = sizeOffset;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        constraint.centerOffset = centerOffset;
    }
}

#pragma mark - HPWYSConstraint

- (void)activate {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        [constraint activate];
    }
}

- (void)deactivate {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        [constraint deactivate];
    }
}

- (void)install {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
}

- (void)uninstall {
    for (HPWYSConstraint *constraint in self.childConstraints) {
        [constraint uninstall];
    }
}

@end
