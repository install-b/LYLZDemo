//
//  HPWYSConstraint.h
//  HPWYSonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (HPWYSViewConstraint) 
 *  or a group of NSLayoutConstraints (HPWYSComposisteConstraint)
 */
@interface HPWYSConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (HPWYSConstraint * (^)(HPWYSEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (HPWYSConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (HPWYSConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (HPWYSConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (HPWYSConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (HPWYSConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (HPWYSConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or HPWYSLayoutPriority
 */
- (HPWYSConstraint * (^)(HPWYSLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to HPWYSLayoutPriorityLow
 */
- (HPWYSConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to HPWYSLayoutPriorityMedium
 */
- (HPWYSConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to HPWYSLayoutPriorityHigh
 */
- (HPWYSConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    HPWYSViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HPWYSConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    HPWYSViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HPWYSConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    HPWYSViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HPWYSConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HPWYSConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HPWYSConstraint *)and;

/**
 *	Creates a new HPWYSCompositeConstraint with the called attribute and reciever
 */
- (HPWYSConstraint *)left;
- (HPWYSConstraint *)top;
- (HPWYSConstraint *)right;
- (HPWYSConstraint *)bottom;
- (HPWYSConstraint *)leading;
- (HPWYSConstraint *)trailing;
- (HPWYSConstraint *)width;
- (HPWYSConstraint *)height;
- (HPWYSConstraint *)centerX;
- (HPWYSConstraint *)centerY;
- (HPWYSConstraint *)baseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (HPWYSConstraint *)leftMargin;
- (HPWYSConstraint *)rightMargin;
- (HPWYSConstraint *)topMargin;
- (HPWYSConstraint *)bottomMargin;
- (HPWYSConstraint *)leadingMargin;
- (HPWYSConstraint *)trailingMargin;
- (HPWYSConstraint *)centerXWithinMargins;
- (HPWYSConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (HPWYSConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of HPWYS_updateConstraints/HPWYS_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(HPWYSEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HPWYSConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) HPWYSConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for HPWYSConstraint methods.
 *
 *  Defining HPWYS_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define hpwys_equalTo(...)                 equalTo(HPWYSBoxValue((__VA_ARGS__)))
#define hpwys_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(HPWYSBoxValue((__VA_ARGS__)))
#define hpwys_lessThanOrEqualTo(...)       lessThanOrEqualTo(HPWYSBoxValue((__VA_ARGS__)))

#define hpwys_offset(...)                  valueOffset(HPWYSBoxValue((__VA_ARGS__)))


#ifdef HPWYS_SHORTHAND_GLOBALS

#define equalTo(...)                     hpwys_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        hpwys_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           hpwys_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      hpwys_offset(__VA_ARGS__)

#endif


@interface HPWYSConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (HPWYSConstraint * (^)(id attr))hpwys_equalTo;
- (HPWYSConstraint * (^)(id attr))hpwys_greaterThanOrEqualTo;
- (HPWYSConstraint * (^)(id attr))hpwys_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (HPWYSConstraint * (^)(id offset))hpwys_offset;

@end
