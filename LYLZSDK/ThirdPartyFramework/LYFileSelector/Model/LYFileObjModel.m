//
//  FileObjModel.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "LYFileObjModel.h"
#import "UIImage+Bundle.h"

#define file_B  1
#define file_KB (1024 * file_B)
#define file_MB (1024 * file_KB)
#define file_GB (1024 * file_MB)

static const UInt8 IMAGES_TYPES_COUNT = 8;
static const UInt8 TEXT_TYPES_COUNT = 14;
static const UInt8 VIOCEVIDIO_COUNT = 14;
static const UInt8 Application_count = 4;
static const UInt8 AV_COUNT = 14;

static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};
static const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"txt", @"TXT", @"doc",@"DOC",@"docx",@"DOCX",@"xls",@"XLS", @"xlsx",@"XLSX", @"ppt",@"PPT",@"pdf",@"PDF"};
static const NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT] = {@"mp3",@"MP3",@"wav",@"WAV",@"CD",@"cd",@"ogg",@"OGG",@"midi",@"MIDE",@"vqf",@"VQF",@"amr",@"AMR"};
static const NSString *AV_TYPES[AV_COUNT] = {@"asf",@"ASF",@"wma",@"WMA",@"rm",@"RM",@"rmvb",@"RMVB",@"avi",@"AVI",@"mkv",@"MKV",@"mp4",@"MP4"};
static const NSString *Application_types[Application_count] = {@"apk",@"APK",@"ipa",@"IPA"};


@implementation LYFileObjModel
{
    NSFileManager *fileMgr;
}

-(instancetype)init {
    if(self = [super init]) {
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(instancetype)initWithFilePath:(NSString *)filePath {
    if(self = [self init]){
        self.filePath = filePath;
    }
    return self;
}

-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    self.name = [filePath lastPathComponent];
    
    BOOL isDirectory = true;
    [fileMgr fileExistsAtPath: filePath isDirectory: &isDirectory];
    
    //self.image = [UIImage imageFromFileSelectorBunldeWithNamed: @"fielIcon"];
    self.fileType = MKFileTypeUnknown;
    
    if(isDirectory){
        self.image = [UIImage imageFromFileSelectorBunldeWithNamed: @"dirIcon"];
        self.fileType = MKFileTypeDirectory;
        return;
    }
    
    
    NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
    if([imageTypesArray containsObject: [filePath pathExtension]]){
        self.imagePath = filePath;
        self.fileType = MKFileTypeImage;
    }else {
        self.image =[self fileModelIcon];
    }
    

    NSError *error = nil;
    NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:filePath error:&error];
    
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        if (fileSize) {
            self.fileSize =  [self chanceFileSize:fileSize];
        }
        if (fileModDate) {
            NSTimeInterval a=[fileModDate timeIntervalSince1970]*1000;
            self.creatTime = [NSString stringWithFormat:@"%f", a];
        }
    }
}




- (NSString *)chanceFileSize:(NSNumber *)fileSize {
    
    CGFloat size = [fileSize floatValue];;
    
    self.fileSizefloat = size;
    
    if (size/file_MB > 1) {
        return  [NSString stringWithFormat:@"%.1f MB",size/1.0 / file_MB];
    }
    else if (size/file_KB > 1) {
        return  [NSString stringWithFormat:@"%.1f KB",size/1.0 / file_KB];
    }
    else {
        return  [NSString stringWithFormat:@"%.1f B",size];
    }
    
}


// 图标
- (UIImage *)fileModelIcon {
    
    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];
    
    
    if([textTypesArray containsObject: [self.filePath pathExtension]]){
        self.fileType = MKFileTypeTxt;
        if (![[self.filePath pathExtension] compare:@"xls" options:NSCaseInsensitiveSearch] || ![[self.filePath pathExtension] compare:@"xlsx" options:NSCaseInsensitiveSearch]) {
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"excel_icon.png"];
        }
        if (![[self.filePath pathExtension] compare:@"pdf" options:NSCaseInsensitiveSearch]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"pdf_icon.png"];
        }
        if (![[self.filePath pathExtension] compare:@"ppt" options:NSCaseInsensitiveSearch]) {
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"ppt_icon.png"];
        }
        if (![[self.filePath pathExtension] compare:@"txt" options:NSCaseInsensitiveSearch]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"txt_icon.png"];
        }
        if (![[self.filePath pathExtension] compare:@"doc" options:NSCaseInsensitiveSearch] || ![[self.filePath pathExtension] compare:@"docx" options:NSCaseInsensitiveSearch]) {
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"word_icon.png"];
        }
    }else if([viceViodeArray containsObject: [self.filePath pathExtension]] || [AVArray containsObject:[self.filePath pathExtension]]){
        self.fileType = MKFileTypeAudioVidio;
        if ([viceViodeArray containsObject: [self.filePath pathExtension]]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"music_icon.png"];
        }else{
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"video_icon.png"];
        }
    }else if([appViodeArray containsObject: [self.filePath pathExtension]]){
        self.fileType = MKFileTypeApplication;
        return  [UIImage imageFromFileSelectorBunldeWithNamed: @"unknown_icon.png"];
    }else{
        self.fileType = MKFileTypeUnknown;
        if (![[self.filePath pathExtension] compare:@"rar" options:NSCaseInsensitiveSearch] || ![[self.filePath pathExtension] compare:@"zip" options:NSCaseInsensitiveSearch]) {
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"rar_icon.png"];
        } else if (![[self.filePath pathExtension] compare:@"htlm" options:NSCaseInsensitiveSearch]){
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"html_icom.png"];
        } else{
            return  [UIImage imageFromFileSelectorBunldeWithNamed: @"unknown_icon.png"];
        }
    }
    return [UIImage imageFromFileSelectorBunldeWithNamed:@"unknown_icon.png"];
}

@end
