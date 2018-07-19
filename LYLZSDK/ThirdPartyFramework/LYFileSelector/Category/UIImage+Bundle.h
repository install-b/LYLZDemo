//
//  UIImage+Bundle.h
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/15.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Bundle)
+ (UIImage *)imageFromFileSelectorBunldeWithNamed:(NSString *)imageName;

+ (UIImage *)imageWithFileURLString:(NSString *)fileURLString;

+ (UIImage *)lyt_selectorImageNamed:(NSString *)name;
@end
