//
//  BuffHelper.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BuffHelper.h"


@implementation BuffHelper  //只负责在增减 BUFF 队列 至于BUFF 做什么 不管


-(id)initWithOwner:(id<BuffHelperProtocol>)owner{
    self=[super init];
    self.owner=owner;
    
    [self schedule:@selector(update)];
    return self;
}

+(void)addBuffWithName:(NSString*)name type:(BuffType)type to:(id<BuffHelperProtocol>)object{
    if (type==reset) {
        
    }
   
}

-(void)update{
    AiObject* owner=self.owner;
}
@end
