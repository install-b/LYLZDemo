//
//  UIImage+Utility.h
//
//  Created by sho yakushiji on 2013/05/17.
//  Copyright (c) 2013年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)


/**
 *  获取图片
 */
+ (UIImage*)fastImageWithData:(NSData*)data;
+ (UIImage*)fastImageWithContentsOfFile:(NSString*)path;
+ (UIImage *)nim_fetchImage:(NSString *)imageNameOrPath;
+ (UIImage *)lyt_imageNamed:(NSString *)name withBundle:(NSString *)bundle;

/**
 * 复制图片
 */
- (UIImage*)deepCopy;


- (UIImage*)crop:(CGRect)rect;
+ (CGSize)nim_sizeWithImageOriginSize:(CGSize)originSize
                              minSize:(CGSize)imageMinSize
                              maxSize:(CGSize)imageMaxSiz;




/**
 * 合成图片
 */
- (UIImage*)maskedImage:(UIImage*)maskImage;



/**
 * 重新设置图片的方向,防止上传到服务器,图片方向错误
 */
- (UIImage *)fixOrientation;



/**
 * 生成纯颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


/**
 *  修改尺寸
 */
- (UIImage*)resize:(CGSize)size;
- (UIImage*)aspectFit:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size;
- (UIImage*)aspectFill:(CGSize)size offset:(CGFloat)offset;



/**
 *  压缩、放大图片
 */
- (instancetype)compressImageWithTargetWidth:(CGFloat)targetWidth;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

/**
 *  圆形拉伸
 */
+ (UIImage *)strechImageWithImageName:(NSString *)imageName;
+ (UIImage *)strechImageWithImageName:(NSString *)imageName leftCap:(CGFloat)leftProgress topCap:(CGFloat)topProgress;




/**
 *  圆形切图
 */
- (UIImage *)roundImage;
- (UIImage *)roundImageWithBorderW:(CGFloat)borderW borderColor:(UIColor *)borderColor;



/**
 *  根据图片名返回一张原始图片
 */
+ (instancetype)originImageWithName:(NSString *)imageName;


/**
 *  将彩色图片转化为灰色图片
 */
- (UIImage *)convertImageToGreyScale;


/**
 * 毛玻璃效果图片
 *
 * blurLevel 模糊程度 0 ≤ t ≤ 1
 */
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

/**
 *  图片加蒙版
 */
- (instancetype)imageWithOverlayColor:(UIColor *)overlayColor;


/**
 *  图片加边框
 */
+ (UIImage *)imageWithBorderW:(CGFloat)borderW borderColor:(UIColor *)borderColor imageName:(NSString *)imageName;
@end
