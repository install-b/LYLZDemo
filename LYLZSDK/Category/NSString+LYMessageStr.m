//
//  NSString+LYMessageStr.m
//  LYLink
//
//  Created by SYLing on 2016/12/7.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "NSString+LYMessageStr.h"
#import "LYTextAttachment.h"
#import "LYEmojiDic.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSObject+SGExtention.h"


#define FileHashDefaultChunkSizeForReadingData 1024*8

static NSDictionary * s_unicodeToCheatCodes = nil;
static NSDictionary * s_cheatCodesToUnicode = nil;

@implementation NSString (LYMessageStr)

// model wds字符装换
- (NSString *)strSwitchFromJsonStr
{
    if (self == nil) {
        return @"";
    }
    /*
     self	__NSCFString *	@"{\n\twds : [\n\tqwf\n]\n}"	0x0000608000267040
     self	__NSCFString *	@"{\n\twds : [\n\twfq\n]\n}"	0x000060000046c740
     self	__NSCFString *	@"{\"wds\":[\"Tg dfh\"]}"	0x0000600000266fc0
     */
    NSString * newString = [self stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSData* jsonData = [newString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (json == nil) {
        return newString;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if ([[json allKeys] containsObject:@"wds"]) {
        NSString *jsonstr = json[@"wds"];
        
        NSError *error = nil;
        id strArray = [NSJSONSerialization JSONObjectWithData:[jsonstr sg_JSONData] options:kNilOptions error:&error];
        
        if ([strArray isKindOfClass:[NSDictionary class]]) {
            strArray = strArray[@"wds"];
        }
        
        if (error && ![strArray isKindOfClass:[NSArray class]]) {
            return (NSString *)strArray;
        }
        
        if ([(NSArray *)strArray count] == 0) {
            return @"";
        }
        [str appendString:strArray[0]];
        for (int i = 1; i<[(NSArray *)strArray count]; i ++) {
            [str appendString:@"\n"];
            [str appendString:strArray[i]];
        }
    }else if ([[json allKeys] containsObject:@"content"] ) {
        
        NSArray *strArray = json[@"content"];
        if (![strArray isKindOfClass:[NSArray class]]) {
            return (NSString *)strArray;
        }
        if (strArray.count == 0) {
            return @"";
        }
        [str appendString:strArray[0]];
        for (int i = 1; i<strArray.count; i ++) {
            [str appendString:@"\n"];
            [str appendString:strArray[i]];
        }
        
    }else{
        if ([[json allKeys] containsObject:@"fileName"]) {
            str = [NSMutableString stringWithFormat:@"%@",@"暂不支持此类型"];
        }
        if ([[json allKeys] containsObject:@"flag"]) {
            [str appendString:self];
        }
    }
    return str;
    
}

// 返回本地图片
+ (NSString *)iamgeCachesPathWithImageName:(NSString *)imageName
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    cachesPath = [NSString stringWithFormat:@"%@/senderOriginalImages/",cachesPath];
    cachesPath = [cachesPath stringByAppendingPathComponent:imageName];
    if(![[NSFileManager defaultManager] fileExistsAtPath:[cachesPath stringByDeletingLastPathComponent]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[cachesPath stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return cachesPath;
}

// 返回录音文件本地路径
+ (NSString *)recordFileNameWithFileURL:(NSString *)fileURL
{
    NSString *recordPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    recordPath = [NSString stringWithFormat:@"%@/records/",recordPath];
    NSString *lastPathExtension = [NSString stringWithFormat:@"%@.mp3", [fileURL md5String]];
    recordPath = [recordPath stringByAppendingPathComponent:lastPathExtension];
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:[recordPath stringByDeletingLastPathComponent]]){
        [fm createDirectoryAtPath:[recordPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return recordPath;
}

// 重新命名本地录音文件
- (NSString *)renameRecordFileNameWithFileURL:(NSString *)fileURL
{
    NSString *oldRecordName = self;
    NSString *lastPathExtension = [NSString stringWithFormat:@"%@.mp3", [fileURL md5String]];
    NSString *newRecordName = [[self stringByDeletingLastPathComponent] stringByAppendingPathComponent:lastPathExtension];
    [[NSFileManager defaultManager] moveItemAtPath:oldRecordName toPath:newRecordName error:nil];
    
    return newRecordName;
}

// 生成表情 字符串
- (NSAttributedString *)emotionStringWithWH:(CGFloat)WH
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"emotions" ofType:@"plist"];
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSArray *arr in [[NSArray alloc] initWithContentsOfFile:path]) {
        for (NSDictionary *dict in arr) {
            LYEmotion *emotion = [LYEmotion emotionWithDict:dict];
            [emotions addObject:emotion];
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    NSString * pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    for(NSTextCheckingResult *match in resultArray) {
        NSRange range = [match range];
        NSString *subStr = [self substringWithRange:range];
        
        for (int i = 0; i < emotions.count; i ++)
        {
            LYEmotion *emotion = emotions[i];
            if ([emotion.chs isEqualToString:subStr])
            {
                LYTextAttachment *textAttachment = [[LYTextAttachment alloc] init];
                textAttachment.bounds = CGRectMake(0, -4, WH, WH);
                textAttachment.emotion = emotion;
                
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    for (NSInteger i = imageArray.count -1; i >= 0; i--)
    {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        
    }
    
    return attributeString;
    
}

// 聊天界面 显示的时间cell
- (NSString *)timeString
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    
    NSDate *messageDate = [NSDate dateWithTimeIntervalSince1970:[self longLongValue] / 1000];
    NSDateComponents * messageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:messageDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *yestoday = nil;
    
    if (currentComponents.year == messageComponents.year
        && currentComponents.month == messageComponents.month
        && currentComponents.day == messageComponents.day) {
        
        dateFormatter.dateFormat= @"HH:mm";
        
    }else if(currentComponents.year == messageComponents.year
             && currentComponents.month == messageComponents.month
             && currentComponents.day - 1 == messageComponents.day){
        yestoday = @"昨天";
        dateFormatter.dateFormat= [NSString stringWithFormat:@"HH:mm"];
    }else{
        
        dateFormatter.dateFormat= @"yyy-MM-dd HH:mm";
    }
    
    NSString *dateString = [dateFormatter stringFromDate:messageDate];
    return yestoday?[yestoday stringByAppendingFormat:@" %@", dateString]:dateString;
}

//&#x1f602 ----->\U0001F604
- (NSString *)stringByReplacingEmojiCheatCodesToUnicode
{
    if (!s_cheatCodesToUnicode) {
        [NSString initializeEmojiCheatCodes];
    }
    
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [s_cheatCodesToUnicode enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}

//\U0001F604  -----> &#x1F602
- (NSString *)stringByReplacingEmojiUnicodeToCheatCodes
{
    if (!s_cheatCodesToUnicode) {
        [NSString initializeEmojiCheatCodes];
    }
    
    if (self.length) {
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [s_unicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *string = ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj);
            [newText replaceOccurrencesOfString:key withString:string options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
        }];
        return newText;
    }
    return self;
}
+ (void)initializeEmojiCheatCodes
{
    NSDictionary * forwardMap = EMOJI_ChangeText;
    __block NSMutableDictionary *reversedMap = [NSMutableDictionary dictionaryWithCapacity:[forwardMap count]];
    [forwardMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            for (NSString *object in obj) {
                [reversedMap setObject:key forKey:object];
            }
        }else{
            [reversedMap setObject:key forKey:obj];
        }
    }];
    @synchronized(self) {
        s_unicodeToCheatCodes = forwardMap;
        s_cheatCodesToUnicode = [reversedMap copy];
    }
}

- (NSString *)substrTo:(NSInteger)to
{
    if (self.length > to) {
        return [[self substringToIndex:to] stringByAppendingString:@"..."];
    }
    return self;
}

- (NSString *)getVoiceCacheUrlstr
{
    //Caches:
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSArray *strArray = [self componentsSeparatedByString:@"/"];
    NSMutableString *localPathstr = [strArray lastObject];
    return [documentsDirectory stringByAppendingPathComponent:localPathstr];
}
- (NSString *)imagefileName
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    return [NSString stringWithFormat:@"img_%@%@",[dateFormater stringFromDate:now],self];
}

- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    //传入一个字体（大小号）保存到字典
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGFloat)heightWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth {
    
    return [self sizeWithFont:font MaxSize:CGSizeMake(maxWidth, HUGE)].height;
    
}

- (NSString *)pinyinStringOfChinese
{
    //  kCFStringTransformMandarinLatin:带音标字母
    //  kCFStringTransformStripDiacritics: 添加这步可以变为不带音标的拼音
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)self);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    return (__bridge NSString *)string;
}
- (NSString *)md5String
{
    const char *str = self.UTF8String;
    int length = (int)strlen(str);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, length, bytes);
    
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)sha1String
{
    const char *str = self.UTF8String;
    int length = (int)strlen(str);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(str, length, bytes);
    
    return [self stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)sha256String
{
    const char *str = self.UTF8String;
    int length = (int)strlen(str);
    unsigned char bytes[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, length, bytes);
    
    return [self stringFromBytes:bytes length:CC_SHA256_DIGEST_LENGTH];
}

- (NSString *)sha512String
{
    const char *str = self.UTF8String;
    int length = (int)strlen(str);
    unsigned char bytes[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(str, length, bytes);
    
    return [self stringFromBytes:bytes length:CC_SHA512_DIGEST_LENGTH];
}

- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *strM = [NSMutableString string];
    
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    
    return [strM copy];
}

+ (NSString *)renamePhotoFile
{
    return [NSString stringWithFormat:@"%@%d.jpg",@"图片文件",arc4random() % 1000];
}
+(NSString*)getFileMD5WithPath:(NSString*)path
{
    NSAssert(path, @"getFileMD5WithPath error");
    return (__bridge_transfer NSString *)LYFileMD5HashCreateWithPath((__bridge CFStringRef)path,FileHashDefaultChunkSizeForReadingData);
}
CFStringRef LYFileMD5HashCreateWithPath(CFStringRef filePath,size_t chunkSizeForReadingData) {
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    if (!fileURL) goto done;
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    
    if (!readStream) goto done;
    bool didSucceed = (bool)CFReadStreamOpen(readStream);
    if (!didSucceed) goto done;
    // Initialize the hash object
    CC_MD5_CTX hashObject;
    CC_MD5_Init(&hashObject);
    // Make sure chunkSizeForReadingData is valid
    if (!chunkSizeForReadingData) {
        chunkSizeForReadingData = FileHashDefaultChunkSizeForReadingData;
    }
    
    // Feed the data to the hash object
    
    bool hasMoreData = true;
    
    while (hasMoreData) {
        
        uint8_t buffer[chunkSizeForReadingData];
        
        CFIndex readBytesCount = CFReadStreamRead(readStream,(UInt8 *)buffer,(CFIndex)sizeof(buffer));
        
        if (readBytesCount == -1) break;
        
        if (readBytesCount == 0) {
            
            hasMoreData = false;
            
            continue;
            
        }
        
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
        
    }
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    
    if (!didSucceed) goto done;
    
    // Compute the string result
    
    char hash[2 * sizeof(digest) + 1];
    
    for (size_t i = 0; i < sizeof(digest); ++i) {
        
        snprintf(hash + (2 * i), 3, "%02x", (int)(digest[i]));
        
    }
    
    result = CFStringCreateWithCString(kCFAllocatorDefault,(const char *)hash,kCFStringEncodingUTF8);
    
done:
    
    if (readStream) {
        
        CFReadStreamClose(readStream);
        
        CFRelease(readStream);
    }
    
    if (fileURL) {
        
        CFRelease(fileURL);
        
    }
    
    return result;
    
}
// 毫秒时间戳
+ (NSString *)UUIDTimestamp
{
    return  [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] stringValue];
}
@end
