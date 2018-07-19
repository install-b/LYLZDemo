//
//  NSData+Utility.h
//  LeYingTong
//
//  Created by SYLing on 2017/1/13.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSData (Utility)
- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;
+ (NSData *)imageDataWithURL:(NSString *)imageURL;
@end
