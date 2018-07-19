//
//  LYAssetViewController.h
//  TaiYangHua
//
//  Created by Lc on 16/2/16.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//  照片选择器（预览照片模式）

#import <UIKit/UIKit.h>


@class LYAssetViewController;

@protocol LYAssetViewControllerDelegate <NSObject>

@required
// 点击返回后执行
- (void)AssetViewController:(LYAssetViewController *)AssetViewController selectedItemsInAssetViewController:(NSMutableArray *)selectedItems;

// 点击发送按钮
- (void)AssetViewController:(LYAssetViewController *)AssetViewController didClickSenderButton:(NSMutableArray *)selectedItems;

// 最大选择图片数 不实现默认为5
- (NSInteger)maxSelectedCount;

@end


@interface LYAssetViewController : UIViewController

/**
 *  显示第一张图片的索引
 */
@property (assign, nonatomic) NSInteger index;

/**
 *  显示图片的数组
 */
@property (strong, nonatomic) NSMutableArray *assetArray;

/**
 *  选中图片的数组
 */
@property (strong, nonatomic) NSMutableArray *selectedItems;


@property (weak, nonatomic) id<LYAssetViewControllerDelegate> delegate;

@end
