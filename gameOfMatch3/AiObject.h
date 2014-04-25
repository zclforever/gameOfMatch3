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
#import "AiObjectFindTargetsDelegate.h"
#import "AiObjectInteraction.h"
#import "Attribute.h"
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
@interface AiObject : CCLayer <FindTargetsProtocol> {
    
}
//--------基本属性-----------
@property (strong,nonatomic) NSDictionary* attributeDatabase;
@property int aiState;
@property (strong,nonatomic) NSMutableArray* targetTags;
@property (strong,nonatomic) NSMutableArray* selfTags;

@property (strong,nonatomic) NSString* type;


@property float curHP;
@property float curEnergy;
//@property float damage;


@property (strong,nonatomic) Attribute* maxHP;
@property (strong,nonatomic) Attribute* maxEnergy;
@property (strong,nonatomic) Attribute* moveSpeed;
@property (strong,nonatomic) Attribute* attackRate;
@property (strong,nonatomic) Attribute* physicalDamage;
@property (strong,nonatomic) Attribute* magicalDamage;
-(Attribute*)attributeByName:(NSString*)name;


//@property float attackType;
@property float lastAttackTime;

@property bool alive;
@property bool atDest;
@property bool readyToEnd;


@property float width;
@property float height;

@property (nonatomic,strong) NSString* objectName;
@property (nonatomic,strong) CCSprite* sprite;
@property (nonatomic,strong) CCNode* node;
@property (nonatomic,weak) NSMutableArray* allObjectsArray;

@property (strong,nonatomic) AiObject* wantedObject;


@property (strong,nonatomic) NSMutableDictionary* stateDict;  //战斗时的状态
@property (strong,nonatomic) State* state;  //战斗时的状态

//-----------------------------
@property float delayTime; //update的延时

//debug
@property bool showBoundingBox;


-(void)onEnterFrame;
-(CGRect)getBoundingBox;
-(CGPoint)getCenterPoint;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;
-(void)initFromPlist;
-(void)loadAttributeFromDict;

-(void)moveToPosition:(CGPoint)pos;

//-(void)updateCollisionObjectArray;
-(void)start;//延迟加载


-(void)setTimeOutOfUpdateWithDelay:(float)timeOut;
-(void)setTimeOutWithDelay:(float)timeOut withSelector:(SEL)selector;
-(void)setTimeOutWithDelay:(float)timeOut withBlock:(void(^)())block;

//攻击防守
-(void)hurtByObject:(DamageData*)data; 
//-(void)directAttackTarget:(AiObject*)obj;

-(bool)attackTarget:(AiObject*)obj; //判断是否该攻击

-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position;

-(CCAnimation* )animationByPlist:(NSString*)name withDelay:(float)delay;
-(NSArray*)getNameOfFramesFromPlist:(NSString*)name;

@property (nonatomic,strong) NSString* stringID;


-(NSArray*)findTargets;
@property (strong,nonatomic) NSDictionary* findTargetsResult;

-(NSMutableArray*)collisionObjectsByDistance:(float)distance;
-(NSMutableArray*)collisionObjectsByDistance:(float)distance withObjectsArray:(NSArray*)objectsArray;
-(NSArray*)objectsByTags:(NSArray*)tags from:(NSArray*)objectsArray;

-(bool)checkDie;

@property AiObjectFindTargetsDelegate* findTargetsDelegate;
-(void)onFindTargets;
-(void)onInAttackRange;
-(void)onFindNothing;
-(void)onNothingToDo;
-(void)onNotReadyToAttackTargetInRange;   //攻击CD未到
-(bool)onReadyToAttackTargetInRange;    //CD OK可以攻击了。
-(void)onCurHPIsZero; //要死了
-(void)onDie;

-(void)onRecalcAttribute;
@end

