//
//  Person.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-8-30.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface Person : NSObject
@property (readonly) int lv;
@property int curHP;
@property int maxHP;
@property float curStep;
@property float maxStep;
@property int damage;
@property float apSpeed;
@property (readonly) int magicDamage;
@property int experience;
@property int money;
@property int expInBattle;
@property int moneyInBattle;
@property (strong,nonatomic) NSString* spriteName;
@property float spriteScale;
@property int scoreInBattle;
@property (strong,nonatomic) NSMutableArray* maxManaArray;
@property (strong,nonatomic) NSMutableDictionary* stateDict;
+(void)initSharedPlayer;
+(void)copyWith:(Person*)oriPerson to:(Person*)destPerson;
+(Person*)copyWith:(Person*)oriPerson;
+(Person*)sharedPlayer;
+(Person*)sharedPlayerCopy;
+(Person*)enemyWithLevel:(int)level;
+(Person*)defaultPlayer;
+(Person*)defaultEnemy;
+(int)lvByExp:(int)experience;
-(int)expToNextLV;
@end
