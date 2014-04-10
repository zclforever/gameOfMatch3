//
//  AiObjectWithMagic.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiObjectWithMagic.h"


@implementation AiObjectWithMagic
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name{
    self=[super initWithAllObjectArray:allObjectsArray withName:name];
    self.magicDelegate=[[AiObjectMagicDelegate alloc]initWithOwner:self];
    self.buffHelper=[[BuffHelper alloc]initWithOwner:self];
    return self;
}
-(void)onRecalcAttribute{
    [super onRecalcAttribute];
    [self.buffHelper recalcAttribute];
}
-(void)onEnterFrame{
    [super onEnterFrame];
    [self.buffHelper onEnterFrame];
}
@end
