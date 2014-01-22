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
@property float speedX;
@property float speedY;
@property bool attackOnce;
@property bool attackPostionIgnoreX;
@property bool attackPostionIgnoreY;
@property (strong,nonatomic) NSMutableArray* attackedObjectsArray;
@property (strong,nonatomic) NSString* hitSound;
@end

@implementation Projectile
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.autoUpdateCollision=NO;
        
        self.objectName=name;
        Magic* magic=[[Magic alloc]initWithName:name];
        self.damage=magic.damage;
        self.moveSpeed=250.0f;
        self.speedX=self.moveSpeed;
        self.speedY=self.moveSpeed;
        self.attackRange=CGSizeMake(0, 20);
        self.attackOnce=NO;
        
        self.attackedObjectsArray=[[NSMutableArray alloc]init];
        
        self.accelerometerEnabled = NO;

        
       
        if ([name isEqualToString:@"snowBall"]) {
            CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"snowBall.plist"];
            CCParticleSystem* fire=particle_system;
            self.speedX=0.0f;
            self.speedY=40.0f;
            self.anchorPoint=ccp(0,0);
            self.particle=fire;
            fire.position=pos;
            fire.startSize=36;
            fire.scale=.4;
            fire.speed=0;
            fire.duration=-1;
            self.attackRange=CGSizeMake(100, 50);
            self.attackCD=1.0f;
            self.accelerometerEnabled=YES;
            
        }
        

        
        
        if ([name isEqualToString:@"fireBall"]) {
            
            
            CCParticleFire *fire = [[CCParticleFire alloc]init];
            self.particle=fire;
            
            fire.anchorPoint=ccp(0,0);
            int randomVar=(arc4random()%60-30);
            randomVar=0;
            fire.position=pos;
            fire.startSize=81;
            fire.scale=.2;
            fire.rotation=-22.5;
            fire.duration=-1.0f;
            fire.gravity=ccp(-90,-45);
            self.hitSound=@"heavyHit.wav";
             
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
            self.attackOnce=YES;
            self.attackRange=CGSizeMake(0, 10);
            self.hitSound=@"softHit.wav";
        }
        
        if ([name isEqualToString:@"bigFireBall"]) {
            CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"bigFireBall.plist"];
            CCParticleSystem* fire=particle_system;
            self.moveSpeed=100.0f;
            fire.blendFunc= (ccBlendFunc) {GL_SRC_ALPHA,GL_DST_ALPHA};
            self.particle=fire;
            fire.position=pos;

            self.attackOnce=YES;
            self.attackRange=CGSizeMake(100, 20);
            self.hitSound=@"explosion02.mp3";
    
            
        }
        
        
        self.particle.visible=NO;
        
        
        
        [self addChild:self.particle z:5];
        
        self.node=self.particle;
        
        if (self.accelerometerEnabled) {
            [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
            [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        }
        
        [self update];
    }
    return self;
    
}
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        CCLOG(@"zcl shake");
        
    }

    self.node.position=ccp(self.node.position.x+acceleration.x*8,self.node.position.y);


}
-(CGRect)getBoundingBox{
    if (self.particle) {
        CGRect selfRect=self.particle.boundingBox;
        selfRect.size=self.attackRange;
        
        return CGRectMake(selfRect.origin.x-self.attackRange.width/2, selfRect.origin.y-self.attackRange.height/2, self.attackRange.width, self.attackRange.height);
    }else return CGRectZero;

}
-(void)attackPosition:(CGPoint)position{

    self.attackPostionIgnoreX=!position.x;
    self.attackPostionIgnoreY=!position.y;
    
    self.attackingPostion=YES;
    self.particle.visible=YES;
    self.moveDestPosition=position;
    self.moving=YES;
    
}
-(void)attackNearest{
    self.particle.visible=YES;
    self.attackingNearest=YES;
}
-(void)move{  //self.moveDestPosition;
    if (!self.moving) {
        return;
    }

    CGPoint pos=self.moveDestPosition;
    CGPoint position=self.particle.position;
    float moveDistanceX=self.speedX*self.delayTime;
    float moveDistanceY=self.speedY*self.delayTime;
    float xDistance=pos.x-position.x;
    float yDistance=pos.y-position.y;
    float xMoveDistance=xDistance>0?moveDistanceX:-moveDistanceX;
    float yMoveDistance=yDistance>0?moveDistanceY:-moveDistanceY;
    
    if (abs(xDistance)>abs(yDistance)){yMoveDistance/=abs(xDistance/yDistance);}
    else{ xMoveDistance/=abs(yDistance/xDistance);   }

    self.particle.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
    
    float destMinDistance=max(moveDistanceX,3);
    if(
       (abs(xDistance)<destMinDistance||self.speedX==0)&&
       (abs(yDistance)<destMinDistance||self.speedY==0)
       ){
        self.atDest=YES;
    }
    
}
-(void)updateCollisionObjectArray{  //collision.coll.
    
    [self.collisionObjectArray removeAllObjects];
    for (AiObject* obj in self.allObjectsArray) {
        if(obj==self)continue;
        CGRect selfRect=[self getBoundingBox];
       
        CGRect objRect=[(id)obj getBoundingBox];


        if ([Global rectInsect:objRect :selfRect]) {
            [self.collisionObjectArray addObject:obj];
        }
    }
}
-(void)update{
    self.delayTime=0.04;
    
    NSArray* allAttackTargets=[[Global sharedManager] allEnemys];
    //-------------攻击某个位置
    float attackPastTime=[[Global sharedManager]gameTime]-self.lastAttackTime;
    
    if(self.attackingPostion&&self.particle){

        if (self.attackPostionIgnoreX) self.moveDestPosition=ccp(self.node.position.x,self.moveDestPosition.y);
        if(self.attackPostionIgnoreY) self.moveDestPosition=ccp(self.moveDestPosition.x,self.node.position.y);
        
        if(!self.moving){
            self.moving=YES;
        }
        [self move];
        
        
        //------------攻击cd到后 允许攻击 并检测碰撞 
        if (attackPastTime>=self.attackCD) {
            [self updateCollisionObjectArray];
            for (AiObject* collisionObj in self.collisionObjectArray) {
                if(self.attackOnce){
                    if ([self.attackedObjectsArray containsObject:collisionObj]) {
                        continue;
                    }
                }
                
                if (![allAttackTargets containsObject:collisionObj.objectName]) {
                    continue;
                }
                if (!collisionObj.alive) {
                    continue;
                }
                self.lastAttackTime=[[Global sharedManager] gameTime];
                
                //hitsound
                if(self.hitSound){[[SimpleAudioEngine sharedEngine]playEffect:self.hitSound];}
                    
                [collisionObj hurtByObject:self];
                if(self.attackOnce){[self.attackedObjectsArray addObject:collisionObj];}
                
            }
        }

        
        if (self.atDest) {
            self.attackingPostion=NO;
            self.alive=NO;
            [self.allObjectsArray removeObject:self];
            [self removeFromParentAndCleanup:YES];
            return;

        }
        
        
    }
    
     //------------------攻击最近目标   
    if (self.attackingNearest&&self.particle) {
        
        CGPoint position=self.particle.position;
        NSArray* nearestArray=[self sortAllObjectsByDistanceFromPosition:position];
        AiObject* nearestObj;
        for (AiObject* obj in nearestArray) {
            
            if (obj==self||![allAttackTargets containsObject:obj.objectName]) {
                continue;
            }
            if (obj.alive) {
                nearestObj=obj;
                break;
            }
        }
        //-----------找不到目标就销毁
        if (!nearestObj) {
            self.attackingNearest=NO;
            self.alive=NO;
            [self.allObjectsArray removeObject:self];
            [self removeFromParentAndCleanup:YES];
            return;
        }
        //------------找到最近目标
        if (nearestObj) {
            CGRect rect=[nearestObj getBoundingBox];
            CGPoint pos=rect.origin;
            pos.x+=rect.size.width/2;
            pos.y+=rect.size.height/2;
            self.moveDestPosition=pos;
            if(!self.moving){
                self.moving=YES;

            }
            [self move];
            
            [self updateCollisionObjectArray];
            for (AiObject* collisionObj in self.collisionObjectArray) {
                if(collisionObj==nearestObj){
                    self.moving=NO;
                    int enemyCurHP=nearestObj.curHP;

                    //hitSound
                    if(self.hitSound){[[SimpleAudioEngine sharedEngine]playEffect:self.hitSound];}
                    
                    [nearestObj hurtByObject:self];
                    
                    if(self.damage<=enemyCurHP||[nearestObj.objectName isEqualToString:@"bossEnemy"]){
                        
                        self.attackingNearest=NO;
                        self.alive=NO;
                        [self.allObjectsArray removeObject:self];
                        [self removeFromParentAndCleanup:YES];
                        return;
                    }
                    else{
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
        
    }
    
    //----------------------------------
    [self setTimeOutOfUpdateWithDelay:self.delayTime];
}


@end
