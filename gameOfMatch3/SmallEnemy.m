//
//  SmallEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "SmallEnemy.h"

@interface SmallEnemy()
@property int animatingTag;

@end


@implementation SmallEnemy



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;
{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        
        self.objectName=@"smallEnemy";
        self.readyToEnd=NO;
        self.alive=YES;
        self.atDest=NO;
        self.startMove=NO;
        
        self.sprite=[CCSprite spriteWithFile:@"skeleton_left.png"];
        self.sprite.anchorPoint=ccp(0.5,0);
        self.sprite.scale=1.0f;
        self.sprite.visible=NO;
        [self addChild:self.sprite];
        
        self.damage=2.0;
        self.attackCD=2.0f;
        self.moveSpeed=8.0f;

        //self.spriteEntity=self;
        [self update];
        
        
    }
    return self;
}

-(void)appearAtX:(int)x Y:(int)y{
    self.sprite.position=ccp(x,y);
   
    self.sprite.visible=YES;
    self.startMove=YES;
        
}
-(void)dieAction{
   
    
    
    
    int x=100+arc4random()%400;
    int y=self.sprite.position.y+30+arc4random()%500;
    if (arc4random()%2==1) {
        y=-(arc4random()%300);
    }
    float delayTime=0.5+arc4random()%300/100;
    
    [self.sprite runAction:[CCSpawn actions:
                                [CCRotateBy actionWithDuration:delayTime angle:4145],
                            
                                [CCSequence actions:
                                                [CCMoveTo actionWithDuration:delayTime position:ccp(x,y)],
                                                
                                                [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                                [node removeFromParentAndCleanup:YES];
                                                }],
                                                
                                                nil],
                            
                            nil]];
    
    self.readyToEnd=YES;
}
-(void)handleCollision{
    for (int i=0; i<self.collisionObjectArray.count; i++) {
        AiObject* obj=self.collisionObjectArray[i];
        if([[obj objectName] isEqualToString:@"player"]&&!self.isAttacking){
            self.isAttacking=YES;
            [self setTimeOutWithDelay:self.attackCD withSelector:@selector(nomalAttack)];
            
            //攻击动画
            //[self.sprite stopAllActions];
            [self attackAnimation];
        }
    }

}
-(void)hurtByObject:(AiObject *)obj{
    bool needHurt=YES;
    
    if ([obj.objectName isEqualToString:@"snowBall"]) {
        if(!self.state.frozen){
            self.state.frozen=YES;
            [self.sprite stopAllActions];
            self.state.frozenStartTime=[[Global sharedManager] gameTime];
        }
        else{  //如果已经冻结;
            needHurt=NO;
        }

    }
    
    
   if(needHurt) self.curHP-=obj.damage;
}
-(void)nomalAttack{
    if(self.collisionObjectArray.count>0){
        
        AiObject* obj=self.collisionObjectArray[0];
        [obj hurtByObject:self];
        self.isAttacking=NO;
    }

}
-(void)moveAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=1;

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"smallEnemyMove.plist"];

    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"smallEnemyMove.png"];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=2669; i<=2677; i+=2) {
        NSString* name=[NSString stringWithFormat:@"image%d.png",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    self.animatingTag=1;
    [self.sprite runAction:action ];
    
}
-(void)attackAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=2;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"smallEnemyAttack.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"smallEnemyAttack.png"];
    [self addChild:batchNode];
    

    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=2679; i<=2703; i+=2) {
        NSString* name=[NSString stringWithFormat:@"image%d.png",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    float attackDelay=self.attackCD/10;
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:attackDelay];
    CCAction* action=[CCAnimate actionWithAnimation:animation];
    [self.sprite runAction:action ];
    
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
            self.alive=NO;
            [self.allObjectsArray removeObject:self];
            [self dieAction];

        }
    }
    
    
    //---------------是否开始移动 且未到目的地---------------------
    float moveSpeed=self.moveSpeed;
    if (self.startMove&&!self.atDest) {
        
        if(self.state.frozen){
            moveSpeed=0;
            if ([[Global sharedManager] gameTime]-self.state.frozenStartTime>=5.0f) {
                self.state.frozen=NO;
                moveSpeed=self.moveSpeed;
                [self moveAnimation];
            }
        }
        
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
