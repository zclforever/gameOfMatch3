//
//  SmallEnemy.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"

@interface SmallEnemy : AiObject {
    
}
@property bool readyToEnd;
@property bool readyToDie;  //马上要死了，但可能还要放动画，再减血
@property bool alive;
@property bool startMove;
@property bool isAttacking;

@property (nonatomic,strong) CCSprite* sprite;

@property CGPoint destPos;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;
-(void)appearAtX:(int)x Y:(int)y;
-(void)dieAction;

@end
