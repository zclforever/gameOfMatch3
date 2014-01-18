//
//  AiObject.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Actions.h"
#import "Global.h"
//@protocol AiObject 
//@required
//-(CGRect)getBoundingBox;
//
//
//@end
@interface State : NSObject{
    
}
@property bool frozen;
@property float frozenStartTime;

@end
@interface AiObject : CCLayer {
    
}
//--------基本属性-----------
@property (strong,nonatomic) NSMutableDictionary* attributeDict;

@property (strong,nonatomic) NSString* type;


@property float curHP;
@property float maxHP;
@property float damage;
@property float attackCD;
@property float lastAttackTime;
@property float moveSpeed;
@property bool alive;
@property bool atDest;

@property (strong,nonatomic) CCSprite* lifeBar;
@property (strong,nonatomic) CCSprite* lifeBarBorder;
@property (strong,nonatomic) CCLabelTTF* HPLabel;

@property float width;
@property float height;

@property (nonatomic,strong) CCSprite* sprite;
@property (nonatomic,strong) CCNode* node;
@property (nonatomic,strong) NSString* objectName;
@property (nonatomic,weak) NSMutableArray* allObjectsArray;
@property (nonatomic,strong) NSMutableArray* collisionObjectArray;
@property (strong,nonatomic) NSMutableDictionary* stateDict;  //战斗时的状态
@property (strong,nonatomic) State* state;  //战斗时的状态
//@property (weak) id <AiObject>	spriteEntity ;

//-----------------------------
@property float delayTime; //update的延时
@property bool autoUpdateCollision;

//debug
@property bool showBoundingBox;

-(CGRect)getBoundingBox;
-(CGPoint)getCenterPoint;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;
-(void)updateCollisionObjectArray;
-(void)setTimeOutOfUpdateWithDelay:(float)timeOut;
-(void)setTimeOutWithDelay:(float)timeOut withSelector:(SEL)selector;
-(void)setTimeOutWithDelay:(float)timeOut withBlock:(void(^)())block;
-(void)hurtByObject:(AiObject*)obj;
-(void)magicAttackWithName:(NSString*)magicName;
-(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict;
-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position;

-(CCAnimation* )animationByPlist:(NSString*)name withDelay:(float)delay;
-(NSArray*)getNameOfFramesFromPlist:(NSString*)name;
-(void)addLifeBar;
@end
