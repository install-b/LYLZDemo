//
//  LYDownFileView.h
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYFileObjModel;
@class LYDownFileView;

@protocol LYDownFileViewDelegate <NSObject>

/**
 下载完成回调

 @param downloadView 下载视图
 @param response 下载失败时候返回nil 
 */
- (void)downFileView:(LYDownFileView *)downloadView didCompleteDownloadFile:(id)response;

/**
 是否允许自动下载当前文件

 @param downloadView 下载视图
 @param currentNet 当前网络环境
 @return YES自动下载  NO不自动下载
 */
- (BOOL)downFileView:(LYDownFileView *)downloadView shouldAutoDownloadFileCurrentNet:(NSInteger)currentNet;

@end

@interface LYDownFileView : UIView
/** 代理 */
@property (nonatomic,weak) id<LYDownFileViewDelegate> delegate;

@property (nonatomic,strong) LYFileObjModel *model;

@end
