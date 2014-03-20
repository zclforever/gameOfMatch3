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


@end

@implementation Projectile
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray withName:name];
    if (self) {

        
        self.objectName=name;
        [self makeNode];
        self.node.position=pos;
        [self addChild:self.node z:5];
        
        [self.findTargetsDelegate addObserverWithType:@"sightRadius"];
        
        self.attackedObjectsArray=[[NSMutableArray alloc]init];
        
        Magic* magic=[[Magic alloc]initWithName:name];
        self.damage=magic.damage;
        self.moveSpeed=250.0f;

       
       
        self.accelerometerEnabled = NO;


      
        //self.particle.visible=NO;

        
        if (self.accelerometerEnabled) {
            [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
            [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        }
        
        //[self update];
    }
    return self;
    
}
-(void)makeNode{
    
}

-(void)setAiDelegate:(id<ProjectileAiDelegate>)aiDelegate{
    _aiDelegate=aiDelegate;
}

-(void)initFromPlist{
   
    [super initFromPlist];
    //self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];
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
-(bool)directAttackTarget:(AiObject *)obj{
    if ([self.attackedObjectsArray containsObject:obj]) {  //攻击一次
        return NO;
    }
    
    [self.attackedObjectsArray addObject:obj];
    
    return [super directAttackTarget:obj];
}
-(bool)checkDie{
    return [self.aiDelegate checkDie];
}
-(void)onDie{
    [self dieAction];
}

-(void)dieAction{
    self.alive=NO;
    self.readyToEnd=YES;
    [self.allObjectsArray removeObject:self];
    [self removeFromParentAndCleanup:YES];
}


//delegate
-(void)onEnterFrame{
    [self.aiDelegate onEnterFrame];
}

-(void)onFindTargets{
    [self.aiDelegate onFindTargets];
}
-(void)onFindNothing{
    [self.aiDelegate onFindNothing];
}
-(void)onNothingToDo{
    [self.aiDelegate onNothingToDo];
}


-(void)onInAttackRange{
    [super onInAttackRange];
    [self.aiDelegate onInAttackRange];
}

-(bool)onReadyToAttackTargetInRange{

    return [self.aiDelegate onReadyToAttackTargetInRange];
}
-(void)onNotReadyToAttackTargetInRange{
    [self.aiDelegate onNotReadyToAttackTargetInRange];
}

-(void)onInSightButNotInAttackRange{
    [self.aiDelegate onInSightButNotInAttackRange];
}





//-(void)move{  //self.moveDestPosition;
//    if (!self.moving) {
//        return;
//    }
//
//    CGPoint pos=self.moveDestPosition;
//    CGPoint position=self.particle.position;
//    float moveDistanceX=self.speedX*self.delayTime;
//    float moveDistanceY=self.speedY*self.delayTime;
//    float xDistance=pos.x-position.x;
//    float yDistance=pos.y-position.y;
//    float xMoveDistance=xDistance>0?moveDistanceX:-moveDistanceX;
//    float yMoveDistance=yDistance>0?moveDistanceY:-moveDistanceY;
//    
//    if (abs(xDistance)>abs(yDistance)){yMoveDistance/=abs(xDistance/yDistance);}
//    else{ xMoveDistance/=abs(yDistance/xDistance);   }
//
//    self.particle.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
//    
//    float destMinDistance=max(moveDistanceX,3);
//    if(
//       (abs(xDistance)<destMinDistance||self.speedX==0)&&
//       (abs(yDistance)<destMinDistance||self.speedY==0)
//       ){
//        self.atDest=YES;
//    }
//    
//}

//-(void)update{
//    self.delayTime=0.04;
//    
//    NSArray* allAttackTargets=[[Global sharedManager] allEnemys];
//    //-------------攻击某个位置
//    float attackPastTime=[[Global sharedManager]gameTime]-self.lastAttackTime;
//    
//    if(self.attackingPostion&&self.particle){
//
//        if (self.attackPostionIgnoreX) self.moveDestPosition=ccp(self.node.position.x,self.moveDestPosition.y);
//        if(self.attackPostionIgnoreY) self.moveDestPosition=ccp(self.moveDestPosition.x,self.node.position.y);
//        
//        if(!self.moving){
//            self.moving=YES;
//        }
//        [self move];
//        
//        
//        //------------攻击cd到后 允许攻击 并检测碰撞 
//        if (attackPastTime>=self.attackCD) {
//            [self updateCollisionObjectArray];
//            for (AiObject* collisionObj in self.collisionObjects) {
//                if(self.attackOnce){
//                    if ([self.attackedObjectsArray containsObject:collisionObj]) {
//                        continue;
//                    }
//                }
//                
//                if (![allAttackTargets containsObject:collisionObj.objectName]) {
//                    continue;
//                }
//                if (!collisionObj.alive) {
//                    continue;
//                }
//                self.lastAttackTime=[[Global sharedManager] gameTime];
//                
//                //hitsound
//                if(self.hitSound){[[SimpleAudioEngine sharedEngine]playEffect:self.hitSound];}
//                    
//                [collisionObj hurtByObject:self];
//                if(self.attackOnce){[self.attackedObjectsArray addObject:collisionObj];}
//                
//            }
//        }
//
//        
//        if (self.atDest) {
//            self.attackingPostion=NO;
//            self.alive=NO;
//            [self.allObjectsArray removeObject:self];
//            [self removeFromParentAndCleanup:YES];
//            return;
//
//        }
//        
//        
//    }
//    
//     //------------------攻击最近目标   
//    if (self.attackingNearest&&self.particle) {
//        
//        CGPoint position=self.particle.position;
//        NSArray* nearestArray=[self sortAllObjectsByDistanceFromPosition:position];
//        AiObject* nearestObj;
//        for (AiObject* obj in nearestArray) {
//            
//            if (obj==self||![allAttackTargets containsObject:obj.objectName]) {
//                continue;
//            }
//            if (obj.alive) {
//                nearestObj=obj;
//                break;
//            }
//        }
//        //-----------找不到目标就销毁
//        if (!nearestObj) {
//            self.attackingNearest=NO;
//            self.alive=NO;
//            [self.allObjectsArray removeObject:self];
//            [self removeFromParentAndCleanup:YES];
//            return;
//        }
//        //------------找到最近目标
//        if (nearestObj) {
//            CGRect rect=[nearestObj getBoundingBox];
//            CGPoint pos=rect.origin;
//            pos.x+=rect.size.width/2;
//            pos.y+=rect.size.height/2;
//            self.moveDestPosition=pos;
//            if(!self.moving){
//                self.moving=YES;
//
//            }
//            [self move];
//            
//            [self updateCollisionObjectArray];
//            for (AiObject* collisionObj in self.collisionObjects) {
//                if(collisionObj==nearestObj){
//                    self.moving=NO;
//                    int enemyCurHP=nearestObj.curHP;
//
//                    //hitSound
//                    if(self.hitSound){[[SimpleAudioEngine sharedEngine]playEffect:self.hitSound];}
//                    
//                    [nearestObj hurtByObject:self];
//                    
//                    if(self.damage<=enemyCurHP||[nearestObj.objectName isEqualToString:@"bossEnemy"]){
//                        
//                        self.attackingNearest=NO;
//                        self.alive=NO;
//                        [self.allObjectsArray removeObject:self];
//                        [self removeFromParentAndCleanup:YES];
//                        return;
//                    }
//                    else{
//                        __block Projectile* obj=self;
//                        [self setTimeOutWithDelay:self.delayTime withBlock:^{
//                            obj.damage-=enemyCurHP;
//                            [obj update];
//                        }];
//                    }
//                    
//                    return;
//                }
//            }
// 
//            
//        }
//        
//    }
//    
//    //----------------------------------
//    [self setTimeOutOfUpdateWithDelay:self.delayTime];
//}


@end
