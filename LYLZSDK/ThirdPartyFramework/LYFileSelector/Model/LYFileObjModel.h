//
//  FileObjModel.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//  文件模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef LYT_FileObjModel_h
#define LYT_FileObjModel_h

typedef NS_ENUM(NSInteger, MKFileType) {
    
    MKFileTypeUnknown = -1, //其他
    
    MKFileTypeAll = 0, //所有

    MKFileTypeImage = 1, //图片
    
    MKFileTypeTxt = 2, //文档
    
    MKFileTypeAudioVidio = 3, //音乐视频
    
    MKFileTypeApplication = 4, //应用
    
    MKFileTypeDirectory = 5, //目录

};
typedef NS_ENUM(NSInteger, FileSendStatu ) {
    FileSendStatuSending = 1,
    FileSendStatuDid = 2,
    FileSendStatuError =3,
};



@interface LYFileObjModel : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath;

//文件路径
@property (copy, nonatomic) NSString *filePath;
//文件URL
@property (copy, nonatomic) NSString *fileUrl;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *fileSize;

@property (nonatomic, assign) CGFloat fileSizefloat;

@property (copy, nonatomic) NSString *creatTime;

//图标
@property (strong, nonatomic) UIImage *image;
//缓存目录图片路径
@property (copy, nonatomic) NSString *imagePath;

@property (assign, nonatomic) MKFileType fileType;
@property (nonatomic,assign) BOOL select;//是否被选中
@property (assign, nonatomic) FileSendStatu send;
@property (nonatomic,assign) BOOL isread;

@property (strong, nonatomic) NSDictionary *attach;


- (NSString *)chanceFileSize:(NSNumber *)fileSize;
// 图标
- (UIImage *)fileModelIcon;
@end
#endif
