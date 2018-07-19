//
//  NSData+Utility.m
//  LeYingTong
//
//  Created by SYLing on 2017/1/13.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "NSData+Utility.h"
#import "UIImage+Utility.h"
#import "HPWYSWebImageManager.h"

@implementation NSData (Utility)
- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.2;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    
    if (imageData.length/1024.0/1024.0 > 0.2) {
        
        CGSize newSize = CGSizeMake(image.size.width /2.0, image.size.height/2.0);
        UIImage *newImage =  [image resize:newSize];
        
        CGFloat compression = 0.9f;
        CGFloat maxCompression = 0.1f;
        imageData = UIImageJPEGRepresentation(newImage, compression);
        while ([imageData length] > maxFileSize && compression > maxCompression) {
            compression -= 0.2;
            imageData = UIImageJPEGRepresentation(newImage, compression);
        }
    }
    
    return imageData;
    
}

+ (NSData *)imageDataWithURL:(NSString *)imageURL {
    NSData *imageData = nil;
    NSURL *url = [NSURL fileURLWithPath:imageURL];
    if ([imageURL hasPrefix:@"http:"]) {
        url = [NSURL URLWithString:imageURL];
    }

    BOOL isExit = [[HPWYSWebImageManager sharedManager] diskImageExistsForURL:url];
    if (isExit) {
        NSString *cacheImageKey = [[HPWYSWebImageManager sharedManager] cacheKeyForURL:url];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[HPWYSImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    return imageData;
}

@end
