//
//  NSArray+InvertedOrder.m
//  LYTDemo
//
//  Created by Shangen Zhang on 2017/5/10.
//  Copyright © 2017年 Vieene. All rights reserved.
//

#import "NSArray+InvertedOrder.h"

@implementation NSArray (InvertedOrder)
- (instancetype)invertedOrderArray {
    if (self.count) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.count];
        for (NSInteger i = self.count - 1; i >= 0; i--) {
            [temp addObject:self[i]];
        }
        return temp;
    }
    return self.mutableCopy;
}
@end
