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
-(void)thinkAndTradeTile:(SEL)sel{
    NSArray* order=[NSArray arrayWithObjects:@5,@4,@3,@2,@1, nil];
    NSArray* ret=[self findOneMatchWithOrder:order];
    if(ret){
    
    }
    else{
    
    }
    
}
-(NSArray*)findOneMatchWithOrder:(NSArray*)order{
    NSMutableArray* matched=[self.box scanForMatch];
    for(int i=0;i<order.count;i++){
        int value=order[i];
        NSArray* firstMatched=[self.box findMatchedArray:matched forValue:value];
        if(firstMatched)return firstMatched;
    }
    return nil;
}
@end
