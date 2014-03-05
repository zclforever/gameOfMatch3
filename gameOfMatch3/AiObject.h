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
#import "BarHelper.h"
//@protocol AiObject 
//@required
//-(CGRect)getBoundingBox;
//
//
//@end
#define aiState_nothingToDo 1
#define aiState_searchingInSight 2
#define aiState_inSight 4
#define aiState_attackWantedObject 8
#define aiState_inAttackRange 16

@interface State : NSObject{
    
}
@property bool frozen;
@property float frozenStartTime;

@end
@interface AiObject : CCLayer {
    
}
//--------基本属性-----------
@property (strong,nonatomic) NSMutableDictionary* attributeDict;
@property int aiState;
@property (strong,nonatomic) NSMutableArray* targetTags;
@property (strong,nonatomic) NSMutableArray* selfTags;

@property (strong,nonatomic) NSString* type;


@property float curHP;
@property float maxHP;
@property float curEnergy;
@property float maxEnergy;
@property float damage;
@property float attackCD;



@property float attackType;
@property float lastAttackTime;
@property float moveSpeed;
@property bool alive;
@property bool atDest;



@property float width;
@property float height;

@property (nonatomic,strong) NSString* objectName;
@property (nonatomic,strong) CCSprite* sprite;
@property (nonatomic,strong) CCNode* node;
@property (nonatomic,weak) NSMutableArray* allObjectsArray;
@property (nonatomic,strong) NSMutableArray* collisionObjects;
@property (nonatomic,strong) NSArray* collisionObjectsInSight;
@property (nonatomic,strong) NSArray* collisionObjectsInAttankRange;
@property (strong,nonatomic) AiObject* wantedObject;


@property (strong,nonatomic) NSMutableDictionary* stateDict;  //战斗时的状态
@property (strong,nonatomic) State* state;  //战斗时的状态
//@property (weak) id <AiObject>	spriteEntity ;

//-----------------------------
@property float delayTime; //update的延时
@property bool autoUpdateCollision;

//debug
@property bool showBoundingBox;


-(void)onEnterFrame;
-(CGRect)getBoundingBox;
-(CGPoint)getCenterPoint;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;
-(void)initFromPlist;

-(void)moveToPosition:(CGPoint)pos;

-(void)updateCollisionObjectArray;

-(void)onInSightButNotInAttackRange;
-(void)onInAttackRange;
-(void)onNothingInSight;
-(void)nothingToDo;
-(void)onNotReadyToAttackTargetInRange;   //攻击CD未到
-(bool)onReadyToAttackTargetInRange;    //CD OK可以攻击了。


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
