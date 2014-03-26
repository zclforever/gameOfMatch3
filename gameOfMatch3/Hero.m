//
//  Hero.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-9.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "Hero.h"
#import "Projectile.h"
#import "SkillDelegate.h"
#import "ProjectileAiWithTargets.h"
#import "ProjectileAiWithTargetPosition.h"
#import "ProjectileAiWithNoTarget.h"
@interface Hero()
@property CGPoint startPosition;

@end

@implementation Hero

-(NSDictionary *)removeByMount:(int)mount{
    NSDictionary* result=[[NSMutableDictionary alloc] init];
    NSString* skill_big=[self.attributeDict valueForKey:@"skill_1"];
    SkillDelegate* skillDelegate=nil;

    if (!self.alive) {
    [result setValue:nil forKey:@"newDelegate"];
        return result;
    }
    
    
    if (mount>=3) {
        self.curEnergy+=mount;
    }
    
    if(mount>=3||[self.objectName isEqualToString:@"hero_warrior"]){
    skillDelegate=[[SkillDelegate alloc]initWithName:skill_big];
        skillDelegate.parent=self;
        [self.skillDelegates addObject:skillDelegate];
    }
    [result setValue:skillDelegate forKey:@"newDelegate"];
    
    
    return result;
}

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray  withName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray withName:name];
    if (self) {
        self.objectName=name;
        self.attackRange=CGSizeMake(400, 60);
        self.tileType=@"hero";
        self.type=@"hero";
        
         self.skillDelegates=[[NSMutableArray alloc] init];
        
        [self.findTargetsDelegate addObserverWithType:@"sightRadius"];
        //self.showBoundingBox=YES;
        //[self updateOfPlayer];
        
        //[self initFromPlist];
    }
    return self;
}

-(void)initFromPlist{
        
    
    [super initFromPlist];
    self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];


}
-(void)start{
    [super start];
    //[self updateOfPlayer];
}


-(void)addPersonSpriteAtPosition:(CGPoint)position{
    self.startPosition=position;
    
    NSString* standSpriteName=[self.attributeDict valueForKey:@"standSpriteName"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"person003.plist"];
    
    //CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"person003.png"];
    CCSprite *sprite;
    if(standSpriteName){
        sprite=[CCSprite spriteWithFile:standSpriteName];

    }else{

        sprite = [CCSprite spriteWithSpriteFrameName:@"person03_000.gif"];
    }
    

    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(-60, position.y);
    
    sprite.scaleX=zPersonWidth/sprite.contentSize.width;
    sprite.scaleY=zPersonHeight/sprite.contentSize.height;
    [self addChild:sprite];
    self.sprite=sprite;

    //add life bar and energy bar
    BarHelper* barHelper=[[BarHelper alloc]initWithOwner:self];
    [barHelper addEnergyBar];
    [barHelper addLifeBar];
    barHelper.visible=NO;
    [self addChild:barHelper];
    

    
    __block AiObject* obj=self;
    [self.sprite runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:3.5],
                            [CCJumpTo actionWithDuration:0.5 position:position height:30 jumps:1],
                            [CCCallBlock actionWithBlock:^{
        obj.node=obj.sprite;
        [obj start];
        barHelper.visible=YES;
    }]
                            ,nil]];
    
    
    //[batchNode addChild:sprite];
//    [self addChild:batchNode];
//    
//    
//    NSMutableArray* frames=[[NSMutableArray alloc]init];
//    for (int i=0; i<=7; i+=1) {
//        NSString* name=[NSString stringWithFormat:@"person03_%03d.gif",i];
//        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
//    }
//    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
//    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
//    
//    [sprite runAction:action ];
    
    //[self.sprite runAction:[CCSkewBy actionWithDuration:3 skewX:0 skewY:50]];
    
    //[self.sprite runAction:[CCJumpTiles3D actionWithDuration:10 size:CGSizeMake(3, 3) jumps:3 amplitude:10]];
}




-(void)hurtByObject:(InteractionData*)data{
    [Actions shakeSprite:self.sprite  delay:0];
    [super hurtByObject:data];
}


-(bool)normalAttackTarget:(AiObject*)obj{
    if (self.curEnergy<5) {
        return NO;
    }
    NSString* skillName=[self.attributeDict valueForKey:@"skill_0"];
    [self.magicDelegate magicAttackWithName:skillName];
    self.curEnergy-=5;
    return YES;
}
-(bool)onReadyToAttackTargetInRange{
    if (!self.alive) {
        return NO;
    }
    
    if (self.curEnergy<5) {
        return NO;
    }
    NSString* skillName=[self.attributeDict valueForKey:@"skill_0"];
    [self.magicDelegate magicAttackWithName:skillName];
    self.curEnergy-=5;
    return YES;
}

-(void)onInSightButNotInAttackRange{
    AiObject* obj=self.findTargetsResult[@"sightRadius"][0];
    [self moveToPosition:obj.node.position];
}
-(void)onFindNothing{
    [self moveToPosition:self.startPosition];
}
-(void)onNothingToDo{
    
    //
    
}


-(void)addApBar{
    
    CCSprite* progressSprite=[CCSprite spriteWithFile:@"circle.png"];
    progressSprite.scale=2.5f;
	CCProgressTimer* progressBar = [CCProgressTimer progressWithSprite:progressSprite];
	progressBar.type = kCCProgressTimerTypeRadial;
	[self addChild:progressBar z:1];
	[progressBar setAnchorPoint: ccp(0,0)];
    self.apBar=progressBar;
    
    progressBar.scale=2.5f;
}
-(void)dieAction{
    //[self.sprite removeFromParentAndCleanup:YES];
    
    self.readyToEnd=YES;
}
-(void)onCurHPIsZero{
    for (SkillDelegate* skillDelegate in self.skillDelegates) {
        skillDelegate.readyToRemove=YES;
    }
    
    self.alive=NO;
    [self.allObjectsArray removeObject:self];
    [self dieAction];
}


@end


