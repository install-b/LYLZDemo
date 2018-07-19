//
//  NSAttributedString+TYHEmojiExpression.m
//  TaiYangHua
//
//  Created by HHLY on 16/1/27.
//  Copyright © 2016年 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "NSAttributedString+TYHEmojiExpression.h"
#import "MLTextAttachment.h"

@implementation NSAttributedString (TYHEmojiExpression)
- (NSString *)getPlainString
{
    NSMutableString *plainStr = [NSMutableString stringWithString:self.string];
    __block NSInteger base = 0;
    [self enumerateAttribute:NSAttachmentAttributeName
                     inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                      if (value && [value isKindOfClass:[MLTextAttachment class]]) {
                          [plainStr replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:((MLTextAttachment *) value).emojiTag];
                          
                          base += ((MLTextAttachment *)value).emojiTag.length - 1;
                      }
                      
                  }];
    return plainStr;
}

@end
