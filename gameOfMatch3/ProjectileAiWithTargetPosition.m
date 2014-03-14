//
//  FireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileAiWithTargetPosition.h"


@implementation ProjectileAiWithTargetPosition
-(id)initWithDestPosition:(CGPoint)destPosition  withOwner:(Projectile*)obj{
    self=[super initWithOwner:obj];
    self.destPostion=destPosition;
    return self;
}

-(void)onEnterFrame{
    
    [self.projectile moveToPosition:self.destPostion];
    
    if (self.projectile.atDest) {
        [self.projectile dieAction];
        return;
    }
}


-(bool)onReadyToAttackTargetInRange{
    for (AiObject* target in self.projectile.findTargetsResult[@"attackRadius"]) {
        [target hurtByObject:self.projectile];
    }

    return YES;
}
@end
