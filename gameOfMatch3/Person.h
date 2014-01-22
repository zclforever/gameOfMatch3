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
@property int level; //enemy level;
@property int attackType; //敌人会用上 哪种攻击
@property float curHP;
@property float maxHP;
@property float curStep;
@property float maxStep;
@property int damage;
@property float apSpeed;
@property (readonly) int magicDamage;
@property int experience;
@property int money;
@property float curEnergy;
@property float maxEnergy;
@property (strong,nonatomic) NSString* spriteName;
@property float spriteScale;
@property (strong,nonatomic) NSMutableArray* maxManaArray;
@property (strong,nonatomic) NSMutableArray* starsOfLevelArray; //星星数 [0]=level 1的star
@property (strong,nonatomic) NSMutableDictionary* stateDict;  //战斗时的状态
@property (strong,nonatomic) NSMutableDictionary* pointDict;
@property (strong,nonatomic) NSMutableDictionary* moneyBuyDict;
@property int smallEnemyCount;
@property float smallEnemyHp;



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
