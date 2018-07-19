//
//  NSString+TextSize.m
//  NSString分类
//
//  Created by 二爷 on 13-09-26.
//  Copyright (c) 2013年 ErYe. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)

/**
 *  计算文本文字的矩形尺寸
 *
 *  @param font    文本文字的字体
 *  @param maxSize 定义它的最大尺寸，当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
 *
 *  @return 根据文本文字的字体以及最大限制尺寸返回计算好的文本文字的矩形尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    //传入一个字体（大小号）保存到字典
    NSDictionary *attrs = @{NSFontAttributeName : font};
    
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGFloat)heightWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth {
    
    return [self sizeWithFont:font MaxSize:CGSizeMake(maxWidth, HUGE)].height;
    
}
- (CGFloat)widthWithFont:(UIFont *)font MaxWidth:(CGFloat)maxWidth {
    
    return [self sizeWithFont:font MaxSize:CGSizeMake(maxWidth, HUGE)].width;
    
}
@end
