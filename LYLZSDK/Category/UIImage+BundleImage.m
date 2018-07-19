//
//  UIImage+BundleImage.m
//  LZSDKDemo
//
//  Created by Shangen Zhang on 2017/8/4.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "UIImage+BundleImage.h"
#import "UIImage+Utility.h"

@implementation UIImage (BundleImage)


+ (UIImage *)lyt_emotionImageNamed:(NSString *)name {
    return [self lyt_imageNamed:name withBundle:@"ClippedExpression"];
}

+ (UIImage *)lyt_chatImageNamed:(NSString *)name {
    return [self lyt_imageNamed:name withBundle:@"LYTchatViewIcon"];
}


@end
