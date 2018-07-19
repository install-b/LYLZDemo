//
//  HPWYSConstraint.h
//  HPWYSonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSViewAttribute.h"
#import "HPWYSConstraint.h"
#import "HPWYSLayoutConstraint.h"
#import "HPWYSUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface HPWYSViewConstraint : HPWYSConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HPWYSViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HPWYSViewAttribute *secondViewAttribute;

/**
 *	initialises the HPWYSViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.hpwys_left, view.hpwys_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(HPWYSViewAttribute *)firstViewAttribute;

/**
 *  Returns all HPWYSViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of HPWYSViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(HPWYS_VIEW *)view;

@end
