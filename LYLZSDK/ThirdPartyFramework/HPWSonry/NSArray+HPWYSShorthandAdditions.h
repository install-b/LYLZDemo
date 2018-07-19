//
//  NSArray+HPWYSShorthandAdditions.h
//  HPWYSonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+HPWYSAdditions.h"

#ifdef HPWYS_SHORTHAND

/**
 *	Shorthand array additions without the 'hpwys_' prefixes,
 *  only enabled if HPWYS_SHORTHAND is defined
 */
@interface NSArray (HPWYSShorthandAdditions)

- (NSArray *)hpwysMakeConstraints:(void(^)(HPWYSConstraintMaker *make))block;
- (NSArray *)hpwysUpdateConstraints:(void(^)(HPWYSConstraintMaker *make))block;
- (NSArray *)hpwysRemakeConstraints:(void(^)(HPWYSConstraintMaker *make))block;

@end

@implementation NSArray (HPWYSShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(HPWYSConstraintMaker *))block {
    return [self hpwys_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(HPWYSConstraintMaker *))block {
    return [self hpwys_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(HPWYSConstraintMaker *))block {
    return [self hpwys_remakeConstraints:block];
}

@end

#endif
