//
//  Player.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"
#import "Person.h"
#import "AiObjectWithMagic.h"
@interface Player : AiObjectWithMagic {
    
}

@property (strong,nonatomic) NSString* spriteName;
@property (strong,nonatomic) NSMutableArray* starsOfLevelArray; //星星数 [0]=level 1的star
@property (strong,nonatomic) NSMutableDictionary* pointDict;
@property (strong,nonatomic) NSMutableDictionary* moneyBuyDict;
//@property (strong,nonatomic) NSMutableArray* maxManaArray;
@property (strong,nonatomic) CCProgressTimer* apBar;
@property float curStep;
@property float maxStep;
@property float curEnergy;
@property float maxEnergy;
@property CGSize attackRange;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString *)name;

-(void)addPersonSpriteAtPosition:(CGPoint)position;
-(void)addLifeBar;
-(void)addApBar;
@end
