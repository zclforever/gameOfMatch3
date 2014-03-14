//
//  Projectile.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"
@protocol ProjectileAiDelegate<NSObject>


-(void)onFindTargets;
-(void)onInAttackRange;
-(void)onFindNothing;
-(void)onNothingToDo;
-(void)onNotReadyToAttackTargetInRange;   //攻击CD未到
-(bool)onReadyToAttackTargetInRange;    //CD OK可以攻击了。
-(void)onEnterFrame;
-(void)onInSightButNotInAttackRange;
@optional

@end

@interface Projectile : AiObject  <UIAccelerometerDelegate>{
    
}

@property (strong,nonatomic) id<ProjectileAiDelegate> aiDelegate;

@property CGPoint destPosition;

@property (strong,nonatomic) AiObject* owner;

@property (strong,nonatomic) NSString* hitSound;


-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name;
-(void)dieAction;
-(void)makeNode;
@end
