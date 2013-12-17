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

@property (weak,nonatomic) NSString* spriteName;
@property (weak,nonatomic) NSMutableArray* starsOfLevelArray; //星星数 [0]=level 1的star
@property (weak,nonatomic) NSMutableDictionary* stateDict;  //战斗时的状态
@property (weak,nonatomic) NSMutableDictionary* pointDict;
@property (weak,nonatomic) NSMutableDictionary* moneyBuyDict;
//@property (strong,nonatomic) NSMutableArray* maxManaArray;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;

-(void)addPersonSpriteAtPosition:(CGPoint)position;

@end
