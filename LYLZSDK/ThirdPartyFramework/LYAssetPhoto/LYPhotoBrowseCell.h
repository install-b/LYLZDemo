//
//  CJPhotoBrowseCell.h
//  weChat
//
//  Created by Lc on 16/3/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  LYPhotoBrowseCell;
@protocol LYPhotoBrowseCellDelegate <NSObject>

@required
- (void)photoBrowseCellEndZooming:(LYPhotoBrowseCell *)photoBrowseCell;

@end


@protocol LYPhotoBrowsePotoProtocol;
@interface LYPhotoBrowseCell : UICollectionViewCell
@property (strong, nonatomic) id <LYPhotoBrowsePotoProtocol>message;
@property (weak, nonatomic) id<LYPhotoBrowseCellDelegate> delegate;
@property (weak, nonatomic) UIImageView *defaultImageView;
@end
