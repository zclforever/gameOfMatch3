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
@interface Projectile : AiObject  <UIAccelerometerDelegate>{
    
}

@property CGPoint moveDestPosition;
@property bool attackingNearest;
@property bool attackingPostion;
@property bool moving;
@property CGSize attackRange;

@property (strong,nonatomic) AiObject* owner;
@property (strong,nonatomic)  CCParticleSystem* particle;

-(void)attackPosition:(CGPoint)position;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name;
-(void)attackNearest;
-(void)dieAction;
@end
