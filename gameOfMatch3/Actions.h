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
@property int actionRunningCount;  //这个值 =0 说明所有动作执行完毕 每进一个动作 会+1
+ (id)sharedManager;
+(void)decActionCount;
+(void)incActionCount;
+(int)getActionCount;

+(void)fireSprite:(CCSprite*)spriteA withDuration:(float)duration withFinishedBlock:(void(^)())block;

+(int)fireSpriteStart:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;//返tag 消除
+(void)fireSpriteEndByTag:(int)useTag;

+(void)explosionAtPosition:(CGPoint)position withFinishedBlock:(void(^)())block;

+(void)moveSprite:(CCSprite*)sprite toPosition:(CGPoint)position withDuration:(float)duration withFinishedBlock:(void(^)())block;

+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay;
+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay withFinishedBlock:(void(^)())block;

+(void)attackSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;

+(void)bigFireBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;

+(void)bloodAbsorbSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
+(void)poisonToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
+(void)iceBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
+(void)fireBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
+(void)hammerToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block;
@end
