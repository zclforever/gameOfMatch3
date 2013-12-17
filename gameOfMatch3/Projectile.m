//
//  Projectile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Projectile.h"
@interface Projectile()
@property int count;
@end

@implementation Projectile
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=name;
        
        if ([name isEqualToString:@"fireBall"]) {
            self.count=3;
            self.moveSpeed=65.0f;
            
            CCParticleFire *fire = [[CCParticleFire alloc]init];
            self.particle=fire;
            //fire.anchorPoint=ccp(0,0);
            int randomVar=(arc4random()%60-30);
            randomVar=0;
            fire.position=pos;
            fire.startSize=81;
            fire.scale=.2;
            //fire.rotation=-45;
            fire.duration=-1.0f;
            fire.gravity=ccp(-90,-45);
            fire.visible=NO;
            [self addChild:fire];
            
           
        }
        
        
        [self update];
    }
    return self;
    
}

-(CGRect)getBoundingBox{
    return self.particle?self.particle.boundingBox:CGRectZero;
}
-(void)attackNearest{
    self.particle.visible=YES;
    self.attackingNearest=YES;
}
-(void)update{
    
    
    //------------------攻击最近目标
    if (self.attackingNearest&&self.particle) {
        
        CGPoint position=self.particle.position;
        NSArray* nearestArray=[self sortAllObjectsByDistanceFromPosition:position];
        AiObject* nearestObj;
        for (AiObject* obj in nearestArray) {
            if (obj==self||[obj.objectName isEqualToString:@"player"]) {
                continue;
            }
            if (obj.alive) {
                nearestObj=obj;
                break;
            }
        }

        if (nearestObj) {
            CGRect rect=[nearestObj getBoundingBox];
            CGPoint pos=rect.origin;
            pos.y+=rect.size.height/2;
            float moveDistance=self.moveSpeed*self.delayTime;
            float xDistance=pos.x>position.x?moveDistance:-moveDistance;
            float yDistance=pos.y>position.y?moveDistance:-moveDistance;
            
            xDistance=abs(position.x-pos.x)<3?0:xDistance;
            yDistance=abs(position.y-pos.y)<3?0:yDistance;
            if (xDistance==yDistance&&xDistance==0) {
                
                
                
                [nearestObj hurtByObject:self];
                self.count--;
                
                if(self.count<0){
                                 self.attackingNearest=NO;
                                 self.alive=NO;
                                 [self removeFromParentAndCleanup:YES];
                }
                [self setTimeOutOfUpdateWithDelay:.1];
            }
            self.particle.position=ccp( position.x+xDistance,position.y+yDistance);
        }
        
    }
    
    //----------------------------------
    [self setTimeOutOfUpdateWithDelay:self.delayTime];
}

@end
