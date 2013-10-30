//
//  ActionManager.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Actions.h"
#import "Global.h"

@implementation Actions
static id sharedManager = nil;

+ (void)initialize {
    if (self == [Actions class]) {
        sharedManager = [[self alloc] init];
    }
}

+ (id)sharedManager {
    return sharedManager;
}
+(void)incActionCount{
    int count=[Actions getActionCount];
    count++;
    [[Actions sharedManager] setActionRunningCount:count];
}

+(void)decActionCount{
    int count=[Actions getActionCount];
    count--;
    [[Actions sharedManager] setActionRunningCount:count];
}
+(int)getActionCount{
    return [[Actions sharedManager] actionRunningCount];
}
+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay{
    [Actions shakeSprite:sprite delay:delay withFinishedBlock:^{
        
    }];
}
+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay withFinishedBlock:(void(^)())block{
    //CGPoint position=sprite.position;
    float totalShakeDuration=.4f;
    float perShakerDurtation=totalShakeDuration/8;
    float amplitude=5.0f; //振幅
    [sprite runAction:[CCSequence actions:
                       [CCDelayTime actionWithDuration:delay],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(amplitude,0)],
                        [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-amplitude,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-amplitude,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(amplitude,0)],
                       
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(amplitude,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-amplitude,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-amplitude,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(amplitude,0)],
                       [CCCallBlock actionWithBlock:block],
                       nil]];
}

+(void)attackSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CGPoint positionA=spriteA.position;
    CGPoint positionB=spriteB.position;
    float moveDuration=0.5f;
    [Actions incActionCount];
    [spriteA runAction:[CCSequence actions:
                       [CCMoveTo actionWithDuration:moveDuration position:ccp(positionB.x-40,positionB.y)],
                      
                       nil]];
    [Actions shakeSprite:spriteB delay:moveDuration];
    [spriteA runAction:[CCSequence actions:
                        [CCDelayTime actionWithDuration:1],
                        [CCMoveTo actionWithDuration:moveDuration position:ccp(positionA.x,positionA.y)],
                        [CCCallBlock actionWithBlock:block],
                        [CCCallBlock actionWithBlock:^{
                            [Actions decActionCount];
                        }],
                        nil]];

}
+(void)poisonFromSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"poison.plist"];
    
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    //fire.startSize=36;
    fire.scale=.6;
    //fire.rotation=-45;
    //fire.speed=100;
    
    [[Actions sharedManager] addChild:fire];
    
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:2.0],
                     //[CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:2 withFinishedBlock:block];
}
+(void)bloodAbsorbSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"bloodAbsorb.plist"];
    
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    //fire.startSize=36;
    fire.scale=.62;
    //fire.rotation=-45;
    //fire.speed=100;
    
    [[Actions sharedManager] addChild:fire];
    
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:2.0],
                     //[CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:2 withFinishedBlock:block];
}
+(void)poisonToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"poisonTo.plist"];
    
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    //fire.startSize=36;
    fire.scale=.6;
    fire.duration=2.0;
    //fire.speed=100;
    
    [[Actions sharedManager] addChild:fire];

    [Actions shakeSprite:spriteB delay:2.2 withFinishedBlock:block];
}

+(void)iceBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"iceBall.plist"];

    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    fire.startSize=36;
    fire.scale=.6;
    //fire.rotation=-45;
    fire.speed=100;
    
    [[Actions sharedManager] addChild:fire];
    
    [fire runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1 position:ccp(spriteB.position.x+zPersonHeight/2,spriteB.position.y+zPersonHeight/2)],
                     [CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:1 withFinishedBlock:block];
}

+(void)fireBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleFire *fire = [[CCParticleFire alloc]init];
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    fire.startSize=81;
    fire.scale=.2;
    //fire.rotation=-45;
    fire.gravity=ccp(-90,0);
   
    [[Actions sharedManager] addChild:fire];

    [fire runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1 position:ccp(spriteB.position.x+zPersonHeight/2,spriteB.position.y+zPersonHeight/2)],
                     [CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [node removeFromParentAndCleanup:YES];
        
                        }],
                     nil]];
    [Actions shakeSprite:spriteB delay:1 withFinishedBlock:block];
}







@end
