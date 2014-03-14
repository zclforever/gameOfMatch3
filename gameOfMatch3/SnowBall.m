//
//  SnowBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "SnowBall.h"


@implementation SnowBall
-(void)makeNode{
    CCParticleSystem* node = [CCParticleSystemQuad particleWithFile:@"snowBall.plist"];

    self.moveSpeed=40.0f;
    node.anchorPoint=ccp(0,0);
    node.startSize=36;
    node.scale=.4;
    node.speed=0;
    node.duration=-1;
    
    self.accelerometerEnabled=YES;
    
    self.node=node;
}
@end
