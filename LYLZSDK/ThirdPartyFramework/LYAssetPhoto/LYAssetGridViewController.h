//
//  LYAssetGridViewController.h
//  TaiYangHua
//
//  Created by Lc on 16/2/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYAsset.h"

//typedef NS_ENUM(NSUInteger,LYPHAuthorizationStatus) {
//    LYPHAuthorizationStatusRestricted   = 1,
//    LYPHAuthorizationStatusDenied       = 2,
//    LYPHAuthorizationStatuAuthorized    = 3,
//};
//
//UIKIT_EXTERN void lyt_getPhotoAuthorizationStatusComplete(void(^complete)(LYPHAuthorizationStatus status));

@class LYAssetGridViewController;
@protocol LYAssetGridViewControllerDelegate <NSObject>

@required
// 点击发送按钮
- (void)assetGridViewController:(LYAssetGridViewController *)assetGridViewController didSenderImages:(NSMutableArray <LYAsset *>*)imageArray;

// 点击关闭按钮
- (void)assetGridViewControllerdidCancel:(LYAssetGridViewController *)assetGridViewController;
@optional
// 最大选择图片数 不实现默认为5
- (NSInteger)maxSelectedCount;
@end


@interface LYAssetGridViewController : UIViewController

/**
 打开照片选择器

 @param delegate 选择器代理
 */
//+ (void)showIamgeSelectorWithDelegate:(id<LYAssetGridViewControllerDelegate>) delegate;
+ (void)showIamgeSelectorWithNavClass:(Class)navClass Delegate:(id<LYAssetGridViewControllerDelegate>) delegate;
@end
