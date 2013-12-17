//
//  BossEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "BossEnemy.h"


@implementation BossEnemy


-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        self.objectName=@"player";
        
        
        [self copyFromSharedPerson];

    }
    return self;
}
-(void)copyFromSharedPerson{
    Person* defaultPerson=[Person sharedPlayer];
    self.curHP=defaultPerson.curHP;
    self.maxHP=defaultPerson.maxHP;
    self.damage=defaultPerson.damage;
    self.spriteName=defaultPerson.spriteName;
    self.stateDict=defaultPerson.stateDict ;
    self.starsOfLevelArray=defaultPerson.starsOfLevelArray;
    self.pointDict=defaultPerson.pointDict;
    self.moneyBuyDict=defaultPerson.moneyBuyDict;
    
}
@end
