
//
//  LYRefreshHeader.m
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "LYRefreshHeader.h"
#import "UIImage+BundleImage.h"

@implementation LYRefreshHeader

- (void)prepare {
    [super prepare];
    
    
    NSMutableArray *idleImages = [NSMutableArray array];
    UIImage *image = [UIImage lyt_chatImageNamed:@"下拉箭头"];
    !image ?: [idleImages addObject:image];
    [self setImages:idleImages forState:LYCOMRefreshStateIdle];
    
    
    NSMutableArray *pullingImages = [NSMutableArray array];
    UIImage *imageP = [UIImage lyt_chatImageNamed:@"向上箭头"];
    !imageP ?: [pullingImages addObject:imageP];
    [self setImages:pullingImages forState:LYCOMRefreshStatePulling];
    
    
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 8; i++) {
        UIImage *image = [UIImage lyt_chatImageNamed:[NSString stringWithFormat:@"刷新-%zd", i + (i * 1)]];
        !image ?: [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:LYCOMRefreshStateRefreshing];
    
    
    [self setTitle:@"下拉刷新" forState:LYCOMRefreshStateIdle];
    [self setTitle:@"松开加载更多" forState:LYCOMRefreshStatePulling];
    [self setTitle:@"正在加载..." forState:LYCOMRefreshStateRefreshing];
    
    self.stateLabel.font = [UIFont systemFontOfSize:15];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    self.stateLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
    self.lastUpdatedTimeLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
}

@end
