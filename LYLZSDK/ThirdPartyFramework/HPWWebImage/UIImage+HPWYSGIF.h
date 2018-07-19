//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HPWYSGIF)

+ (UIImage *)hpwys_animatedGIFNamed:(NSString *)name;

+ (UIImage *)hpwys_animatedGIFWithData:(NSData *)data;

- (UIImage *)hpwys_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
