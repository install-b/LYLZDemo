//
//  LYTextView.m
//  TaiYangHua
//
//  Created by Lc on 16/3/28.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "LYTextView.h"
#import "LYEmotion.h"
#import "LYTextAttachment.h"

@implementation LYTextView

// 生成富文本,用以显示表情
- (instancetype)insertEmotion:(LYEmotion *)emotion
{
    if (emotion.png) {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
        [attStr appendAttributedString:self.attributedText];
        
        LYTextAttachment *attachment = [[LYTextAttachment alloc] init];
        attachment.bounds = CGRectMake(0, -4, self.font.lineHeight, self.font.lineHeight);
        attachment.emotion = emotion;
        NSAttributedString *imgAtt = [NSAttributedString attributedStringWithAttachment:attachment];
        
        NSUInteger loc = self.selectedRange.location;
        [attStr replaceCharactersInRange:self.selectedRange withAttributedString:imgAtt];
        [attStr addAttributes:@{NSFontAttributeName : self.font} range:NSMakeRange(0, attStr.length)];
        self.attributedText = attStr;
        self.selectedRange = NSMakeRange(loc + 1, 0);
    }
    
    return self;
}

// 将富文本转换为文本,供以发送给服务器
- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        LYTextAttachment *attch = [attrs objectForKey:@"NSAttachment"];//attrs[@"NSAttachment"];
        if (attch && [attch respondsToSelector:@selector(emotion)]) {
            [fullText appendString:attch.emotion.chs];
        }else {
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return [fullText copy];
}

@end
