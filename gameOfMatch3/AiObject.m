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

-(void)updateCollisionObjectArray{

    [self.collisionObjectArray removeAllObjects];
    for (AiObject* obj in self.allObjectsArray) {
        if(obj==self)continue;
//        CGRect spriteEntityRect=[self getBoundingBox];
//        CGRect objRect=[(id)obj getBoundingBox];
        if (CGRectIntersectsRect([(id)obj getBoundingBox],[self getBoundingBox])) {
            [self.collisionObjectArray addObject:obj];
        }
    }
}
-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position{
    NSMutableArray* ret=[NSMutableArray arrayWithArray:self.allObjectsArray];

    
    for(int i=ret.count-1;i>0;i--){
        for(int j=0;j<i;j++){
            CGPoint pos1=[ret[j] getBoundingBox].origin ;
            CGPoint pos2=[ret[j+1] getBoundingBox].origin;
            
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



-(void)magicAttackByName:(NSString *)magicName{
    [self magicAttackByName:magicName withParameter:nil];
}
-(void)magicAttackByName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{
}

-(void)updateForCommon{
    float delayTime=self.delayTime;
    
    if(self.autoUpdateCollision){
        [self updateCollisionObjectArray];
        if(self.collisionObjectArray.count>0){
            [self handleCollision];
        }
    }

    
    
    
    [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
}


@end
