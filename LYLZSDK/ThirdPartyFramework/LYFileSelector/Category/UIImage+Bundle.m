//
//  UIImage+Bundle.m
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/15.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "UIImage+Bundle.h"
#import <objc/message.h>
#import "UIImage+Utility.h"

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

@implementation UIImage (Bundle)


+ (UIImage *)imageWithFileURLString:(NSString *)fileURLString; {
    
    NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
    NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
    NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];
    NSArray *AVArray = [NSArray arrayWithObjects: AV_TYPES count: AV_COUNT];
    
    
    if([textTypesArray containsObject: [fileURLString pathExtension]]){
        
        if (![[fileURLString pathExtension] compare:@"xls" options:NSCaseInsensitiveSearch] || ![[fileURLString pathExtension] compare:@"xlsx" options:NSCaseInsensitiveSearch]) {
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"excel_icon.png"];
        }
        if (![[fileURLString pathExtension] compare:@"pdf" options:NSCaseInsensitiveSearch]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"pdf_icon.png"];
        }
        if (![[fileURLString pathExtension] compare:@"ppt" options:NSCaseInsensitiveSearch]) {
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"ppt_icon.png"];
        }
        if (![[fileURLString pathExtension] compare:@"txt" options:NSCaseInsensitiveSearch]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"txt_icon.png"];
        }
        if (![[fileURLString pathExtension] compare:@"doc" options:NSCaseInsensitiveSearch] || ![[fileURLString pathExtension] compare:@"docx" options:NSCaseInsensitiveSearch]) {
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"word_icon.png"];
        }
    }else if([viceViodeArray containsObject: [fileURLString pathExtension]] || [AVArray containsObject:[fileURLString pathExtension]]){
       
        if ([viceViodeArray containsObject: [fileURLString pathExtension]]) {
            return[UIImage imageFromFileSelectorBunldeWithNamed:@"music_icon.png"];
        }else{
            return [UIImage imageFromFileSelectorBunldeWithNamed:@"video_icon.png"];
        }
    }else if([appViodeArray containsObject: [fileURLString pathExtension]]){
        
        return  [UIImage imageFromFileSelectorBunldeWithNamed: @"unknown_icon.png"];
    }else{
        
        if (![[fileURLString pathExtension] compare:@"rar" options:NSCaseInsensitiveSearch] || ![[fileURLString pathExtension] compare:@"zip" options:NSCaseInsensitiveSearch]) {
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"rar_icon.png"];
        } else if (![[fileURLString pathExtension] compare:@"htlm" options:NSCaseInsensitiveSearch]){
            return  [UIImage imageFromFileSelectorBunldeWithNamed:@"html_icom.png"];
        } else{
            return  [UIImage imageFromFileSelectorBunldeWithNamed: @"unknown_icon.png"];
        }
    }
    return [UIImage imageFromFileSelectorBunldeWithNamed:@"unknown_icon.png"];
}


+ (NSString *)fileSelectorBunldePath {
    
    id bundlePath = objc_getAssociatedObject(self, @"fileSelectorBunldePath");
    
    if (!bundlePath) {
        bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"LYFileSelector.bundle"];
        objc_setAssociatedObject(self, @"fileSelectorBunldePath",bundlePath, OBJC_ASSOCIATION_RETAIN);
    }
    
    return bundlePath;
}




+ (UIImage *)imageNamed:(NSString *)imageName withBundleName:(NSString *)bundleName {
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle bundleWithIdentifier:bundleName] pathForResource:imageName ofType:nil]];
    if (image) {
        return image;
    }
    
    NSString *appendString = ([UIScreen mainScreen].scale == 2) ? @"@2x" : @"@3x";
    
    NSString *extension = [imageName pathExtension];
    
    NSInteger nameLenth = imageName.length - extension.length - 1;
    
    if (extension.length && nameLenth > 0) {
        NSString *imageNamed = [NSString stringWithFormat:@"%@%@.%@",[imageName substringToIndex:nameLenth],appendString,extension];
        
        return [UIImage imageWithContentsOfFile:[[NSBundle bundleWithIdentifier:bundleName] pathForResource:imageNamed ofType:nil]];
    }
    
    return nil;
}

//
//+ (UIImage *)imageFromFileSelectorBunldeWithNamed:(NSString *)imageName {
//    
//    UIImage *image = [UIImage imageWithContentsOfFile:[[self fileSelectorBunldePath] stringByAppendingPathComponent:imageName]];
//    
//    if (!image) {
//        
//        NSString *appendString = ([UIScreen mainScreen].scale == 2) ? @"@2x" : @"@3x";
//        NSString *extension = [imageName pathExtension];
//        NSInteger nameLenth = imageName.length - extension.length - 1;
//        
//        if (extension.length && nameLenth > 0) {
//            NSString *imageNamed = [NSString stringWithFormat:@"%@/%@%@.%@",[self fileSelectorBunldePath],[imageName substringToIndex:nameLenth],appendString,extension];
//            
//            image = [UIImage imageWithContentsOfFile:imageNamed];
//        }
//    }
//    
//    return image;
//}

+ (UIImage *)imageFromFileSelectorBunldeWithNamed:(NSString *)imageName {
    return [self lyt_imageNamed:imageName withBundle:@"LYFileSelector"];
    //    return [self imageNamed:imageName withBundleName:@"LYFileSelector"];
}

+ (UIImage *)lyt_selectorImageNamed:(NSString *)name {
    return [self lyt_imageNamed:name withBundle:@"LYFileSelector"];
}

@end
