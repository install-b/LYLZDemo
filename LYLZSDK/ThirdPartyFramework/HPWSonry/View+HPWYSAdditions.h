//
//  UIView+HPWYSAdditions.h
//  HPWYSonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSUtilities.h"
#import "HPWYSConstraintMaker.h"
#import "HPWYSViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating HPWYSViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface HPWYS_VIEW (HPWYSAdditions)

/**
 *	following properties return a new HPWYSViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_left;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_top;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_right;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_bottom;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_leading;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_trailing;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_width;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_height;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_centerX;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_centerY;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_baseline;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *(^hpwys_attribute)(NSLayoutAttribute attr);

#if TARGET_OS_IPHONE || TARGET_OS_TV

@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_leftMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_rightMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_topMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_bottomMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_leadingMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_trailingMargin;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_centerXWithinMargins;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_centerYWithinMargins;

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id hpwys_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)hpwys_closestCommonSuperview:(HPWYS_VIEW *)view;

/**
 *  Creates a HPWYSConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created HPWYSConstraints
 */
- (NSArray *)hpwys_makeConstraints:(void(^)(HPWYSConstraintMaker *make))block;

/**
 *  Creates a HPWYSConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HPWYSConstraints
 */
- (NSArray *)hpwys_updateConstraints:(void(^)(HPWYSConstraintMaker *make))block;

/**
 *  Creates a HPWYSConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HPWYSConstraints
 */
- (NSArray *)hpwys_remakeConstraints:(void(^)(HPWYSConstraintMaker *make))block;

@end
