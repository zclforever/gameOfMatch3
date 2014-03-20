//
//  TransparentProjectile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-20.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "PhysicalAttack.h"


@implementation PhysicalAttack
-(void)makeNode{
    CCSprite* node=[CCSprite spriteWithFile:@"transparent.png"];
    
    self.moveSpeed=100.0f;
    node.visible=NO; 
    self.node=node;
}
@end
