//
//  UIView+Toast.m
//  Toast
//
//  Copyright 2014 Charles Scalesse.
//


#import "UIView+HPWYSToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

/*
 *  CONFIGURE THESE VALUES TO ADJUST LOOK & FEEL,
 *  DISPLAY DURATION, ETC.
 */

// general appearance
static const CGFloat HPWYSToastMaxWidth            = 0.8;      // 80% of parent view width
static const CGFloat HPWYSToastMaxHeight           = 0.8;      // 80% of parent view height
static const CGFloat HPWYSToastHorizontalPadding   = 10.0;
static const CGFloat HPWYSToastVerticalPadding     = 10.0;
static const CGFloat HPWYSToastCornerRadius        = 10.0;
static const CGFloat HPWYSToastOpacity             = 0.8;
static const CGFloat HPWYSToastFontSize            = 16.0;
static const CGFloat HPWYSToastMaxTitleLines       = 0;
static const CGFloat HPWYSToastMaxMessageLines     = 0;
static const NSTimeInterval HPWYSToastFadeDuration = 0.2;

// shadow appearance
static const CGFloat HPWYSToastShadowOpacity       = 0.8;
static const CGFloat HPWYSToastShadowRadius        = 6.0;
static const CGSize  HPWYSToastShadowOffset        = { 4.0, 4.0 };
static const BOOL    HPWYSToastDisplayShadow       = YES;

// display duration
static const NSTimeInterval HPWYSToastDefaultDuration  = 3.0;

// image view size
static const CGFloat HPWYSToastImageViewWidth      = 80.0;
static const CGFloat HPWYSToastImageViewHeight     = 80.0;

// activity
static const CGFloat HPWYSToastActivityWidth       = 100.0;
static const CGFloat HPWYSToastActivityHeight      = 100.0;
static const NSString * HPWYSToastActivityDefaultPosition = @"center";

// interaction
static const BOOL HPWYSToastHidesOnTap             = YES;     // excludes activity views

// associative reference keys
static const NSString * HPWYSToastTimerKey         = @"CSToastTimerKey";
static const NSString * HPWYSToastActivityViewKey  = @"CSToastActivityViewKey";
static const NSString * HPWYSToastTapCallbackKey   = @"CSToastTapCallbackKey";

// positions
NSString * const HPWYSToastPositionTop             = @"top";
NSString * const HPWYSToastPositionCenter          = @"center";
NSString * const HPWYSToastPositionBottom          = @"bottom";

@interface UIView (HPWYSToastPrivate)

- (void)HPWYShideToast:(UIView *)toast;
- (void)HPWYStoastTimerDidFinish:(NSTimer *)timer;
- (void)HPWYShandleToastTapped:(UITapGestureRecognizer *)recognizer;
- (CGPoint)HPWYScenterPointForPosition:(id)position withToast:(UIView *)toast;
- (UIView *)HPWYSviewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image;
- (CGSize)HPWYSsizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end


@implementation UIView (HPWYSToast)

#pragma mark - Toast Methods

- (void)HPWYSmakeToast:(NSString *)message {
    [self HPWYSmakeToast:message duration:HPWYSToastDefaultDuration position:nil];
}

- (void)HPWYSmakeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position {
    UIView *toast = [self HPWYSviewForMessage:message title:nil image:nil];
    [self HPWYSshowToast:toast duration:duration position:position];
}

- (void)HPWYSmakeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position title:(NSString *)title {
    UIView *toast = [self HPWYSviewForMessage:message title:title image:nil];
    [self HPWYSshowToast:toast duration:duration position:position];
}

- (void)HPWYSmakeToast:(NSString *)message duration:(NSTimeInterval)duration position:(id)position image:(UIImage *)image {
    UIView *toast = [self HPWYSviewForMessage:message title:nil image:image];
    [self HPWYSshowToast:toast duration:duration position:position];
}

- (void)HPWYSmakeToast:(NSString *)message duration:(NSTimeInterval)duration  position:(id)position title:(NSString *)title image:(UIImage *)image {
    UIView *toast = [self HPWYSviewForMessage:message title:title image:image];
    [self HPWYSshowToast:toast duration:duration position:position];
}

- (void)HPWYSshowToast:(UIView *)toast {
    [self HPWYSshowToast:toast duration:HPWYSToastDefaultDuration position:nil];
}


- (void)HPWYSshowToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position {
    [self HPWYSshowToast:toast duration:duration position:position tapCallback:nil];
    
}


- (void)HPWYSshowToast:(UIView *)toast duration:(NSTimeInterval)duration position:(id)position
      tapCallback:(void(^)(void))tapCallback
{
    toast.center = [self HPWYScenterPointForPosition:position withToast:toast];
    toast.alpha = 0.0;
    
    if (HPWYSToastHidesOnTap) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(HPWYShandleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:HPWYSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(HPWYStoastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &HPWYSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         objc_setAssociatedObject (toast, &HPWYSToastTapCallbackKey, tapCallback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
}


- (void)HPWYShideToast:(UIView *)toast {
    [UIView animateWithDuration:HPWYSToastFadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}

#pragma mark - Events

- (void)HPWYStoastTimerDidFinish:(NSTimer *)timer {
    [self HPWYShideToast:(UIView *)timer.userInfo];
}

- (void)HPWYShandleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &HPWYSToastTimerKey);
    [timer invalidate];
    
    void (^callback)(void) = objc_getAssociatedObject(self, &HPWYSToastTapCallbackKey);
    if (callback) {
        callback();
    }
    [self HPWYShideToast:recognizer.view];
}

#pragma mark - Toast Activity Methods

- (void)HPWYSmakeToastActivity {
    [self HPWYSmakeToastActivity:HPWYSToastActivityDefaultPosition];
}

- (void)HPWYSmakeToastActivity:(id)position {
    // sanity
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &HPWYSToastActivityViewKey);
    if (existingActivityView != nil) return;
    
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HPWYSToastActivityWidth, HPWYSToastActivityHeight)];
    activityView.center = [self HPWYScenterPointForPosition:position withToast:activityView];
    activityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:HPWYSToastOpacity];
    activityView.alpha = 0.0;
    activityView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    activityView.layer.cornerRadius = HPWYSToastCornerRadius;
    
    if (HPWYSToastDisplayShadow) {
        activityView.layer.shadowColor = [UIColor blackColor].CGColor;
        activityView.layer.shadowOpacity = HPWYSToastShadowOpacity;
        activityView.layer.shadowRadius = HPWYSToastShadowRadius;
        activityView.layer.shadowOffset = HPWYSToastShadowOffset;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(activityView.bounds.size.width / 2, activityView.bounds.size.height / 2);
    [activityView addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    // associate the activity view with self
    objc_setAssociatedObject (self, &HPWYSToastActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addSubview:activityView];
    
    [UIView animateWithDuration:HPWYSToastFadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         activityView.alpha = 1.0;
                     } completion:nil];
}

- (void)HPWYShideToastActivity {
    UIView *existingActivityView = (UIView *)objc_getAssociatedObject(self, &HPWYSToastActivityViewKey);
    if (existingActivityView != nil) {
        [UIView animateWithDuration:HPWYSToastFadeDuration
                              delay:0.0
                            options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                         animations:^{
                             existingActivityView.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [existingActivityView removeFromSuperview];
                             objc_setAssociatedObject (self, &HPWYSToastActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }];
    }
}

#pragma mark - Helpers

- (CGPoint)HPWYScenterPointForPosition:(id)point withToast:(UIView *)toast {
    if([point isKindOfClass:[NSString class]]) {
        if([point caseInsensitiveCompare:HPWYSToastPositionTop] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width/2, (toast.frame.size.height / 2) + HPWYSToastVerticalPadding);
        } else if([point caseInsensitiveCompare:HPWYSToastPositionCenter] == NSOrderedSame) {
            return CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
        }
    } else if ([point isKindOfClass:[NSValue class]]) {
        return [point CGPointValue];
    }
    
    // default to bottom
    return CGPointMake(self.bounds.size.width/2, (self.bounds.size.height - (toast.frame.size.height / 2)) - HPWYSToastVerticalPadding);
}

- (CGSize)HPWYSsizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
}

- (UIView *)HPWYSviewForMessage:(NSString *)message title:(NSString *)title image:(UIImage *)image {
    // sanity
    if((message == nil) && (title == nil) && (image == nil)) return nil;

    // dynamically build a toast view with any combination of message, title, & image.
    UILabel *messageLabel = nil;
    UILabel *titleLabel = nil;
    UIImageView *imageView = nil;
    
    // create the parent view
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = HPWYSToastCornerRadius;
    
    if (HPWYSToastDisplayShadow) {
        wrapperView.layer.shadowColor = [UIColor blackColor].CGColor;
        wrapperView.layer.shadowOpacity = HPWYSToastShadowOpacity;
        wrapperView.layer.shadowRadius = HPWYSToastShadowRadius;
        wrapperView.layer.shadowOffset = HPWYSToastShadowOffset;
    }

    wrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:HPWYSToastOpacity];
    
    if(image != nil) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(HPWYSToastHorizontalPadding, HPWYSToastVerticalPadding, HPWYSToastImageViewWidth, HPWYSToastImageViewHeight);
    }
    
    CGFloat imageWidth, imageHeight, imageLeft;
    
    // the imageView frame values will be used to size & position the other views
    if(imageView != nil) {
        imageWidth = imageView.bounds.size.width;
        imageHeight = imageView.bounds.size.height;
        imageLeft = HPWYSToastHorizontalPadding;
    } else {
        imageWidth = imageHeight = imageLeft = 0.0;
    }
    
    if (title != nil) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = HPWYSToastMaxTitleLines;
        titleLabel.font = [UIFont boldSystemFontOfSize:HPWYSToastFontSize];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.alpha = 1.0;
        titleLabel.text = title;
        
        // size the title label according to the length of the text
        CGSize maxSizeTitle = CGSizeMake((self.bounds.size.width * HPWYSToastMaxWidth) - imageWidth, self.bounds.size.height * HPWYSToastMaxHeight);
        CGSize expectedSizeTitle = [self HPWYSsizeForString:title font:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(0.0, 0.0, expectedSizeTitle.width, expectedSizeTitle.height);
    }
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = HPWYSToastMaxMessageLines;
        messageLabel.font = [UIFont systemFontOfSize:HPWYSToastFontSize];
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        
        // size the message label according to the length of the text
        CGSize maxSizeMessage = CGSizeMake((self.bounds.size.width * HPWYSToastMaxWidth) - imageWidth, self.bounds.size.height * HPWYSToastMaxHeight);
        CGSize expectedSizeMessage = [self HPWYSsizeForString:message font:messageLabel.font constrainedToSize:maxSizeMessage lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    // titleLabel frame values
    CGFloat titleWidth, titleHeight, titleTop, titleLeft;
    
    if(titleLabel != nil) {
        titleWidth = titleLabel.bounds.size.width;
        titleHeight = titleLabel.bounds.size.height;
        titleTop = HPWYSToastVerticalPadding;
        titleLeft = imageLeft + imageWidth + HPWYSToastHorizontalPadding;
    } else {
        titleWidth = titleHeight = titleTop = titleLeft = 0.0;
    }
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;

    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = imageLeft + imageWidth + HPWYSToastHorizontalPadding;
        messageTop = titleTop + titleHeight + HPWYSToastVerticalPadding;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }

    CGFloat longerWidth = MAX(titleWidth, messageWidth);
    CGFloat longerLeft = MAX(titleLeft, messageLeft);
    
    // wrapper width uses the longerWidth or the image width, whatever is larger. same logic applies to the wrapper height
    CGFloat wrapperWidth = MAX((imageWidth + (HPWYSToastHorizontalPadding * 2)), (longerLeft + longerWidth + HPWYSToastHorizontalPadding));
    CGFloat wrapperHeight = MAX((messageTop + messageHeight + HPWYSToastVerticalPadding), (imageHeight + (HPWYSToastVerticalPadding * 2)));
                         
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    
    if(titleLabel != nil) {
        titleLabel.frame = CGRectMake(titleLeft, titleTop, titleWidth, titleHeight);
        [wrapperView addSubview:titleLabel];
    }
    
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    if(imageView != nil) {
        [wrapperView addSubview:imageView];
    }
        
    return wrapperView;
}

@end
