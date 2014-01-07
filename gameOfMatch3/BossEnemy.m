//
//  BossEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "BossEnemy.h"

@interface BossEnemy()


@end
@implementation BossEnemy


-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withLevel:(int)level{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=@"bossEnemy";
        
        self.level=level;
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
    sprite.position=position;
    sprite.scaleX=zPersonWidth/sprite.contentSize.width;
    sprite.scaleY=zPersonHeight/sprite.contentSize.height;
    [self addChild:sprite];
    self.sprite=sprite;
    [self addLifeBar];
    
    //[batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=0; i<=31; i+=1) {
        NSString* name=[NSString stringWithFormat:@"frame_%03d.gif",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    [sprite runAction:action ];
    

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
