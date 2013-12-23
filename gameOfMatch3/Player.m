//
//  Player.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Player.h"
#import "Projectile.h"

@interface Player()
@property (strong,nonatomic) CCSprite* lifeBar;
@property (strong,nonatomic) CCSprite* lifeBarBorder;
@property (strong,nonatomic) CCLabelTTF* HPLabel;

@end

@implementation Player

- (id)init
{
    self = [super init];
    if (self) {
        self.objectName=@"player";
        [self copyFromSharedPerson];
    }
    return self;
}
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=@"player";
    
        
        [self copyFromSharedPerson];
        [self updateOfPlayer];
    }
    return self;
}


-(void)copyFromSharedPerson{
    Person* defaultPerson=[Person sharedPlayer];
    self.curHP=defaultPerson.curHP;
    self.maxHP=defaultPerson.maxHP;
    self.damage=defaultPerson.damage;
    self.spriteName=defaultPerson.spriteName;
    self.stateDict=defaultPerson.stateDict ;
    self.starsOfLevelArray=defaultPerson.starsOfLevelArray;
    self.pointDict=defaultPerson.pointDict;
    self.moneyBuyDict=defaultPerson.moneyBuyDict;
    
}
-(void)addPersonSpriteAtPosition:(CGPoint)position{

    
    CCSprite* sprite=[CCSprite spriteWithFile:self.spriteName];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=position;
    sprite.scaleX=zPersonWidth/sprite.contentSize.width;
    sprite.scaleY=zPersonHeight/sprite.contentSize.height;
    self.sprite=sprite;
    [self addChild:sprite];
    
    [self addLifeBar];
    
    
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


-(void)hurtByObject:(AiObject *)obj{
    [Actions shakeSprite:self.sprite  delay:0];
    self.curHP-=obj.damage;
}
-(void)magicAttackByName:(NSString *)magicName{
    [self magicAttackByName:magicName withParameter:nil];
}
-(void)magicAttackByName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{
    NSString* name=magicName;
    if([name isEqualToString:@"fireBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(self.sprite.position.x+zPersonWidth,self.sprite.position.y+zPersonHeight/2) byName:name];
        [self addChild:projectile];
        [projectile attackNearest];
        
    }
  
    if([name isEqualToString:@"iceBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(self.sprite.position.x+zPersonWidth,self.sprite.position.y+zPersonHeight/2) byName:name];
        [self addChild:projectile];
        [projectile attackNearest];
        
    }
    
    if([name isEqualToString:@"snowBall"]){
        Projectile* projectile=[[Projectile alloc]initWithAllObjectArray:self.allObjectsArray withPostion:ccp(160,460) byName:name];
        [self addChild:projectile];
        [projectile attackPosition:ccp(160,self.sprite.position.y)];
        
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

    
    if(self.lifeBar){
        
        
        if(1){
            if(self.curHP<0) self.curHP=0;
            //updatePosition
            self.lifeBar.position=ccp(self.sprite.position.x,self.sprite.position.y+55);
            self.lifeBarBorder.position=self.lifeBar.position;
            float lifeBarFixY=self.lifeBar.position.y+zStatePanel_LifeBarHeight/2;
            self.HPLabel.position = ccp(self.lifeBar.position.x+zStatePanel_LifeBarWidth/2,lifeBarFixY);
            
            if(self.apBar){
                self.apBar.position=ccp(self.lifeBar.position.x+20,self.lifeBar.position.y+20);
                self.apBar.percentage=self.curStep;
            }
            
            [self.HPLabel setString:[NSString stringWithFormat:@"%d/%d",(int)self.curHP,(int)self.maxHP]];
            
            self.lifeBar.scaleX=self.curHP/self.maxHP*zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
        }
    }
 
    [self setTimeOutWithDelay:self.delayTime withSelector:@selector(updateOfPlayer)];

}

@end
