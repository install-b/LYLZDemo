//
//  TYHVoiceCacheTool.h
//  TaiYangHua
//
//  Created by Vieene on 16/4/6.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LYTMessage;

@interface LYTVoiceCacheTool : NSObject

+ (instancetype)shareTools;

/**
 *  保存音频文件到本地
 *
 *  @param contentUrl 音频的网络URL
 *  @param block      返回音频的本地URL
 */
- (void)cacheVoiceWithcontentUrl:(NSURL *)contentUrl SuccessBlock:(void (^)(NSURL *cacheUrl))block
                      errorBlock:(void (^)(NSString *error))fail;

/**
 *  检查路径中是否有保存该文件
 */
- (BOOL)searchLocalCache:(NSString *)contentUrl;
/**
 *  更新本地的录音缓存库（删除caf，移动到cache，删除原mp3文件）
 *  @param localPath 本地保存的mp3文件
 *  @param desPath   上传成功后网络返回的URl
 */
- (void)removeCacheWithLocalPath:(NSString *)localPath renamePath:(NSString *)desPath msgModel:(LYTMessage *)model;

/**
 *  通过conteUrl 获取录音的本地路径
 */
+ (NSString *)getVoiceLocalPath:(NSURL *)contentUrl;
@end
