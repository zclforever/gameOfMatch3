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
@interface AiObject : CCLayer {
    
}
//--------基本属性-----------
@property float curHP;
@property float maxHP;
@property float damage;
@property float attackCD;
@property float moveSpeed;
@property bool alive;


@property (nonatomic,strong) CCSprite* sprite;
@property (nonatomic,strong) NSString* objectName;
@property (nonatomic,weak) NSMutableArray* allObjectsArray;
@property (nonatomic,strong) NSMutableArray* collisionObjectArray;
//@property (weak) id <AiObject>	spriteEntity ;

//-----------------------------
@property float delayTime; //update的延时

-(CGRect)getBoundingBox;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;
-(void)updateCollisionObjectArray;
-(void)setTimeOutOfUpdateWithDelay:(float)timeOut;
-(void)setTimeOutWithDelay:(float)timeOut withSelector:(SEL)selector;
-(void)hurtByObject:(AiObject*)obj;
-(void)magicAttackByName:(NSString*)magicName;
-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position;

@end
