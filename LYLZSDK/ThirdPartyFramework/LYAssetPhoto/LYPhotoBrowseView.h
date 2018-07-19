//
//  CJPhotoBrowseView.h
//  weChat
//
//  Created by Lc on 16/3/30.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LYPhotoBrowsePotoProtocol;
@interface LYPhotoBrowseView : UIView
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray <LYPhotoBrowsePotoProtocol> *datasource;
@property (nonatomic, weak) UIButton *saveButton;

@property (strong, nonatomic) id<LYPhotoBrowsePotoProtocol> message;

- (void)showWithView:(UIImageView *)imageView;

@property (weak, nonatomic) UICollectionView *collectionView;

@end




@protocol LYPhotoBrowsePotoProtocol <NSObject>

- (NSString *)picUrl;

- (NSString *)localPath;
@end
