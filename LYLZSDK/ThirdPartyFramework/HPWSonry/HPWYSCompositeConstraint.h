//
//  HPWYSCompositeConstraint.h
//  HPWYSonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HPWYSConstraint.h"
#import "HPWYSUtilities.h"

/**
 *	A group of HPWYSConstraint objects
 */
@interface HPWYSCompositeConstraint : HPWYSConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child HPWYSConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
