//
//  UIViewController+HPWYSAdditions.h
//  HPWYSonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "HPWYSUtilities.h"
#import "HPWYSConstraintMaker.h"
#import "HPWYSViewAttribute.h"

#ifdef HPWYS_VIEW_CONTROLLER

@interface HPWYS_VIEW_CONTROLLER (HPWYSAdditions)

/**
 *	following properties return a new HPWYSViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_topLayoutGuide;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_bottomLayoutGuide;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_topLayoutGuideTop;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) HPWYSViewAttribute *hpwys_bottomLayoutGuideBottom;


@end

#endif
