//
//  FireBall.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiBehavior.h"
@interface ProjectileAiWithTargetPosition : AiBehavior {
    
}
@property CGPoint destPostion;
-(id)initWithDestPosition:(CGPoint)destPosition  withOwner:(Projectile*)obj;
@end
