//
//  ProjectileWithNoTarget.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-8.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ProjectileAI.h"
@interface ProjectileAiWithNoTarget : ProjectileAI {
    
}
-(id)initWithOwner:(Projectile*)obj;
@property bool die;
@end
