//
//  HPWYSConstraintBuilder.h
//  HPWYsonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSConstraint.h"
#import "HPWYSUtilities.h"

typedef NS_OPTIONS(NSInteger, HPWYSAttribute) {
    HPWYSAttributeLeft = 1 << NSLayoutAttributeLeft,
    HPWYSAttributeRight = 1 << NSLayoutAttributeRight,
    HPWYSAttributeTop = 1 << NSLayoutAttributeTop,
    HPWYSAttributeBottom = 1 << NSLayoutAttributeBottom,
    HPWYSAttributeLeading = 1 << NSLayoutAttributeLeading,
    HPWYSAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    HPWYSAttributeWidth = 1 << NSLayoutAttributeWidth,
    HPWYSAttributeHeight = 1 << NSLayoutAttributeHeight,
    HPWYSAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    HPWYSAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    HPWYSAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if TARGET_OS_IPHONE || TARGET_OS_TV
    
    HPWYSAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    HPWYSAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    HPWYSAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    HPWYSAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    HPWYSAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    HPWYSAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    HPWYSAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    HPWYSAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating HPWYSConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface HPWYSConstraintMaker : NSObject

/**
 *	The following properties return a new HPWYSViewConstraint
 *  with the first item set to the makers associated view and the appropriate HPWYSViewAttribute
 */
@property (nonatomic, strong, readonly) HPWYSConstraint *left;
@property (nonatomic, strong, readonly) HPWYSConstraint *top;
@property (nonatomic, strong, readonly) HPWYSConstraint *right;
@property (nonatomic, strong, readonly) HPWYSConstraint *bottom;
@property (nonatomic, strong, readonly) HPWYSConstraint *leading;
@property (nonatomic, strong, readonly) HPWYSConstraint *trailing;
@property (nonatomic, strong, readonly) HPWYSConstraint *width;
@property (nonatomic, strong, readonly) HPWYSConstraint *height;
@property (nonatomic, strong, readonly) HPWYSConstraint *centerX;
@property (nonatomic, strong, readonly) HPWYSConstraint *centerY;
@property (nonatomic, strong, readonly) HPWYSConstraint *baseline;

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HPWYSConstraint *leftMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *rightMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *topMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *bottomMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *leadingMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *trailingMargin;
@property (nonatomic, strong, readonly) HPWYSConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) HPWYSConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new HPWYSCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  HPWYSAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) HPWYSConstraint *(^attributes)(HPWYSAttribute attrs);

/**
 *	Creates a HPWYSCompositeConstraint with type HPWYSCompositeConstraintTypeEdges
 *  which generates the appropriate HPWYSViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HPWYSConstraint *edges;

/**
 *	Creates a HPWYSCompositeConstraint with type HPWYSCompositeConstraintTypeSize
 *  which generates the appropriate HPWYSViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HPWYSConstraint *size;

/**
 *	Creates a HPWYSCompositeConstraint with type HPWYSCompositeConstraintTypeCenter
 *  which generates the appropriate HPWYSViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HPWYSConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any HPWYSConstrait are created with this view as the first item
 *
 *	@return	a new HPWYSConstraintMaker
 */
- (id)initWithView:(HPWYS_VIEW *)view;

/**
 *	Calls install method on any HPWYSConstraints which have been created by this maker
 *
 *	@return	an array of all the installed HPWYSConstraints
 */
- (NSArray *)install;

- (HPWYSConstraint * (^)(dispatch_block_t))group;

@end
