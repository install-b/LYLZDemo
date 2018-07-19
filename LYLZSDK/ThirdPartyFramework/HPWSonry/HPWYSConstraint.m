//
//  HPWYSConstraint.m
//  HPWYsonry
//
//  Created by Nick Tymchenko on 1/20/14.
//

#import "HPWYSConstraint.h"
#import "HPWYSConstraint+Private.h"

#define HPWYSMethodNotImplemented() \
    @throw [NSException exceptionWithName:NSInternalInconsistencyException \
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)] \
                                 userInfo:nil]

@implementation HPWYSConstraint

#pragma mark - Init

- (id)init {
	NSAssert(![self isMemberOfClass:[HPWYSConstraint class]], @"HPWYSConstraint is an abstract class, you should not instantiate it directly.");
	return [super init];
}

#pragma mark - NSLayoutRelation proxies

- (HPWYSConstraint * (^)(id))equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (HPWYSConstraint * (^)(id))hpwys_equalTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (HPWYSConstraint * (^)(id))greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (HPWYSConstraint * (^)(id))hpwys_greaterThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}

- (HPWYSConstraint * (^)(id))lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

- (HPWYSConstraint * (^)(id))hpwys_lessThanOrEqualTo {
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}

#pragma mark - HPWYSLayoutPriority proxies

- (HPWYSConstraint * (^)(void))priorityLow {
    return ^id{
        self.priority(HPWYSLayoutPriorityDefaultLow);
        return self;
    };
}

- (HPWYSConstraint * (^)(void))priorityMedium {
    return ^id{
        self.priority(HPWYSLayoutPriorityDefaultMedium);
        return self;
    };
}

- (HPWYSConstraint * (^)(void))priorityHigh {
    return ^id{
        self.priority(HPWYSLayoutPriorityDefaultHigh);
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant proxies

- (HPWYSConstraint * (^)(HPWYSEdgeInsets))insets {
    return ^id(HPWYSEdgeInsets insets){
        self.insets = insets;
        return self;
    };
}

- (HPWYSConstraint * (^)(CGSize))sizeOffset {
    return ^id(CGSize offset) {
        self.sizeOffset = offset;
        return self;
    };
}

- (HPWYSConstraint * (^)(CGPoint))centerOffset {
    return ^id(CGPoint offset) {
        self.centerOffset = offset;
        return self;
    };
}

- (HPWYSConstraint * (^)(CGFloat))offset {
    return ^id(CGFloat offset){
        self.offset = offset;
        return self;
    };
}

- (HPWYSConstraint * (^)(NSValue *value))valueOffset {
    return ^id(NSValue *offset) {
        NSAssert([offset isKindOfClass:NSValue.class], @"expected an NSValue offset, got: %@", offset);
        [self setLayoutConstantWithValue:offset];
        return self;
    };
}

- (HPWYSConstraint * (^)(id offset))hpwys_offset {
    // Will never be called due to macro
    return nil;
}

#pragma mark - NSLayoutConstraint constant setter

- (void)setLayoutConstantWithValue:(NSValue *)value {
    if ([value isKindOfClass:NSNumber.class]) {
        self.offset = [(NSNumber *)value doubleValue];
    } else if (strcmp(value.objCType, @encode(CGPoint)) == 0) {
        CGPoint point;
        [value getValue:&point];
        self.centerOffset = point;
    } else if (strcmp(value.objCType, @encode(CGSize)) == 0) {
        CGSize size;
        [value getValue:&size];
        self.sizeOffset = size;
    } else if (strcmp(value.objCType, @encode(HPWYSEdgeInsets)) == 0) {
        HPWYSEdgeInsets insets;
        [value getValue:&insets];
        self.insets = insets;
    } else {
        NSAssert(NO, @"attempting to set layout constant with unsupported value: %@", value);
    }
}

#pragma mark - Semantic properties

- (HPWYSConstraint *)with {
    return self;
}

- (HPWYSConstraint *)and {
    return self;
}

#pragma mark - Chaining

- (HPWYSConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute __unused)layoutAttribute {
    HPWYSMethodNotImplemented();
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

#pragma mark - Abstract

- (HPWYSConstraint * (^)(CGFloat multiplier))multipliedBy { HPWYSMethodNotImplemented(); }

- (HPWYSConstraint * (^)(CGFloat divider))dividedBy { HPWYSMethodNotImplemented(); }

- (HPWYSConstraint * (^)(HPWYSLayoutPriority priority))priority { HPWYSMethodNotImplemented(); }

- (HPWYSConstraint * (^)(id, NSLayoutRelation))equalToWithRelation { HPWYSMethodNotImplemented(); }

- (HPWYSConstraint * (^)(id key))key { HPWYSMethodNotImplemented(); }

- (void)setInsets:(HPWYSEdgeInsets __unused)insets { HPWYSMethodNotImplemented(); }

- (void)setSizeOffset:(CGSize __unused)sizeOffset { HPWYSMethodNotImplemented(); }

- (void)setCenterOffset:(CGPoint __unused)centerOffset { HPWYSMethodNotImplemented(); }

- (void)setOffset:(CGFloat __unused)offset { HPWYSMethodNotImplemented(); }

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (HPWYSConstraint *)animator { HPWYSMethodNotImplemented(); }

#endif

- (void)activate { HPWYSMethodNotImplemented(); }

- (void)deactivate { HPWYSMethodNotImplemented(); }

- (void)install { HPWYSMethodNotImplemented(); }

- (void)uninstall { HPWYSMethodNotImplemented(); }

@end
