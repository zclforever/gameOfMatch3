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
#import "AiObjectWithMagic.h"
@interface SmallEnemy : AiObjectWithMagic {
    
}
@property bool readyToDie;  //马上要死了，但可能还要放动画，再减血
@property bool alive;

@property (nonatomic,strong) CCSprite* sprite;
@property (nonatomic,strong) NSString* animationMovePlist;


@property CGPoint destPosition;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;

-(void)appearAtX:(int)x Y:(int)y;
-(void)dieAction;
-(void)moveAnimation;
-(void)attackAnimation;
@end
