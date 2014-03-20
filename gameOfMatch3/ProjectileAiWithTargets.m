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

-(bool)checkDie{
    return self.targetsArray.count<=0?YES:NO;

}

-(bool)onReadyToAttackTargetInRange{

    for (AiObject* target in self.targetsArray) {
        if (![self.projectile.findTargetsResult[@"attackRadius"] containsObject:target]) {
            continue;
        }
        if ([self.projectile directAttackTarget:target]) {
            [self.projectile onDie];
            
            return YES;
        }else return NO;
    }


    return NO;
}

@end
