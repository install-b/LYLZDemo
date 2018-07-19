//
//  TYHVoiceCacheTool.m
//  TaiYangHua
//
//  Created by Vieene on 16/4/6.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYTVoiceCacheTool.h"
#import "LYTSDK.h"
#import "NSString+LYMessageStr.h"

@interface LYTVoiceCacheTool ()
@end
@implementation LYTVoiceCacheTool
static LYTVoiceCacheTool * tool;
+ (instancetype)shareTools
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[LYTVoiceCacheTool alloc] init];
    });
    
    return tool;
}


- (void)cacheVoiceWithcontentUrl:(NSURL *)contentUrl
                    SuccessBlock:(void (^)(NSURL *cacheUrl))block
                      errorBlock:(void (^)(NSString *error))fail
{

//    NSString *urlStr = [NSString stringWithFormat:@"%@",contentUrl];
//    urlStr =  [urlStr getVoiceCacheUrlstr];
//    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",contentUrl]]];
//    
//    [[[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        return [NSURL fileURLWithPath:urlStr];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        if (block&&filePath) {
//            return block(filePath);
//        }
//        if (error&&fail) {
//            fail(error.description);
//        }
//    }] resume];
}

#pragma mark -- ToolMethod
- (BOOL)searchLocalCache:(NSString *)contentUrl
{
    NSString *urlStr = [NSString stringWithFormat:@"%@",contentUrl];
    urlStr =  [urlStr getVoiceCacheUrlstr];
    if([[NSFileManager defaultManager] fileExistsAtPath:urlStr]){
        return YES;
    }else{
        return NO;
    }
    return YES;
}

- (void)removeCacheWithLocalPath:(NSString *)localPath renamePath:(NSString *)desPath msgModel:(LYTMessage *)model{
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString *MP3FilePath = [documentsDirectory stringByAppendingPathComponent:localPath];
    
    NSString *cafFilePath = [[[localPath componentsSeparatedByString:@"."] firstObject] stringByAppendingString:@".caf"];
    cafFilePath = [documentsDirectory stringByAppendingPathComponent:cafFilePath];
    NSFileManager *mgr = [NSFileManager defaultManager];
    if([mgr fileExistsAtPath:cafFilePath]){
        //删除旧的caf文件
        [mgr removeItemAtPath:cafFilePath error:NULL];
    }
    desPath = [desPath getVoiceCacheUrlstr];
    
    if ([mgr fileExistsAtPath:MP3FilePath]) {
        //重命名新的mp3文件
        [mgr  moveItemAtPath:MP3FilePath toPath:desPath error:NULL];
        [mgr removeItemAtPath:MP3FilePath error:NULL];
    }
    LYTVoiceMessageBody *voiceMessage = (LYTVoiceMessageBody *)model.messageBody;
    voiceMessage.localPath = desPath;
}


+ (NSString *)getVoiceLocalPath:(NSURL *)contentUrl
{
        NSString *urlStr = [NSString stringWithFormat:@"%@",contentUrl];
        if ([urlStr containsString:@"Identifiy"]) {

            return  urlStr;
        }
       __block NSString * filePathstr = [urlStr getVoiceCacheUrlstr];
        if([[LYTVoiceCacheTool shareTools] searchLocalCache:urlStr]){
            return filePathstr;
        }else{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[LYTVoiceCacheTool shareTools] cacheVoiceWithcontentUrl:contentUrl SuccessBlock:^(NSURL *cacheUrl) {
                    filePathstr = [NSString stringWithFormat:@"%@",cacheUrl];                
                } errorBlock:^(NSString *error) {
                }];
            });
            return filePathstr;
        }
}

@end
