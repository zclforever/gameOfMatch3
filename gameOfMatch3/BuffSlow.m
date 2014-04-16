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
    self.name=@"buff_slow"; //name 要先加 用来初始化attributeDatabase
    [super makeBuff];

}
-(void)start{
    AiObject* owner=self.buffHelper.owner;
    [owner.node runAction:[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0]];
    [super start];
}

@end
