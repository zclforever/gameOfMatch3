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

-(bool)checkDie{
    return   self.projectile.atDest?YES:NO;

}
-(void)onEnterFrame{
    [super onEnterFrame];
    [self.projectile moveToPosition:self.destPostion];
    

}


-(bool)onReadyToAttackTargetInRange{
    for (AiObject* target in self.projectile.findTargetsResult[@"attackRadius"]) {
        [self.projectile directAttackTarget:target];
    }

    return YES;
}
@end
