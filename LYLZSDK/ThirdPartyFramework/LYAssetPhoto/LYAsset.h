//
//  LYAsset.h
//  TaiYangHua
//
//  Created by Lc on 16/2/19.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface LYAsset : NSObject
@property (strong, nonatomic) PHAsset *asset;
@property (assign, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic) CGSize assetGridThumbnailSize;
@property (assign, nonatomic) NSInteger dataLength;
@property (copy, nonatomic) NSString *bytes;

+ (instancetype)internalAssetWith:(PHAsset *)asset;

@end
