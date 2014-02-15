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
@interface Hero()
@property (strong,nonatomic) CCSprite* lifeBar;
@property (strong,nonatomic) CCSprite* lifeBarBorder;
@property (strong,nonatomic) CCSprite* energyBar;
@property (strong,nonatomic) CCSprite* energyBarBorder;
@property (strong,nonatomic) CCLabelTTF* HPLabel;
@property bool isAttacking;
@end

@implementation Hero

-(NSDictionary *)removeByMount:(int)mount{
    NSDictionary* result=[[NSMutableDictionary alloc] init];
    NSString* skill_big=[self.attributeDict valueForKey:@"skill_1"];
    SkillDelegate* skillDelegate=[[SkillDelegate alloc]initWithName:skill_big];
    skillDelegate.parent=self;
    [result setValue:skillDelegate forKey:@"newDelegate"];
    
    
    return result;
}

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray  withName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=name;
        self.attackRange=CGSizeMake(400, 60);
        self.attackCD=1.0;
        self.type=@"hero";
        //self.showBoundingBox=YES;
        //[self updateOfPlayer];
        
        self.curEnergy=0;
        self.maxEnergy=100;
        [self initFromPlist];
        [self start];
    }
    return self;
}

-(void)initFromPlist{
    self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
//    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];
    self.attackCD=[[self.attributeDict valueForKey:@"attackCD"] floatValue];
    self.moveSpeed=[[self.attributeDict valueForKey:@"moveSpeed"] floatValue];
    self.maxHP=[[self.attributeDict valueForKey:@"maxHP"] floatValue];
    self.curHP=self.maxHP;
}
-(void)start{
    [self updateOfPlayer];
}


-(void)addPersonSpriteAtPosition:(CGPoint)position{
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"person003.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"person003.png"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"person03_000.gif"];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(-60, position.y);
    
    sprite.scaleX=zPersonWidth/sprite.contentSize.width;
    sprite.scaleY=zPersonHeight/sprite.contentSize.height;
    [self addChild:sprite];
    self.sprite=sprite;
    [self addLifeBar];
    [self addEnergyBar];
    
    self.node=self.sprite;
    [self.sprite runAction:[CCSequence actions:
                            [CCDelayTime actionWithDuration:3.5],
                            [CCJumpTo actionWithDuration:0.5 position:position height:30 jumps:1]
                            ,nil]];
    
    
    //[batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=0; i<=7; i+=1) {
        NSString* name=[NSString stringWithFormat:@"person03_%03d.gif",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    [sprite runAction:action ];
    
    //[self.sprite runAction:[CCSkewBy actionWithDuration:3 skewX:0 skewY:50]];
    
    //[self.sprite runAction:[CCJumpTiles3D actionWithDuration:10 size:CGSizeMake(3, 3) jumps:3 amplitude:10]];
}
-(void)addEnergyBar{
    //init LifeBar
    self.energyBar=[CCSprite spriteWithFile:@"bar_yellow.png" ];
    self.energyBar.anchorPoint=ccp(0,0);
    self.energyBar.scaleY=zStatePanel_LifeBarHeight/self.energyBar.contentSize.height;
    self.energyBar.scaleX=zStatePanel_LifeBarWidth/self.energyBar.contentSize.width;
    
    [self addChild:self.energyBar];
    
    self.energyBarBorder=[CCSprite spriteWithFile:@"border_yellow_gray.png"];
    self.energyBarBorder.anchorPoint=ccp(0,0);
    self.energyBarBorder.scaleY=zStatePanel_LifeBarHeight/self.energyBarBorder.contentSize.height;
    self.energyBarBorder.scaleX=zStatePanel_LifeBarWidth/self.energyBarBorder.contentSize.width;
    
    [self addChild:self.energyBarBorder];
    //init LifeBarLabel

    
}
-(void)addLifeBar{
    //init LifeBar
    self.lifeBar=[CCSprite spriteWithFile:@"lifeBar.png" ];
    self.lifeBar.anchorPoint=ccp(0,0);
    self.lifeBar.scaleY=zStatePanel_LifeBarHeight/self.lifeBar.contentSize.height;
    self.lifeBar.scaleX=zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    
    [self addChild:self.lifeBar];
    
    self.lifeBarBorder=[CCSprite spriteWithFile:@"border.png"];
    self.lifeBarBorder.anchorPoint=ccp(0,0);
    self.lifeBarBorder.scaleY=zStatePanel_LifeBarHeight/self.lifeBarBorder.contentSize.height;
    self.lifeBarBorder.scaleX=zStatePanel_LifeBarWidth/self.lifeBarBorder.contentSize.width;
    
    [self addChild:self.lifeBarBorder];
    //init LifeBarLabel
    
    int fontSize=10;
    
    
    //float lifeBarFixY=self.lifeBar.position.y;//缩放修正过
    
    
    
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:fontSize];
    label.color = ccc3(255,255,255);
    //label.anchorPoint=ccp(0,0);
    
    [self addChild:label];
    
    self.HPLabel=label;
    
}
-(void)updateCollisionObjectArray{  //collision.coll.
    
    [self.collisionObjectArray removeAllObjects];
    for (AiObject* obj in self.allObjectsArray) {
        if(obj==self)continue;
        CGRect selfRect=[self getBoundingBox];
        selfRect.size=CGSizeMake(selfRect.size.width+self.attackRange.width, selfRect.size.height+self.attackRange.height);
        CGRect objRect=[(id)obj getBoundingBox];
        
        
        if ([Global rectInsect:objRect :selfRect]) {
            [self.collisionObjectArray addObject:obj];
        }
    }
}
-(void)handleCollision{
    if (!self.alive) {
        //[self removeFromParentAndCleanup:YES];
        return;
    }
    for (int i=0; i<self.collisionObjectArray.count; i++) {
        __block AiObject* obj=self.collisionObjectArray[i];
        __block Hero* selfObj=self;
        if([[[Global sharedManager]allEnemys] containsObject:[obj objectName]]&&!self.isAttacking&&!self.state.frozen){
            if (selfObj.curEnergy<5) {
                break;
            }
            self.isAttacking=YES;
            
            [self setTimeOutWithDelay:self.attackCD withBlock:^{
                selfObj.curEnergy-=5;
                
                
                [selfObj magicAttackWithName:[selfObj.attributeDict valueForKey:@"skill_0"]];
                
                selfObj.isAttacking=NO;
            }];
            
            //攻击动画
            //[self.sprite stopAllActions];
            //[self attackAnimation];
        }
    }
    
}

-(void)hurtByObject:(AiObject *)obj{
    [Actions shakeSprite:self.sprite  delay:0];
    self.curHP-=obj.damage;
}
-(void)magicAttackWithName:(NSString *)magicName{
    [self magicAttackWithName:magicName withParameter:nil];
}
-(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{
    NSString* name=magicName;
    if([name isEqualToString:@"skill_bigFireBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(100,460) byName:name];
        [self addChild:projectile];
        [projectile attackPosition:ccp(zEnemyMarginLeft+zPersonWidth/2,self.sprite.position.y+zPersonHeight/2)];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
        
        
    }
    
    
    if([name isEqualToString:@"skill_fireBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(self.sprite.position.x+zPersonWidth,self.sprite.position.y+zPersonHeight/2) byName:name];
        [self addChild:projectile];
        [projectile attackNearest];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"fire_fly.wav"];
        
        
    }
    
    if([name isEqualToString:@"skill_iceBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(self.sprite.position.x+zPersonWidth+5,self.sprite.position.y+zPersonHeight/2-10) byName:name];
        [self addChild:projectile];
        [projectile attackPosition:ccp(zEnemyMarginLeft,self.sprite.position.y+zPersonHeight/2-10)];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"ice_fly.wav"];
        
    }
    
    if([name isEqualToString:@"skill_snowBall"]){
        float randomX=50+arc4random()%220;
        
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(randomX,460) byName:name];
        [self addChild:projectile z:5];
        [projectile attackPosition:ccp(0,self.sprite.position.y)];
        
    }
    
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
-(void)updateOfPlayer{
    
    if(self.energyBar){
        if(self.curEnergy<0) self.curEnergy=0;
        //updatePosition
        self.energyBar.position=ccp(self.sprite.position.x,self.sprite.position.y+65);
        self.energyBarBorder.position=self.energyBar.position;
        
        self.energyBar.scaleX=self.curEnergy/self.maxEnergy*zStatePanel_LifeBarWidth/self.energyBar.contentSize.width;
        
    
    }
    
    if(self.lifeBar){
        
        
        if(1){
            if(self.curHP<0) self.curHP=0;
            //updatePosition
            self.lifeBar.position=ccp(self.sprite.position.x,self.sprite.position.y+85);
            self.lifeBarBorder.position=self.lifeBar.position;
            float lifeBarFixY=self.lifeBar.position.y+zStatePanel_LifeBarHeight/2;
            self.HPLabel.position = ccp(self.lifeBar.position.x+zStatePanel_LifeBarWidth/2,lifeBarFixY);
            
           
            [self.HPLabel setString:[NSString stringWithFormat:@"%d/%d",(int)self.curHP,(int)self.maxHP]];
            
            self.lifeBar.scaleX=self.curHP/self.maxHP*zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
        }
    }
    
    [self setTimeOutWithDelay:self.delayTime withSelector:@selector(updateOfPlayer)];
    
}

@end


