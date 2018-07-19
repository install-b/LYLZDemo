//
//  NSFileManager+Tool.h
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/12.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Tool)

- (BOOL)creatFileDirection:(NSString *)path;

- (BOOL)copyFile:(NSString *)filePath to:(NSString *)path;

- (NSString *)checkFileName:(NSString *)destinationPath;
@end
