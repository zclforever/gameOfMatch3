//
//  BossEnemy.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
@interface BossEnemy : Player {
    
}


@property float apSpeed;
@property int smallEnemyCount;
@property float smallEnemyHp;
@property int level;
@property int attackType; //敌人会用上 哪种攻击

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withLevel:(int)level with:(NSString*)name;


@end
