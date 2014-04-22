//
//  ProjectileAI.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiBehavior.h"


@implementation AiBehavior

-(id)initWithOwner:(Projectile*)obj{
    self=[super init];
    self.projectile=obj;
    return self;
}

-(void)onEnterFrame{
    
}

@end



@implementation AiLinearMoveToPosition

-(void)onEnterFrame{
    
}

@end


@implementation AiInstantRangeAttack

-(void)onEnterFrame{
    
}

@end