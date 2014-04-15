//
//  BuffFury.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-4-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BuffFury.h"
#import "BuffHelper.h"
#import "AiObjectWithMagic.h"

@implementation BuffFury
-(void)onTimeExpire{
    AiObject* owner=self.buffHelper.owner;
    owner.curEnergy-=100;
    [super onTimeExpire];
}
-(void)makeBuff{
    
    self.name=@"buff_slow";
    self.liveTime=10.0;
 
    self.damage=[[Attribute alloc]init];
    self.damage.value=0;
    self.damage.addition=100;
    self.damage.percentage=0;
    
    [super makeBuff];
    //[self.sprite runAction:[CCTintTo actionWithDuration:3 red:160 green:160 blue:255]];
    //[super start];
    
}
-(void)start{
    AiObjectWithMagic* owner=self.buffHelper.owner;
    owner.curEnergy+=100;
    owner.curHP+=1000;
    [super start];
}
-(void)recalcAttributeToOwner{
    AiObject* owner=self.buffHelper.owner;
    owner.damage.value+=self.damage.value;
    owner.damage.addition+=self.damage.addition;
    owner.damage.percentage+=self.damage.percentage;
    
    owner.attackCD.addition+=-1.5;
}
@end
