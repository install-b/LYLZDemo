//
//  LYEmotion.h
//  TaiYangHua
//
//  Created by Lc on 16/2/26.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYEmotion : NSObject
/** 表情的文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 表情的png图片名 */
@property (nonatomic, copy) NSString *png;

+ (instancetype)emotionWithDict:(NSDictionary *)dict;
@end
