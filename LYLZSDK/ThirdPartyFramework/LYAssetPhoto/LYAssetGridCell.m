//
//  LYAssetGridCell.m
//  TaiYangHua
//
//  Created by Lc on 16/2/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAssetGridCell.h"
#import <Photos/Photos.h>
#import "UIImageView+AssetImage.h"

#import "LYAsset.h"
#import "HPWYsonry.h"
#import "UIImage+Bundle.h"
@interface LYAssetGridCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *selectedButton;
@end

@implementation LYAssetGridCell

#pragma mark - lazy

- (UIButton *)selectedButton
{
    if (!_selectedButton) {
        UIButton *selectedButton = [[UIButton alloc] init];
        [selectedButton setImage:[UIImage lyt_selectorImageNamed:@"file_unselected"] forState:UIControlStateNormal];
        [selectedButton setImage:[UIImage lyt_selectorImageNamed:@"file_selected"] forState:UIControlStateSelected];
        [selectedButton addTarget:self action:@selector(clickSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
        _selectedButton = selectedButton;
        [self.contentView addSubview:_selectedButton];
    }
    
    return _selectedButton;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        _imageView = imageView;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self selectedButton];
    }
    
    return self;
}

- (void)setInternalAsset:(LYAsset *)internalAsset
{
    _internalAsset = internalAsset;
    
    [self.imageView setImageWithAsset:internalAsset.asset targetSize:self.bounds.size];
    
    self.selectedButton.selected = internalAsset.isSelected;
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//    options.synchronous = YES;
//    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
//    
//    [[PHImageManager defaultManager] requestImageForAsset:internalAsset.asset targetSize:internalAsset.assetGridThumbnailSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
//        self.imageView.image = image;
//        self.selectedButton.selected = internalAsset.isSelected;
//    }];
//    
    
//    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
//    option.resizeMode = PHImageRequestOptionsResizeModeFast;
//    
//     __block UIImage *image;
//    
//    [[PHImageManager defaultManager] requestImageForAsset:internalAsset.asset targetSize:self.bounds.size contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage *result, NSDictionary *info) {
//        self.imageView.image =result;
//        if (result) {
//            image = result;
//        }
//        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
//        if (downloadFinined && result) {
//            result = [self fixOrientation:result];
//            self.imageView.image = result;
//            //if (completion) completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
//        }
//        // Download image from iCloud / 从iCloud下载图片
//        if ([info objectForKey:PHImageResultIsInCloudKey] && !result ) {
//            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
////            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    if (progressHandler) {
////                        progressHandler(progress, error, stop, info);
////                    }
////                });
////            };
//            options.networkAccessAllowed = YES;
//            options.resizeMode = PHImageRequestOptionsResizeModeFast;
//            [[PHImageManager defaultManager] requestImageDataForAsset:internalAsset.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
//                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
//                resultImage = [self scaleImage:resultImage toSize:self.bounds.size];
//                if (!resultImage) {
//                    resultImage = image;
//                }
//                resultImage = [self fixOrientation:resultImage];
//                self.imageView.image = resultImage;
//                //if (completion) completion(resultImage,info,NO);
//            }];
//        }
//    }];

}
//
//- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
//    if (image.size.width > size.width) {
//        UIGraphicsBeginImageContext(size);
//        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return newImage;
//    } else {
//        return image;
//    }
//}
///// 修正图片转向
//- (UIImage *)fixOrientation:(UIImage *)aImage {
//    //if (!self.shouldFixOrientation) return aImage;
//    
//    // No-op if the orientation is already correct
//    if (aImage.imageOrientation == UIImageOrientationUp)
//        return aImage;
//    
//    // We need to calculate the proper transformation to make the image upright.
//    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationDown:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, M_PI);
//            break;
//            
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformRotate(transform, M_PI_2);
//            break;
//            
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
//            transform = CGAffineTransformRotate(transform, -M_PI_2);
//            break;
//        default:
//            break;
//    }
//    
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationUpMirrored:
//        case UIImageOrientationDownMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//            
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRightMirrored:
//            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
//            transform = CGAffineTransformScale(transform, -1, 1);
//            break;
//        default:
//            break;
//    }
//    
//    // Now we draw the underlying CGImage into a new context, applying the transform
//    // calculated above.
//    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
//                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
//                                             CGImageGetColorSpace(aImage.CGImage),
//                                             CGImageGetBitmapInfo(aImage.CGImage));
//    CGContextConcatCTM(ctx, transform);
//    switch (aImage.imageOrientation) {
//        case UIImageOrientationLeft:
//        case UIImageOrientationLeftMirrored:
//        case UIImageOrientationRight:
//        case UIImageOrientationRightMirrored:
//            // Grr...
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
//            break;
//            
//        default:
//            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
//            break;
//    }
//    
//    // And now we just create a new UIImage from the drawing context
//    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
//    UIImage *img = [UIImage imageWithCGImage:cgimg];
//    CGContextRelease(ctx);
//    CGImageRelease(cgimg);
//    return img;
//}
//

- (void)clickSelectedButton:(UIButton *)selectedButton
{
    if ([self.delegate respondsToSelector:@selector(assetGridCell:isSelected:isNeedToAdd:)]) {
        [self.delegate assetGridCell:self isSelected:!selectedButton.isSelected isNeedToAdd:^(BOOL add) {
            if (add) {
                [self shakeToShow:selectedButton];
                selectedButton.selected = !selectedButton.isSelected;
                self.internalAsset.selected = selectedButton.isSelected;
            }
        }];
    }
}

- (void)shakeToShow:(UIButton*)button
{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [button.layer addAnimation:animation forKey:nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.selectedButton hpwys_makeConstraints:^(HPWYSConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
        make.right.equalTo(self.contentView).offset(-3);
        make.size.equalTo(@(30));
    }];
}

@end
