//
//  const.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

/* 非线程安全的实现 */
/*
@implementation SomeManager

+ (id)sharedManager {
    static id sharedManager = nil;
    
    if (sharedManager == nil) {
        sharedManager = [[self alloc] init];
    }
    
    return sharedManager;
}
@end
*/

#import "const.h"
/* 线程安全的实现 */
@implementation consts

static id sharedManager = nil;

+ (void)initialize {
    if (self == [consts class]) {
        sharedManager = [[self alloc] init];
    }
}

+ (id)sharedManager {
    return sharedManager;
}
@end