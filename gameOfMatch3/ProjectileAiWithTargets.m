//
//  FireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileAiWithTargets.h"


@implementation ProjectileAiWithTargets
-(id)initWithTargets:(NSArray*)targetsArray  withOwner:(Projectile*)obj{
    self=[super initWithOwner:obj];
    self.targetsArray=targetsArray;
    return self;
}


-(void)onFindNothing{
    AiObject* obj=self.targetsArray[0];
    [self.projectile moveToPosition:[obj getCenterPoint] ];
}
-(void)onEnterFrame{
    if (self.targetsArray.count<=0) {
        [self.projectile dieAction];
        return ;
    }
}


-(bool)onReadyToAttackTargetInRange{

    for (AiObject* target in self.targetsArray) {
        if (![self.projectile.findTargetsResult[@"attackRadius"] containsObject:target]) {
            continue;
        }
        [target hurtByObject:self.projectile];
        [self.projectile dieAction];

        return YES;
    }


    return NO;
}

@end
