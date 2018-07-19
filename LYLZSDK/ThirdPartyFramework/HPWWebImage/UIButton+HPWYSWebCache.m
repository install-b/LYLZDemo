/*
 * This file is part of the HPWYSWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIButton+HPWYSWebCache.h"
#import "objc/runtime.h"
#import "UIView+HPWYSWebCacheOperation.h"

static char HPWYSimageURLStorageKey;

@implementation UIButton (HPWYSWebCache)

- (NSURL *)hpwys_currentImageURL {
    NSURL *url = self.imageURLStorage[@(self.state)];

    if (!url) {
        url = self.imageURLStorage[@(UIControlStateNormal)];
    }

    return url;
}

- (NSURL *)hpwys_imageURLForState:(UIControlState)state {
    return self.imageURLStorage[@(state)];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hpwys_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hpwys_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options {
    [self hpwys_setImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)hpwys_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options completed:(HPWYSWebImageCompletionBlock)completedBlock {

    [self setImage:placeholder forState:state];
    [self hpwys_cancelImageLoadForState:state];
    
    if (!url) {
        [self.imageURLStorage removeObjectForKey:@(state)];
        
        dispatch_main_async_safe(^{
            if (completedBlock) {
                NSError *error = [NSError errorWithDomain:HPWYSWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                completedBlock(nil, error, HPWYSImageCacheTypeNone, url);
            }
        });
        
        return;
    }
    
    self.imageURLStorage[@(state)] = url;

    __weak __typeof(self)wself = self;
    id <HPWYSWebImageOperation> operation = [HPWYSWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!wself) return;
        dispatch_main_sync_safe(^{
            __strong UIButton *sself = wself;
            if (!sself) return;
            if (image && (options & HPWYSWebImageAvoidAutoSetImage) && completedBlock)
            {
                completedBlock(image, error, cacheType, url);
                return;
            }
            else if (image) {
                [sself setImage:image forState:state];
            }
            if (completedBlock && finished) {
                completedBlock(image, error, cacheType, url);
            }
        });
    }];
    [self hpwys_setImageLoadOperation:operation forState:state];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state {
    [self hpwys_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:nil];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    [self hpwys_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:nil];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options {
    [self hpwys_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:options completed:nil];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setBackgroundImageWithURL:url forState:state placeholderImage:nil options:0 completed:completedBlock];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)hpwys_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(HPWYSWebImageOptions)options completed:(HPWYSWebImageCompletionBlock)completedBlock {
    [self hpwys_cancelBackgroundImageLoadForState:state];

    [self setBackgroundImage:placeholder forState:state];

    if (url) {
        __weak __typeof(self)wself = self;
        id <HPWYSWebImageOperation> operation = [HPWYSWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, HPWYSImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image && (options & HPWYSWebImageAvoidAutoSetImage) && completedBlock)
                {
                    completedBlock(image, error, cacheType, url);
                    return;
                }
                else if (image) {
                    [sself setBackgroundImage:image forState:state];
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self hpwys_setBackgroundImageLoadOperation:operation forState:state];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:HPWYSWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, HPWYSImageCacheTypeNone, url);
            }
        });
    }
}

- (void)hpwys_setImageLoadOperation:(id<HPWYSWebImageOperation>)operation forState:(UIControlState)state {
    [self hpwys_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)hpwys_cancelImageLoadForState:(UIControlState)state {
    [self hpwys_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonImageOperation%@", @(state)]];
}

- (void)hpwys_setBackgroundImageLoadOperation:(id<HPWYSWebImageOperation>)operation forState:(UIControlState)state {
    [self hpwys_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (void)hpwys_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self hpwys_cancelImageLoadOperationWithKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(state)]];
}

- (NSMutableDictionary *)imageURLStorage {
    NSMutableDictionary *storage = objc_getAssociatedObject(self, &HPWYSimageURLStorageKey);
    if (!storage)
    {
        storage = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, &HPWYSimageURLStorageKey, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return storage;
}

@end
