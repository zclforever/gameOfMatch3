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
@interface Player : AiObject {
    
}

@property (strong,nonatomic) NSString* spriteName;
@property (strong,nonatomic) NSMutableArray* starsOfLevelArray; //星星数 [0]=level 1的star
@property (strong,nonatomic) NSMutableDictionary* pointDict;
@property (strong,nonatomic) NSMutableDictionary* moneyBuyDict;
//@property (strong,nonatomic) NSMutableArray* maxManaArray;
@property (strong,nonatomic) CCProgressTimer* apBar;
@property float curStep;
@property float maxStep;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;

-(void)addPersonSpriteAtPosition:(CGPoint)position;
-(void)addLifeBar;
@end
