//
//  NSObject+SGCoding.h
//  LeYingTong
//
//  Created by shangen on 17/1/10.
//  Copyright © 2017年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Codeing协议
 */
@protocol SGCodingProtocol <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)allowedCodingKeys;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)ignoredCodingKeys;

@end
/*********************************************************/
@interface NSObject (SGCoding) <SGCodingProtocol>

/**
 *  编码（将对象写入文件中）
 */
- (void)sg_encode:(NSCoder *)encoder;

/**
 *  解码（从文件中解析对象）
 */
- (void)sg_decode:(NSCoder *)decoder;

@end

/**
 归档的实现
 */
#define SGCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self sg_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self sg_encode:encoder]; \
}

#define SGExtentionCodingImplementation SGCodingImplementation
