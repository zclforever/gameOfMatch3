//
//  ActionQueue.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//
#import "Actions.h"
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
        [self addChild:[Actions sharedManager]];
        self.updating=NO;
        self.lock=NO;
        //[[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(update) forTarget:self interval:.1 repeat:kCCRepeatForever delay:0 paused:NO] ;
        
        [self update];
    }
    return self;
}
-(void)onExit{
    [super onExit];
    [[Actions sharedManager] removeAllChildrenWithCleanup:YES];
    [self removeAllChildrenWithCleanup:YES];
}
-(void)addActionWithBlock:(void(^)())block{
    [self.actionArray addObject:block];
}
-(void)nextAction{
    self.updating=NO;
}

-(void)update{
    float updateDelay=0.01;
    //NSLog(@"int actionHandler updating");
    if([Actions getActionCount]>0){[self setTimeOutOfUpdateWithDelay:updateDelay];return;}
    if(self.actionArray.count<=0){[self setTimeOutOfUpdateWithDelay:updateDelay];return;}

    int (^block)(void)=self.actionArray[0];
    [self.actionArray removeObjectAtIndex:0];
    
    
    block();
    NSLog(@"int actionHandler updating finished");
    
    [self setTimeOutOfUpdateWithDelay:updateDelay];
}
-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:@selector(update)],
      
      nil]];
    
}
@end
