//
//  ProjectileAI.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiBehavior.h"


@implementation AiBehavior

-(id)initWithOwner:(AiObject*)obj{
    self=[super init];
    self.owner=obj;
    self.name=@"AiBehavior";
    return self;
}
-(void)start{
    self.started=YES;
}
-(void)onEnterFrame{

}

@end


//LinearMoveToPosition
@implementation AiLinearMoveToPosition
-(id)initWithOwner:(AiObject *)obj withPosition:(CGPoint)position{
    self=[super initWithOwner:obj];
    self.destPostion=position;
    return self;
}
-(void)onEnterFrame{
    if (!self.started) {
        return;
    }
    
    if(!self.owner.node)return;
    CGPoint pos=self.destPostion;
    
    float speed=[self.owner.moveSpeed finalValue];
    
    CGPoint position=self.owner.node.position;
    
    float moveDistanceX=speed*self.owner.delayTime;
    float moveDistanceY=speed*self.owner.delayTime;
    float xDistance=pos.x-position.x;
    float yDistance=pos.y-position.y;
    float xMoveDistance=xDistance==0?0:(xDistance>0?moveDistanceX:-moveDistanceX);
    float yMoveDistance=yDistance==0?0:(yDistance>0?moveDistanceY:-moveDistanceY);
    

    bool atDest;
    
    float destMinDistance=max(moveDistanceX,3);
    if(
       (abs(xDistance)<destMinDistance)&&
       (abs(yDistance)<destMinDistance)
       ){
        atDest=YES;

    }
    
    
    self.owner.node.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
    

    if (atDest) {

        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"position_arrived"
         object:self.owner
         userInfo:@{@"behaviorName":self.name}];
    }
}

@end

//InstantRangeAttack
@implementation AiInstantRangeAttack
-(id)initWithOwner:(AiObject *)obj totalHit:(int)totalHit maxHitPerEntity:(int)maxHitPerEntity{
    self=[super initWithOwner:obj];
    
    self.totalHit=totalHit;  //defaunt 0
    self.maxHitPerEntity=maxHitPerEntity;
    self.attackedTargetDict=[[NSMutableDictionary alloc]init];
    return self;
}
-(void)onEnterFrame{
    if (!self.started) {
        return;
    }
    
    NSArray* foundTargets=[self.owner findTargets];
    
    bool hit;    
    if(foundTargets.count>0){
        for (AiObject* target in foundTargets) {
            if (self.totalHit&&self.hitCount>=self.totalHit) { //hit count is attacked count
                break;
            }
            
            if (self.maxHitPerEntity&&self.maxHitPerEntity<=[self.attackedTargetDict[target.stringID] intValue]) {
                continue;
            }
            
            if([self.owner attackTarget:target]){
                hit=YES;
                self.hitCount++;
                self.attackedTargetDict[target.stringID]=@([self.attackedTargetDict[target.stringID] intValue]+1);

                
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"hit"
                 object:self.owner
                 userInfo:@{@"behaviorName":self.name}];
            }
        }
        if(hit){
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"hit finished"
             object:self.owner
             userInfo:@{@"behaviorName":self.name}];
        }
        

    }

}

@end


//DieWhen
@implementation AiDieWhen
-(id)initWithOwner:(Projectile *)obj when:(id)when{
    self=[super initWithOwner:obj];
    
    self.messageArrived=[[NSMutableDictionary alloc]init];
    self.messageArray=[[NSMutableArray alloc]init];
    
    if([when isKindOfClass:[NSString class]]){
        [self.messageArray addObject:when];
    }
    if([when isKindOfClass:[NSArray class]]){
        [self.messageArray addObjectsFromArray:when];
    }
    
    for (NSString* message in self.messageArray) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(onNotificationArrive:)
         name: message
         object:nil];
    }

    return self;
}
-(void)onNotificationArrive:(NSNotification*)sender{
    NSString* messageName=[sender name] ;
    //NSString* senderName=[sender userInfo][@"behaviorName"];
    self.messageArrived[messageName]=@YES;
}
-(void)onEnterFrame{
    if (!self.started) {
        return;
    }
    
    if(self.messageArrived.count==self.messageArray.count){
        
        [self.owner onDie];
    }
}

@end