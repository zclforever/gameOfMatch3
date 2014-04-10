//
//  BigFireBall.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BigFireBall.h"


@implementation BigFireBall


-(void)makeNode{
    CCParticleSystem* node = [CCParticleSystemQuad particleWithFile:@"bigFireBall.plist"];
    self.moveSpeed=[Attribute initWithValue:100.0f];
    node.blendFunc= (ccBlendFunc) {GL_SRC_ALPHA,GL_DST_ALPHA};

    self.hitSound=@"explosion02.mp3";
    self.node=node;
}
@end
