//
//  LYAssetGridCell.h
//  TaiYangHua
//
//  Created by Lc on 16/2/15.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^currentSeletedCount)(BOOL);

@class LYAssetGridCell, LYAsset;

@protocol LYAssetGridCellDelegate <NSObject>

@required

- (void)assetGridCell:(LYAssetGridCell *)assetGridCell isSelected:(BOOL)selected isNeedToAdd: (void (^)(BOOL add))add;

@end

@interface LYAssetGridCell : UICollectionViewCell

@property (weak, nonatomic) id<LYAssetGridCellDelegate> delegate;
@property (strong, nonatomic) LYAsset *internalAsset;
//@property (copy, nonatomic) void (^currentSeletedCount)(BOOL add);
@end
