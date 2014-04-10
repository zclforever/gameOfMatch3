//
//  BuffSlow.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-29.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BuffSlow.h"
#import "BuffHelper.h"
#import "AiObject.h"

@implementation BuffSlow

-(void)onTimeExpire{
    AiObject* owner=self.buffHelper.owner;
    [owner.node runAction:[[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0] reverse]];
    [super onTimeExpire];
}
-(void)makeBuff{
    AiObject* owner=self.buffHelper.owner;
    self.liveTime=10.0;
    self.moveSpeed=[[Attribute alloc]init];
    self.moveSpeed.value=0;
    self.moveSpeed.addition=0;
    self.moveSpeed.percentage=-0.5;
    
    [owner.node runAction:[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0]];
    
    
    //[self.sprite runAction:[CCTintTo actionWithDuration:3 red:160 green:160 blue:255]];
    [super start];
    
}
-(void)recalcAttributeToOwner{
    AiObject* owner=self.buffHelper.owner;
    owner.moveSpeed.value+=self.moveSpeed.value;
    owner.moveSpeed.addition+=self.moveSpeed.addition;
    owner.moveSpeed.percentage+=self.moveSpeed.percentage;
}
@end
