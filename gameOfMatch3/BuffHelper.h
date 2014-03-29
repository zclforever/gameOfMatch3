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
@class AiObjectWithMagic;




@protocol BuffHelperProtocol <NSObject>
@property (strong,nonatomic) CCNode* node;
@end




@interface BuffHelper : CCLayer {
    
}
@property id<BuffHelperProtocol> owner;

@property (strong,nonatomic) NSMutableDictionary* buffDict;

-(id)initWithOwner:(id<BuffHelperProtocol>)owner;

-(void)addBuffWith:(Buff*)buff;
-(void)removeBuffWith:(Buff*)buff;
-(bool)hasBuff:(NSString*)name;
-(Buff*)getBuffByName:(NSString*)name;

@end
