//
//  ProjectileWithNoTarget.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-8.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ProjectileAiWithNoTarget.h"


@implementation ProjectileAiWithNoTarget
-(id)initWithOwner:(Projectile*)obj{
    self=[super initWithOwner:obj];

    return self;
}


-(bool)onReadyToAttackTargetInRange{
    AiObject* obj=self.projectile.findTargetsResult[@"attackRadius"][0];
    [self.projectile directAttackTarget:obj];
    self.die=YES;

    return YES;

}
-(void)onFindNothing{
    if (self.projectile) {
        self.projectile.node.position=[self.projectile.owner getCenterPoint];
    }
}
-(void)onInSightButNotInAttackRange{
    AiObject* obj=self.projectile.findTargetsResult[@"sightRadius"][0];
    [self.projectile moveToPosition:[obj getCenterPoint]];
}

-(bool)checkDie{
    return self.die?YES:NO;
}

@end
