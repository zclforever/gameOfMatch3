//
//  SmallEnemy.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SmallEnemy : CCLayer {
    
}
@property bool readyToEnd;
@property bool readyToDie;  //马上要死了，但可能还要放动画，再减血
@property bool isAlive;
@property bool atDest;
@property bool startMove;
@property float curHP;
@property float maxHP;
@property float damage;
@property (nonatomic,strong) CCSprite* sprite;
@property CGPoint destPos;

-(void)appearAtX:(int)x Y:(int)y;
-(void)dieAction;

@end
