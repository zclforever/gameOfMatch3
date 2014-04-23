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
#import "BuffHelper.h"
@class  AiBehavior;
@protocol ProjectileAiDelegate<NSObject>

-(void)onEnterFrame;

@optional

@end

@interface Projectile : AiObject  <UIAccelerometerDelegate>{
    
}

@property (strong,nonatomic) NSMutableArray* aiBeharviorsArray;
-(void)pushAiBeharvior:(AiBehavior*)aiBeharvior;

@property (strong,nonatomic) AiObject* owner;

@property (strong,nonatomic) NSString* hitSound;

@property (strong,nonatomic) NSMutableArray* attackedObjectsArray;

@property (strong,nonatomic) DamageData* damageData;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name;
-(void)dieAction;
-(void)makeNode;
-(void)onDirectAttatckTarget:(AiObject*)obj;
-(void)onDie;
@end
