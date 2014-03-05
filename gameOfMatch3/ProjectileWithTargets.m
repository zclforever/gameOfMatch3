//
//  FireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileWithTargets.h"


@implementation ProjectileWithTargets
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos withTargets:(NSArray*)targetsArray byName:(NSString*)name{
    self=[super initWithAllObjectArray:allObjectsArray withPostion:pos byName:name];
    self.targetsArray=targetsArray;
    return self;
}

-(void)onEnterFrame{
    if (self.targetsArray.count<=0) {
        [self dieAction];
        return ;
    }
    self.wantedObject=self.targetsArray[0];
    [self moveToPosition:[self.wantedObject getCenterPoint] ];
}


-(bool)onReadyToAttackTargetInRange{
    self.wantedObject=self.targetsArray[0];
    if (![self.collisionObjectsInAttankRange containsObject:self.wantedObject]) {
        return NO;
    }
    [self.wantedObject hurtByObject:self];
    [self dieAction];
    return YES;
}

@end
