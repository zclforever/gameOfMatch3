//
//  ActionManager.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Actions : CCLayer {
    
}
+ (id)sharedManager;
+(void)shakeSprite:(CCSprite*)sprite;
+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay;
+(void)attackSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
@end
