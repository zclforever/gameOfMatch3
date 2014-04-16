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
    
    self.name=@"buff_fury"; //name 要先加 用来初始化attributeDatabase
    [super makeBuff];
    
}
-(void)start{
    AiObjectWithMagic* owner=self.buffHelper.owner;
    owner.curEnergy+=100;
    owner.curHP+=1000;
    [super start];
}

@end
