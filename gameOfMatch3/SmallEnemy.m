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



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;
{
    self = [super initWithAllObjectArray:allObjectsArray withName:name];
    if (self) {
        //self.showBoundingBox=YES;
        
        self.objectName=name;
        self.readyToEnd=NO;
        self.alive=YES;
        self.atDest=NO;

        self.destPosition=ccp(zPlayerMarginLeft,480-zPlayerMarginTop);
        //初始化属性
        self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
        
        
        self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
        self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
        self.attackCD=[[self.attributeDict valueForKey:@"attackCD"] floatValue];
        self.moveSpeed=[[self.attributeDict valueForKey:@"moveSpeed"] floatValue];
        self.maxHP=[[self.attributeDict valueForKey:@"maxHP"] floatValue];
        self.curHP=self.maxHP;
        
        float scale=[[self.attributeDict valueForKey:@"spriteScale"] floatValue];
        
        self.sprite=[CCSprite spriteWithFile:@"transparent.png"];
        self.sprite.anchorPoint=ccp(0.5,0);
        self.sprite.scale=scale;
        self.sprite.visible=NO;
        [self addChild:self.sprite];
        
        self.node=self.sprite;
        


        //self.spriteEntity=self;
        //addLifeBar
        BarHelper* barHelper=[[BarHelper alloc]initWithOwner:self];
        [barHelper addLifeBar];
        [self addChild:barHelper];
        
        //[self update];
        
        
    }
    return self;
}

-(void)loadAttributeFromDict{
    
}
-(void)appearAtX:(int)x Y:(int)y{
    self.sprite.position=ccp(x,y);
    self.sprite.visible=YES;
        
}
-(void)dieAction{
   
    [[SimpleAudioEngine sharedEngine] playEffect:@"boy_ah.wav"];
    
    
    int x=100+arc4random()%400;
    int y=500+arc4random()%100;
    if (arc4random()%2==1) {
        y=-(arc4random()%100);
    }
    float delayTime=1+arc4random()%200/100;
    

    
    self.sprite.anchorPoint=ccp(0.5,0.5);

    __block AiObject* obj=self;
    [self.sprite runAction:[CCSpawn actions:
                                [CCRotateBy actionWithDuration:delayTime angle:4145],

                                //[CCScaleTo actionWithDuration:delayTime scale:1+delayTime*3],
                            
                                [CCSequence actions:
                                                [CCMoveTo actionWithDuration:delayTime position:ccp(x,y)],
                                                //[CCJumpTo actionWithDuration:delayTime/3*2 position:ccp(320,[self getBoundingBox].origin.y) height:20 jumps:6],
                                                //[CCJumpTo actionWithDuration:delayTime/3 position:ccp(360,-50) height:20 jumps:1],
                                                //[CCDelayTime actionWithDuration:0.2f],
                                                [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                                [node stopAllActions];
                                    obj.readyToEnd=YES;
                                                }],
                                                
                                                nil],
                            
                            nil]];
    
    
}

-(void)hurtByObject:(AiObject *)obj{
    bool needHurt=YES;
    
    if ([obj.objectName isEqualToString:@"snowBall"]) {
        if(!self.state.frozen){
            self.state.frozen=YES;
            [self.sprite stopAllActions];
            self.state.frozenStartTime=[[Global sharedManager] gameTime];
            [self.sprite runAction:[CCTintBy actionWithDuration:1 red:-120 green:-120 blue:0]];
        }
        else{  //如果已经冻结;
            needHurt=NO;
        }

    }
    

    if ([obj.objectName isEqualToString:@"iceBall"]) {
        if(self.moveSpeed>1){
            self.moveSpeed-=1;
            [self.sprite runAction:[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0]];

        }
            
        self.sprite.position=ccp(self.sprite.position.x+10,self.sprite.position.y);
        
                //[self.sprite runAction:[CCTintTo actionWithDuration:3 red:160 green:160 blue:255]];
    
    }
    
    
   if(needHurt) self.curHP-=obj.damage;
}

-(void)moveAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=1;
    float delay=[[self.attributeDict valueForKey:@"animationMoveDelay"] floatValue];

    CCAnimation* animation=[self animationByPlist:self.animationMovePlist withDelay:delay];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    self.animatingTag=1;
    [self.sprite runAction:action ];
    
}
-(void)attackAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=2;

    float delay=[[self.attributeDict valueForKey:@"animationAttackDelay"] floatValue];
    CCAnimation* animation=[self animationByPlist:[self.attributeDict valueForKey:@"animationAttackPlist"] withDelay:delay];

    CCAction* action=[CCAnimate actionWithAnimation:animation];
    [self.sprite runAction:action ];
    
}
-(bool)normalAttackTarget:(AiObject*)obj{

    [obj hurtByObject:self];
    return YES;
}

-(bool)onReadyToAttackTargetInRange{
    self.wantedObject=self.collisionObjectsInAttankRange[0];
    [self normalAttackTarget:self.wantedObject];
    return YES;
}

-(void)onInSightButNotInAttackRange{
    [self moveToPosition:self.destPosition];
}
-(void)onNothingInSight{
    [self moveToPosition:self.destPosition];
}
-(void)nothingToDo{
    [self moveToPosition:self.destPosition];
}
-(void)onCurHPIsZero{
    self.alive=NO;
    [self.allObjectsArray removeObject:self];
    [self dieAction];
    
}

//[self.sprite runAction:[[CCTintBy actionWithDuration:1 red:-120 green:-120 blue:0] reverse] ];
@end
