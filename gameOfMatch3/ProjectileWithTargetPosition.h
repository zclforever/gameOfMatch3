//
//  FireBall.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Projectile.h"
@interface ProjectileWithTargetPosition : Projectile {
    
}
@property CGPoint destPostion;
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos withDestPosition:(CGPoint)destPosition byName:(NSString*)name;
@end
