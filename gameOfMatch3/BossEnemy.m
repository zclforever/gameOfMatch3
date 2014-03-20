//
//  BossEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "BossEnemy.h"
#import "SimpleAudioEngine.h"
@interface BossEnemy()


@end
@implementation BossEnemy


-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withLevel:(int)level with:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray withName:name];
    if (self) {
        self.objectName=@"bossEnemy";
        self.type=@"enemy";
        self.level=level;
        //self.showBoundingBox=YES;
        [self dataByLevel:level];
        [self updateOfBossEnemy];

    }
    return self;
}
-(void)addPersonSpriteAtPosition:(CGPoint)position{
   
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"person001.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"person001.png"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"frame_000.gif"];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(360,position.y);
    sprite.scaleX=zPersonWidth/sprite.contentSize.width;
    sprite.scaleY=zPersonHeight/sprite.contentSize.height;
    [self addChild:sprite];
    self.sprite=sprite;
    //BarHelper* barHelper=[[BarHelper alloc]initWithOwner:self];
    //[barHelper addLifeBar];
    //[self addChild:barHelper];

    self.node=self.sprite;
    
    [self.sprite runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:3.5],
                            [CCJumpTo actionWithDuration:0.5 position:position height:30 jumps:1]
                            ,nil]];
    //[batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=0; i<=31; i+=1) {
        NSString* name=[NSString stringWithFormat:@"frame_%03d.gif",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.07f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    [sprite runAction:action ];
    

}

-(void)hurtByObject:(AiObject *)obj{
    [[SimpleAudioEngine sharedEngine] playEffect:@"girl_ah.wav"];
    [Actions shakeSprite:self.sprite  delay:0];
    self.curHP-=obj.damage;
    
}
-(void)dataByLevel:(int)level{
    Person* defaultPerson=[Person enemyWithLevel:level];

    self.curHP=defaultPerson.curHP;
    self.maxHP=defaultPerson.maxHP;
    self.damage=defaultPerson.damage;
    self.spriteName=defaultPerson.spriteName;
    self.stateDict=defaultPerson.stateDict ;
    self.maxStep=defaultPerson.maxStep;
    self.curStep=defaultPerson.curStep;
    self.apSpeed=defaultPerson.apSpeed;


    self.smallEnemyCount=defaultPerson.smallEnemyCount;
    self.smallEnemyHp=defaultPerson.smallEnemyHp;
    self.attackType=defaultPerson.attackType;
    
}

-(void)updateOfBossEnemy{
    
    
    
    
    
    
    [self setTimeOutWithDelay:self.delayTime withSelector:@selector(updateOfBossEnemy)];
}
@end
