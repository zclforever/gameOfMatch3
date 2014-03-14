//
//  FireBall.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ProjectileAI.h"
@interface ProjectileAiWithTargets : ProjectileAI {
    
}
-(id)initWithTargets:(NSArray*)targetsArray  withOwner:(Projectile*)obj;

 
@property (strong,nonatomic) NSArray* targetsArray;
@end
