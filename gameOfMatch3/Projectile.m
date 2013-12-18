//
//  Projectile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Projectile.h"
#import "Magic.h"
@interface Projectile()
@property int count;
@end

@implementation Projectile
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=name;
        Magic* magic=[[Magic alloc]initWithName:name];
        self.damage=magic.damage;
        self.moveSpeed=250.0f;
        
        if ([name isEqualToString:@"fireBall"]) {
            
            
            CCParticleFire *fire = [[CCParticleFire alloc]init];
            self.particle=fire;
            
            //fire.anchorPoint=ccp(0,0);
            int randomVar=(arc4random()%60-30);
            randomVar=0;
            fire.position=pos;
            fire.startSize=81;
            fire.scale=.2;
            fire.rotation=-22.5;
            fire.duration=-1.0f;
            fire.gravity=ccp(-90,-45);
           
        }
        if ([name isEqualToString:@"iceBall"]) {
            CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"iceBall.plist"];
            CCParticleSystem* fire=particle_system;
            self.particle=fire;
            fire.position=pos;
            fire.startSize=36;
            fire.scale=.6;
            fire.speed=100;
            fire.duration=-1;
        }
        self.particle.visible=NO;
        [self addChild:self.particle];
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
    self.delayTime=0.04;
    
    //------------------攻击最近目标
    if (self.attackingNearest&&self.particle) {
        
        CGPoint position=self.particle.position;
        NSArray* nearestArray=[self sortAllObjectsByDistanceFromPosition:position];
        AiObject* nearestObj;
        for (AiObject* obj in nearestArray) {
            
            if (obj==self||![[NSArray arrayWithObjects:@"smallEnemy",@"bossEnemy", nil] containsObject:obj.objectName]) {
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
            pos.x+=rect.size.width/2;
            pos.y+=rect.size.height/2;
            float moveDistance=self.moveSpeed*self.delayTime;
            float xDistance=pos.x-position.x;
            float yDistance=pos.y-position.y;
            float xMoveDistance=xDistance>0?moveDistance:-moveDistance;
            float yMoveDistance=yDistance>0?moveDistance:-moveDistance;
            
            
            xMoveDistance=abs(xDistance)<moveDistance?xDistance:xMoveDistance;
            yMoveDistance=abs(yDistance)<moveDistance?yDistance:yMoveDistance;
            if (abs(xDistance)>abs(yDistance)){yMoveDistance/=abs(xDistance/yDistance);}
            else{ xMoveDistance/=abs(yDistance/xDistance);   }
            
            self.particle.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
            
            if ((abs(xDistance)<moveDistance)&&(abs(yDistance)<moveDistance)) {
                int enemyCurHP=nearestObj.curHP;
                [nearestObj hurtByObject:self];
                
                if(self.damage<=enemyCurHP){
                                
                                 self.attackingNearest=NO;
                                 self.alive=NO;
                                 [self removeFromParentAndCleanup:YES];
                                    return;
                }else{
                    
                    __block Projectile* obj=self;
                    [self setTimeOutWithDelay:self.delayTime withBlock:^{
                        obj.damage-=enemyCurHP;
                        [obj update];
                    }];
                }
                
                return;
            }
           
        }
        
    }
    
    //----------------------------------
    [self setTimeOutOfUpdateWithDelay:self.delayTime];
}

@end
