//
//  ProjectileWithNoTarget.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-8.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiBehavior.h"
@interface ProjectileAiWithNoTarget : AiBehavior {
    
}
-(id)initWithOwner:(Projectile*)obj;
@property bool die;
@end
