/*
 * This file is part of the HPWYSWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HPWYSHighlightedWebCache.h"
#import "UIView+HPWYSWebCacheOperation.h"

#define UIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (HPWYSHighlightedWebCache)

- (void)hpwys_setHighlightedImageWithURL:(NSURL *)url {
    [self hpwys_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)hpwys_setHighlightedImageWithURL:(NSURL *)url options:(HPWYSWebImageOptions)options {
    [self hpwys_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)hpwys_setHighlightedImageWithURL:(NSURL *)url completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)hpwys_setHighlightedImageWithURL:(NSURL *)url options:(HPWYSWebImageOptions)options completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)hpwys_setHighlightedImageWithURL:(NSURL *)url options:(HPWYSWebImageOptions)options progress:(HPWYSWebImageDownloaderProgressBlock)progressBlock completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<HPWYSWebImageOperation> operation = [HPWYSWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image && (options & HPWYSWebImageAvoidAutoSetImage) && completedBlock)
                                         {
                                             completedBlock(image, error, cacheType, url);
                                             return;
                                         }
                                         else if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self hpwys_setImageLoadOperation:operation forKey:UIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HPWYSWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HPWYSImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hpwys_cancelCurrentHighlightedImageLoad {
    [self hpwys_cancelImageLoadOperationWithKey:UIImageViewHighlightedWebCacheOperationKey];
}

@end

