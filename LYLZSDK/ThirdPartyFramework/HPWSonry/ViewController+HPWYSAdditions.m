//
//  UIViewController+HPWYSAdditions.m
//  HPWYSonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+HPWYSAdditions.h"

#ifdef HPWYS_VIEW_CONTROLLER

@implementation HPWYS_VIEW_CONTROLLER (HPWYSAdditions)

- (HPWYSViewAttribute *)hpwys_topLayoutGuide {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (HPWYSViewAttribute *)hpwys_topLayoutGuideTop {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HPWYSViewAttribute *)hpwys_topLayoutGuideBottom {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (HPWYSViewAttribute *)hpwys_bottomLayoutGuide {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HPWYSViewAttribute *)hpwys_bottomLayoutGuideTop {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HPWYSViewAttribute *)hpwys_bottomLayoutGuideBottom {
    return [[HPWYSViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
