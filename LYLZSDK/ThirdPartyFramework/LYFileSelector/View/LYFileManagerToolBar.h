//
//  TYHInternalAssetGridToolBar.h
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYFileManagerToolBar;

@protocol LYFileManagerToolBarDelegate <NSObject>

@required

- (void)didClickPreviewInAssetGridToolBar:(LYFileManagerToolBar *)internalAssetGridToolBar;
- (void)didClickSenderButtonInAssetGridToolBar:(LYFileManagerToolBar *)internalAssetGridToolBar;

@end


@interface LYFileManagerToolBar : UIView

@property (strong, nonatomic) NSMutableArray *selectedItems;

@property (weak, nonatomic) id<LYFileManagerToolBarDelegate> delegate;

@end
