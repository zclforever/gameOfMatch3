//
//  BuffHelper.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"
#import "Buff.h"
#import "BuffSlow.h"
#import "BuffFury.h"








@interface BuffHelper : NSObject {
    
}
@property id owner;

@property (strong,nonatomic) NSMutableDictionary* buffDict;
@property (strong,nonatomic) NSMutableArray* buffArray;

-(id)initWithOwner:(id)owner;

-(void)addBuffWith:(Buff*)buff;
-(void)removeBuffWith:(Buff*)buff;
-(bool)hasBuff:(NSString*)name;
//-(Buff*)getBuffByName:(NSString*)name;
-(void)recalcAttribute;
-(void)onEnterFrame;
@end
