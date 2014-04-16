//
//  IceBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "IceBall.h"
#import "AiObjectWithMagic.h"

@implementation IceBall
-(void)makeNode{
    CCParticleSystem* node = [CCParticleSystemQuad particleWithFile:@"iceBall.plist"];
    node.startSize=36;
    node.scale=.6;
    node.speed=100;
    node.duration=-1;
    self.hitSound=@"softHit.wav";
    self.node=node;
}
-(void)onDirectAttatckTarget:(id)target{
        AiObjectWithMagic* obj=target;
        Buff* buff=[[BuffSlow alloc]initWithBuffHelper:obj.buffHelper];
        [buff add];

        obj.node.position=ccp(obj.node.position.x+100,obj.node.position.y);
}
@end
