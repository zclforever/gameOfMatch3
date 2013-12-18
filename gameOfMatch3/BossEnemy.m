//
//  BossEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "BossEnemy.h"

@interface BossEnemy()


@end
@implementation BossEnemy


-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withLevel:(int)level{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=@"bossEnemy";
        
        self.level=level;
        [self dataByLevel:level];
        [self updateOfBossEnemy];

    }
    return self;
}

-(void)dataByLevel:(int)level{
    Person* defaultPerson=[Person enemyWithLevel:level];

    self.curHP=defaultPerson.curHP;
    self.maxHP=defaultPerson.maxHP;
    self.damage=defaultPerson.damage;
    self.spriteName=defaultPerson.spriteName;
    self.stateDict=defaultPerson.stateDict ;
    self.maxStep=defaultPerson.maxStep;
    self.curStep=defaultPerson.curStep;
    self.apSpeed=defaultPerson.apSpeed;


    self.smallEnemyCount=defaultPerson.smallEnemyCount;
    self.smallEnemyHp=defaultPerson.smallEnemyHp;
    self.attackType=defaultPerson.attackType;
    
}

-(void)updateOfBossEnemy{
    
    
    
    
    
    
    [self setTimeOutWithDelay:self.delayTime withSelector:@selector(updateOfBossEnemy)];
}
@end
