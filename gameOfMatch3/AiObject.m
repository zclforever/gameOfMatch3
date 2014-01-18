//
//  AiObject.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "AiObject.h"

@implementation State

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
@interface AiObject()


@end

@implementation AiObject



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray{
    self = [super init];
    //self.contentSize=[[CCDirector sharedDirector]winSize];
    if (self) {
        if (!allObjectsArray) {
            return self;
        }
        self.delayTime=0.04;
        self.autoUpdateCollision=YES;
        
        self.alive=YES;
        self.state=[[State alloc]init];
        self.collisionObjectArray=[[NSMutableArray alloc]init];
        self.allObjectsArray=allObjectsArray;
        [self.allObjectsArray addObject:self];
        [self updateForCommon];
    }
    return self;
}
-(NSArray*)getNameOfFramesFromPlist:(NSString*)name{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:name];
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathForFilename:name];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary* nameDict=[dict valueForKey:@"frames"];
    NSArray* sortedArray= [nameDict.allKeys sortedArrayUsingSelector:@selector(localizedCompare:)];
    return sortedArray;
}
-(CCAnimation* )animationByPlist:(NSString*)name withDelay:(float)delay{
    if (!delay) {
        delay=.1;
    }
    NSArray* sortedArray=[self getNameOfFramesFromPlist:name];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png",[name substringToIndex:name.length-6]]];
    [self addChild:batchNode];
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (NSString* name in sortedArray) {
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:delay];
    return animation;
}

-(void)updateCollisionObjectArray{

    [self.collisionObjectArray removeAllObjects];
    for (AiObject* obj in self.allObjectsArray) {
        if(obj==self)continue;
        CGRect selfRect=[self getBoundingBox];
        
        CGRect objRect=[(id)obj getBoundingBox];
        
        
        if ([Global rectInsect:objRect :selfRect]) {
            [self.collisionObjectArray addObject:obj];
        }
//        if (CGRectIntersectsRect([(id)obj getBoundingBox],[self getBoundingBox])) {
//            [self.collisionObjectArray addObject:obj];
//        }
    }
}
-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position{
    NSMutableArray* ret=[NSMutableArray arrayWithArray:self.allObjectsArray];

    
    for(int i=ret.count-1;i>0;i--){
        for(int j=0;j<i;j++){
            CGPoint pos1=[ret[j] getCenterPoint] ;
            CGPoint pos2=[ret[j+1] getCenterPoint];
            
            float distance1 = abs(ccpDistance(position, pos1));
            float distance2 = abs(ccpDistance(position, pos2));
            if (distance1>distance2) {
                [ret exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return ret;
    
}


-(void)handleCollision{
    //NSLog(@"in the collisionHandler");
}
-(void)hurtByObject:(AiObject*)obj{
    
}
-(CGRect)getBoundingBox{
    return self.sprite?self.sprite.boundingBox:CGRectZero;
}
-(CGPoint)getCenterPoint{
    CGRect rect =[self getBoundingBox];
    float x=rect.origin.x+rect.size.width/2;
    float y=rect.origin.y+rect.size.height/2;
    return ccp(x,y);
}

-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
    [self setTimeOutWithDelay:timeOut withSelector:@selector(update)];
    
}
-(void)setTimeOutWithDelay:(float)timeOut withBlock:(void(^)())block{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallBlock actionWithBlock:block],
      nil]];
}
-(void)setTimeOutWithDelay:(float)timeOut withSelector:(SEL)selector{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:selector],
      nil]];
    
}



-(void)magicAttackWithName:(NSString *)magicName{
    [self magicAttackWithName:magicName withParameter:nil];
}
-(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{
}
-(void)addLifeBar{
    //init LifeBar
    float width=[[self.attributeDict valueForKey:@"lifeBarWidth"] floatValue];
    float height=[[self.attributeDict valueForKey:@"lifeBarHeight"] floatValue];

    
    self.lifeBar=[CCSprite spriteWithFile:@"lifeBar.png" ];
    self.lifeBar.anchorPoint=ccp(0,0);
    self.lifeBar.scaleX=width/self.lifeBar.contentSize.width;
    self.lifeBar.scaleY=height/self.lifeBar.contentSize.height;
    self.lifeBar.visible=NO;
    
    [self addChild:self.lifeBar];
    
    self.lifeBarBorder=[CCSprite spriteWithFile:@"border.png"];
    self.lifeBarBorder.anchorPoint=ccp(0,0);
    self.lifeBarBorder.scaleX=width/self.lifeBarBorder.contentSize.width;
    self.lifeBarBorder.scaleY=height/self.lifeBarBorder.contentSize.height;
    self.lifeBarBorder.visible=NO;
    
    [self addChild:self.lifeBarBorder];
    
    
    
}
-(void)updateLifeBar{
    self.lifeBar.visible=YES;
    self.lifeBarBorder.visible=YES;
    
    float marginHead=[[self.attributeDict valueForKey:@"lifeBarMarginHead"] floatValue];
    if(!marginHead)marginHead=5;
    
    float width=[[self.attributeDict valueForKey:@"lifeBarWidth"] floatValue];
    //float height=[[self.attributeDict valueForKey:@"top"] floatValue];
    if(self.curHP<0) self.curHP=0;
    
    //updatePosition
    CGRect rect=[self getBoundingBox];
    
    self.lifeBar.position=ccp(self.sprite.position.x-10,self.sprite.position.y+rect.size.height+marginHead);
    self.lifeBarBorder.position=self.lifeBar.position;
    
    self.lifeBar.scaleX=self.curHP/self.maxHP*width/self.lifeBar.contentSize.width;
    
}
-(void)draw{
    if(self.showBoundingBox){
        ccDrawColor4B(255, 0, 0,0);
        glLineWidth(4);
        CGRect rect=[self getBoundingBox];
//        if (self.node.anchorPoint.x==0.5){
//            ccDrawRect(CGPointMake(rect.origin.x-rect.size.width/2, rect.origin.y-rect.size.height/2), CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2));
//        }
        if (YES){
         ccDrawRect(rect.origin, CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height));
        }         
    }
}
-(void)updateForCommon{
    float delayTime=self.delayTime;
    
    if(self.autoUpdateCollision){
        [self updateCollisionObjectArray];
        if(self.collisionObjectArray.count>0){
            [self handleCollision];
        }
    }


     if(self.lifeBar){[self updateLifeBar];};
    
    
    [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
}


@end
