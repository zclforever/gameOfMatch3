//
//  ProjectileWithNoTarget.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-8.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileWithNoTarget.h"


@implementation ProjectileWithNoTarget
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self=[super initWithAllObjectArray:allObjectsArray withPostion:pos byName:name];
    return self;
}



-(bool)onReadyToAttackTargetInRange{
    self.wantedObject=self.collisionObjectsInAttankRange[0];

    [self.wantedObject hurtByObject:self];
    [self dieAction];

    return YES;

}

@end
