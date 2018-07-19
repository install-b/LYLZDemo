//
//  NSString+LYMessageStr.h
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYTMessage;
@interface NSString (LYMessageStr)
/**
 *  model wds字符装换
 */
- (NSString *)strSwitchFromJsonStr;

/** 返回本地图片 */
+ (NSString *)iamgeCachesPathWithImageName:(NSString *)imageName;

/** 返回录音文件本地路径 */
+ (NSString *)recordFileNameWithFileURL:(NSString *)fileURL;

/** 重新命名本地录音文件 */
- (NSString *)renameRecordFileNameWithFileURL:(NSString *)fileURL;

/**  生成表情 字符串 */
- (NSAttributedString *)emotionStringWithWH:(CGFloat)WH;

/** 聊天界面 显示的时间cell */
- (NSString *)timeString;

/*&#x1F602--->\U0001F602*/
- (NSString *)stringByReplacingEmojiCheatCodesToUnicode;

/*\U0001F602--->&#x1F602*/
- (NSString *)stringByReplacingEmojiUnicodeToCheatCodes;

- (NSString *)substrTo:(NSInteger)to;

- (NSString *)getVoiceCacheUrlstr;

- (NSString *)imagefileName;

/**
 *  计算文本文字的矩形尺寸
 *
 *  @param font    文本文字的字体
 *  @param maxSize 定义它的最大尺寸，当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
 *
 *  @return 根据文本文字的字体以及最大限制尺寸返回计算好的文本文字的矩形尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize;
// 计算文本文字的高度
- (CGFloat)heightWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth;

// 文字转拼音
- (NSString *)pinyinStringOfChinese;

@property (nonatomic, readonly) NSString *md5String;
@property (nonatomic, readonly) NSString *sha1String;
@property (nonatomic, readonly) NSString *sha256String;
@property (nonatomic, readonly) NSString *sha512String;
//获取文件的md5
+(NSString *)getFileMD5WithPath:(NSString *)filePath;
//给文件命名
+(NSString *)renamePhotoFile;
/**
 *
 *  @brief  毫秒时间戳 例如 1443066826371
 *
 *  @return 毫秒时间戳
 */
+ (NSString *)UUIDTimestamp;

@end
