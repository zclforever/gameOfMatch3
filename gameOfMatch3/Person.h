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
@property int curHP;
@property int maxHP;
@property int curStep;
@property int maxStep;
@property int damage;
@property int magicDamage;
@property (strong,nonatomic) NSString* spriteName;

+(Person*)enemyWithLevel:(int)level;
+(Person*)defaultPlayer;
+(Person*)defaultEnemy;
@end
