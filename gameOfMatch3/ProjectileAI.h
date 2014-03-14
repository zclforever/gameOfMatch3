//
//  ProjectileAI.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Projectile.h"

@interface ProjectileAI : NSObject<ProjectileAiDelegate> {
    
}
-(id)initWithOwner:(Projectile*)obj;

@property Projectile* projectile;
@end