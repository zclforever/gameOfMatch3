//
//  SmallEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "SmallEnemy.h"

@interface SmallEnemy()


@end


@implementation SmallEnemy

- (id)init
{
    self = [super init];
    if (self) {
        
        self.readyToEnd=NO;
        self.isAlive=YES;
        self.atDest=NO;
        self.startMove=NO;
        
        self.sprite=[CCSprite spriteWithFile:@"skeleton_left.png"];
        self.sprite.anchorPoint=ccp(0,0);
        self.sprite.scale=2.0f;
        self.sprite.visible=NO;
        [self addChild:self.sprite];
        
        self.damage=1.0;
        
        [self update];
        
        
    }
    return self;
}
-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:@selector(update)],
      nil]];
    
}
-(void)appearAtX:(int)x Y:(int)y{
    self.sprite.position=ccp(x,y);
   
    self.sprite.visible=YES;
    self.startMove=YES;
        
}
-(void)dieAction{
    int x=-10+arc4random()%400;
    int y=self.sprite.position.y+30+arc4random()%500;
    
    
    
    [self.sprite runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:.5 position:ccp(x,y)],
                           
                           [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                [node removeFromParentAndCleanup:YES];
                            }],
                           
                           nil]];
    
    self.readyToEnd=YES;
}

-(void)update{
    float delayTime=0.04;
    
    //--------------结束标志----------------------
    if (self.readyToEnd) {
        return;
    }
    
    //-------------是否还活着--------------
    
    if (self.startMove) {
        if (self.curHP<=0) {
            self.isAlive=NO;
            [self dieAction];
        }
    }
    
    
    //---------------是否开始移动 且未到目的地---------------------
    float moveSpeed=13.0;
    if (self.startMove&&!self.atDest) {
        CGPoint pos=self.sprite.position;
        if (pos.x>self.destPos.x) {   //没有到达目的地
            self.sprite.position=ccp(pos.x-moveSpeed*delayTime,pos.y);
        }else{
            self.atDest=YES;
        }
       
    }
    

    
    
    
    [self setTimeOutOfUpdateWithDelay:delayTime];
}

@end
