//
//  FireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileWithTargetPosition.h"


@implementation ProjectileWithTargetPosition
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos  withDestPosition:(CGPoint)destPosition  byName:(NSString*)name{
    self=[super initWithAllObjectArray:allObjectsArray withPostion:pos byName:name];
    self.destPostion=destPosition;
    return self;
}

-(void)onEnterFrame{
    
    [self moveToPosition:self.destPostion];
    
    if (self.atDest) {
        [self dieAction];
        return;
    }
}


-(bool)onReadyToAttackTargetInRange{
    for (AiObject* target in self.collisionObjectsInAttankRange) {
        [target hurtByObject:self];
    }
    

    return YES;
}
@end
