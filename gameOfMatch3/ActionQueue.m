//
//  ActionQueue.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "ActionQueue.h"

@interface ActionQueue()
@property bool updating;

@end
@implementation ActionQueue
- (id)init
{
    self = [super init];
    if (self) {
        
        self.actionArray=[[NSMutableArray alloc]init];
        self.actionFinishedArray=[[NSMutableArray alloc]init];
        self.updating=NO;
        self.lock=NO;
//        [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(update) forTarget:self interval:.1 repeat:kCCRepeatForever delay:0 paused:NO] ;
        
        [self update];
    }
    return self;
}

-(void)addActionWithBlock:(void(^)())block{
    [self.actionArray addObject:block];
}
-(void)nextAction{
    self.updating=NO;
}

-(void)update{
    
    //NSLog(@"int actionHandler updating");
    
    if(self.actionArray.count<=0)[self runAction:];
    
    self.updating=YES;
    int (^block)(void)=self.actionArray[0];
    [self.actionArray removeObjectAtIndex:0];
    
    block();
    
    
    
}

@end
