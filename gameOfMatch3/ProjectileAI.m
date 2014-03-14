//
//  ProjectileAI.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileAI.h"


@implementation ProjectileAI

-(id)initWithOwner:(Projectile*)obj{
    self=[super init];
    self.projectile=obj;
    return self;
}

-(void)onEnterFrame{

}

-(void)onFindTargets{

}
-(void)onFindNothing{

}
-(void)onNothingToDo{

}


-(void)onInAttackRange{
    //[self.projectile.superclass onInAttackRange];  //因为 aiobject 有一段cd控制 爆出事件 onReadyToattackTargetInRange 否则要重写
}

-(bool)onReadyToAttackTargetInRange{
    return NO;

}
-(void)onNotReadyToAttackTargetInRange{

}

-(void)onInSightButNotInAttackRange{
    
}


@end
