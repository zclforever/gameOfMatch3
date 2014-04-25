//
//  AiObjectMagicDelegate.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FireBall.h"
#import "IceBall.h"
#import "BigFireBall.h"
#import "SnowBall.h"
#import "PhysicalAttack.h"
#import "AiBehavior.h"


@protocol MagicProtocol <NSObject>

    @property (strong,nonatomic) NSDictionary* findTargetsResult;
    @property (nonatomic,weak) NSMutableArray* allObjectsArray;
    @property (strong,nonatomic) NSMutableArray* targetTags;
    @property (strong,nonatomic) NSDictionary* attributeDatabase;
    @property (strong,nonatomic) Attribute* physicalDamage;
    @property (strong,nonatomic) Attribute* magicalDamage;
-(void) addChild: (CCNode*) child;
-(CGPoint)getCenterPoint;


@optional

@end


@interface AiObjectMagicDelegate : NSObject {
    
}
    @property id<MagicProtocol> owner;

    -(id)initWithOwner:(id<MagicProtocol>) obj;

    -(void)magicAttackWithName:(NSString*)magicName;
    -(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict;
-(NSDictionary*)magicDataByName:(NSString*)name;

@end
