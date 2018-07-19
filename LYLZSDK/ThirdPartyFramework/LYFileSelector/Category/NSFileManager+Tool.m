//
//  NSFileManager+Tool.m
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/12.
//  Copyright © 2017 深圳柒壹思诺科技有限公司. All rights reserved.
//

#import "NSFileManager+Tool.h"

@implementation NSFileManager (Tool)

- (BOOL)copyFile:(NSString *)filePath to:(NSString *)path {
    
    if([self creatFileDirection:path.stringByDeletingLastPathComponent ]){
        NSError *error;
        BOOL result =  [self copyItemAtPath:filePath toPath:path error:&error];
        if (error) {
            //LYTLog(@"------copyItemAtPath ERROR-%@",error);
        }
        return result;
    }
    return NO;
}

- (BOOL)creatFileDirection:(NSString *)path {
    if (![self fileExistsAtPath:path]) {
        return  [self createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return YES;
}

- (NSString *)checkFileName:(NSString *)destinationPath {
    //
    BOOL isDirection;
    BOOL exist = [self fileExistsAtPath:destinationPath isDirectory:&isDirection];
    if (exist) {
        NSArray *componentsArray = destinationPath.pathComponents;
        NSArray *nameArray = [componentsArray.lastObject componentsSeparatedByString:@"."];
        NSString *name = [nameArray firstObject];
        NSString *estension = [nameArray lastObject];
        for (int a = 1 ; a <100; a++) {
            
            NSString * tempName = [name stringByAppendingString:[NSString stringWithFormat:@"(%d)",a]];
            NSString * twoName = [tempName stringByAppendingFormat:@".%@",estension];
            NSMutableArray *array = [NSMutableArray arrayWithArray:componentsArray.mutableCopy];
            [array removeLastObject];
            [array addObject:twoName];
            NSString *twoPath = [NSString pathWithComponents:array];
            if ([self fileExistsAtPath:twoPath isDirectory:&isDirection]) {
                continue;
            }else{
                return twoPath;
                break;
            }
        }
    }else{
        //LYTLog(@"没有发现重命的文件")
    }
    return destinationPath;
}

@end
