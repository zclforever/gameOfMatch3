//
//  AI.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "AI.h"

@implementation AI
-(id) initWithBox: (Box*) box{
    self=[super init];
    
    self.box=box;
    return self;
}
-(NSArray*)thinkAndFindTile{
    NSArray* order=[NSArray arrayWithObjects:@5,@4,@3,@2,@1, nil];
    NSArray* ret=[self findOneMatchWithOrder:order];
    return ret;
    
}
-(NSArray*)findOneMatchWithOrder:(NSArray*)order{
    NSMutableArray* matched=[self.box scanSwapMatch];
    for(int i=0;i<order.count;i++){
        int value=[order[i] intValue];
        NSArray* firstMatched=[self.box findMatchedSwapArray:matched forValue:value];
        if(firstMatched)return firstMatched;
    }
    return nil;
}
@end
