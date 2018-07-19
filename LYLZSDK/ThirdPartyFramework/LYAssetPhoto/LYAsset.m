//
//  LYAsset.m
//  TaiYangHua
//
//  Created by Lc on 16/2/19.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYAsset.h"

@implementation LYAsset

+ (instancetype)internalAssetWith:(PHAsset *)asset
{
    LYAsset *internalAsset = [[LYAsset alloc] init];
    internalAsset.asset = asset;
    internalAsset.selected = NO;
    return internalAsset;
}

- (NSString *)bytes
{
    if (!_bytes ){ // 计算一次
    if (self.dataLength >= 0.1 * (1024 * 1024)) {
        _bytes = [NSString stringWithFormat:@"%0.1fM",self.dataLength/1024/1024.0];
    } else if (self.dataLength >= 1024) {
        _bytes = [NSString stringWithFormat:@"%0.0fK",self.dataLength/1024.0];
    } else {
        _bytes = [NSString stringWithFormat:@"%zdB",self.dataLength];
    }
    }
    return _bytes;
}

- (NSInteger)dataLength
{
    if (!_dataLength) {
        __block NSInteger dataLength = 0;
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            dataLength = imageData.length;
        }];
        
        _dataLength = dataLength;
    }
    
    return _dataLength;
}
@end
