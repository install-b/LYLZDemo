//
//  LYAssetGridToolBar.h
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYAssetGridToolBar;

@protocol LYAssetGridToolBarDelegate <NSObject>

@required

- (void)didClickPreviewInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar;
- (void)didClickSenderButtonInAssetGridToolBar:(LYAssetGridToolBar *)assetGridToolBar;

@end

@interface LYAssetGridToolBar : UIView

@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (weak, nonatomic) id<LYAssetGridToolBarDelegate> delegate;

@end
