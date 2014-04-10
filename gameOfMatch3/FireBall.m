//
//  FireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "FireBall.h"


@implementation FireBall


-(void)makeNode{
               
    CCParticleFire *node = [[CCParticleFire alloc]init];
    node.anchorPoint=ccp(0,0);
    int randomVar=(arc4random()%60-30);
    randomVar=0;
    node.startSize=81;
    node.scale=.2;
    node.rotation=-22.5;
    node.duration=-1.0f;
    node.gravity=ccp(-90,-45);
    
    self.hitSound=@"heavyHit.wav";
    self.moveSpeed=[Attribute initWithValue:80.0f];
    
    self.node=node;

}

@end
