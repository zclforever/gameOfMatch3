//
//  Hero.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-9.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"
#import "Person.h"
#import "Tile.h"
#import "AiObjectWithMagic.h"

@interface Hero : AiObjectWithMagic <tileDelegate> {
    
}

//protocol
@property (strong,nonatomic) NSString* tileSpriteName;
@property (strong,nonatomic) NSString* tileType;

@property (strong,nonatomic) NSString* spriteName;

@property (strong,nonatomic) NSMutableArray* skillDelegates;//技能球们

@property (strong,nonatomic) NSMutableArray* starsOfLevelArray; //星星数 [0]=level 1的star
@property (strong,nonatomic) NSMutableDictionary* pointDict;
@property (strong,nonatomic) NSMutableDictionary* moneyBuyDict;
//@property (strong,nonatomic) NSMutableArray* maxManaArray;
@property (strong,nonatomic) CCProgressTimer* apBar;
@property float curStep;
@property float maxStep;
@property CGSize attackRange;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;

-(void)addPersonSpriteAtPosition:(CGPoint)position;

@end
