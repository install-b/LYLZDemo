/*
 * This file is part of the HPWYSWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HPWYSWebCache.h"
#import "objc/runtime.h"
#import "UIView+HPWYSWebCacheOperation.h"

static char HPWYSimageURLKey;
static char HPWYSTAG_ACTIVITY_INDICATOR;
static char HPWYSTAG_ACTIVITY_STYLE;
static char HPWYSTAG_ACTIVITY_SHOW;

@implementation UIImageView (HPWYSWebCache)

- (void)hpwys_setImageWithURL:(NSURL *)url {
    [self hpwys_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self hpwys_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options {
    [self hpwys_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setImageWithURL:url placeholderImage:nil options:0 progress:nil completed:completedBlock];
}

- (void)hpwys_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setImageWithURL:url placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
}

- (void)hpwys_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setImageWithURL:url placeholderImage:placeholder options:options progress:nil completed:completedBlock];
}

- (void)hpwys_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options progress:(HPWYSWebImageDownloaderProgressBlock)progressBlock completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &HPWYSimageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    if (!(options & HPWYSWebImageDelayPlaceholder)) {
        dispatch_main_async_safe(^{
            self.image = placeholder;
        });
    }
    
    if (url) {

        // check if activityView is enabled or not
        if ([self showActivityIndicatorView]) {
            [self addActivityIndicator];
        }

        __weak __typeof(self)wself = self;
        id <HPWYSWebImageOperation> operation = [HPWYSWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [wself removeActivityIndicator];
            if (!wself) return;
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && (options & HPWYSWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    if ((options & HPWYSWebImageDelayPlaceholder)) {
                        wself.image = placeholder;
                        [wself setNeedsLayout];
                    }
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self hpwys_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    } else {
        dispatch_main_async_safe(^{
            [self removeActivityIndicator];
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HPWYSWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HPWYSImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hpwys_setImageWithPreviousCachedImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options progress:(HPWYSWebImageDownloaderProgressBlock)progressBlock completed:(HPWYSWebImageCompletionBlock)completedBlock {
    NSString *key = [[HPWYSWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *lastPreviousCachedImage = [[HPWYSImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    
    [self hpwys_setImageWithURL:url placeholderImage:lastPreviousCachedImage ?: placeholder options:options progress:progressBlock completed:completedBlock];
}

- (NSURL *)hpwys_imageURL {
    return objc_getAssociatedObject(self, &HPWYSimageURLKey);
}

- (void)hpwys_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self hpwys_cancelCurrentAnimationImagesLoad];
    __weak __typeof(self)wself = self;

    NSMutableArray *operationsArray = [[NSMutableArray alloc] init];

    for (NSURL *logoImageURL in arrayOfURLs) {
        id <HPWYSWebImageOperation> operation = [HPWYSWebImageManager.sharedManager downloadImageWithURL:logoImageURL options:0 progress:nil completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIImageView *sself = wself;
                [sself stopAnimating];
                if (sself && image) {
                    NSMutableArray *currentImages = [[sself animationImages] mutableCopy];
                    if (!currentImages) {
                        currentImages = [[NSMutableArray alloc] init];
                    }
                    [currentImages addObject:image];

                    sself.animationImages = currentImages;
                    [sself setNeedsLayout];
                }
                [sself startAnimating];
            });
        }];
        [operationsArray addObject:operation];
    }

    [self hpwys_setImageLoadOperation:[NSArray arrayWithArray:operationsArray] forKey:@"UIImageViewAnimationImages"];
}

- (void)hpwys_cancelCurrentImageLoad {
    [self hpwys_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)hpwys_cancelCurrentAnimationImagesLoad {
    [self hpwys_cancelImageLoadOperationWithKey:@"UIImageViewAnimationImages"];
}


#pragma mark -
- (UIActivityIndicatorView *)activityIndicator {
    return (UIActivityIndicatorView *)objc_getAssociatedObject(self, &HPWYSTAG_ACTIVITY_INDICATOR);
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)activityIndicator {
    objc_setAssociatedObject(self, &HPWYSTAG_ACTIVITY_INDICATOR, activityIndicator, OBJC_ASSOCIATION_RETAIN);
}

- (void)setShowActivityIndicatorView:(BOOL)show{
    objc_setAssociatedObject(self, &HPWYSTAG_ACTIVITY_SHOW, [NSNumber numberWithBool:show], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)showActivityIndicatorView{
    return [objc_getAssociatedObject(self, &HPWYSTAG_ACTIVITY_SHOW) boolValue];
}

- (void)setIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    objc_setAssociatedObject(self, &HPWYSTAG_ACTIVITY_STYLE, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (int)getIndicatorStyle{
    return [objc_getAssociatedObject(self, &HPWYSTAG_ACTIVITY_STYLE) intValue];
}

- (void)addActivityIndicator {
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[self getIndicatorStyle]];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;

        dispatch_main_async_safe(^{
            [self addSubview:self.activityIndicator];

            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:0.0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:0.0]];
        });
    }

    dispatch_main_async_safe(^{
        [self.activityIndicator startAnimating];
    });

}

- (void)removeActivityIndicator {
    if (self.activityIndicator) {
        [self.activityIndicator removeFromSuperview];
        self.activityIndicator = nil;
    }
}

@end
