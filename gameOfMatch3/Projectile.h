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
@interface Projectile : AiObject {
    
}

@property bool attackingNearest;

@property (strong,nonatomic)  CCParticleSystem* particle;

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name;
-(void)attackNearest;
@end
