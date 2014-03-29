//
//  BuffSlow.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-29.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BuffSlow.h"
#import "BuffHelper.h"

@implementation BuffSlow

-(void)onTimeExpire{
    [self.buffHelper.owner.node runAction:[[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0] reverse]];
    [super onTimeExpire];
}
-(void)makeBuff{
    self.state[@"moveSpeed"]=@{@"p": @0.5,@"n":@0};
    self.liveTime=10.0;
    [self.buffHelper.owner.node runAction:[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0]];
    
    
    //[self.sprite runAction:[CCTintTo actionWithDuration:3 red:160 green:160 blue:255]];
    [super start];
    
}
@end
