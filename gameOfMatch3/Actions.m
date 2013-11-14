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
+(void)moveSprite:(CCSprite*)sprite toPosition:(CGPoint)position withDuration:(float)duration withFinishedBlock:(void(^)())block{
    CCSprite* spriteA=sprite;
    float moveDuration=duration;
    [Actions incActionCount];
    [spriteA runAction:[CCSequence actions:
                        //[CCDelayTime actionWithDuration:1],
                        [CCMoveTo actionWithDuration:moveDuration position:position],
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
    
    //spriteB.position=ccp(spriteB.position.x-10,spriteB.position.y);
    //fire.speed=(spriteB.position.x-spriteA.position.x)/1.5;
    
    
    //fire.scale=.62;
    fire.scale=.05+(spriteB.position.x-spriteA.position.x)/280;
    
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    //fire.startSize=36;
    
    //fire.rotation=-45;
    //fire.speed=-100;
    
    [Actions incActionCount];
    
    [[Actions sharedManager] addChild:fire];
    
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:2.0],
                     //[CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:2 withFinishedBlock:block];
}
+(void)poisonToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"poisonTo.plist"];
    
    CCParticleSystem* fire=particle_system;
    
    fire.speed=(spriteB.position.x-spriteA.position.x)/1.5;
    
    //fire.anchorPoint=ccp(0,0);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2);
    //fire.startSize=36;
    fire.scale=.6;
    fire.duration=2.0;
    //fire.speed=100;
    
    [Actions incActionCount];
    [[Actions sharedManager] addChild:fire];
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:2.2],
                     //[CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];

    [Actions shakeSprite:spriteB delay:2.2 withFinishedBlock:block];
}

+(void)explosionAtPosition:(CGPoint)position withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
    
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    fire.position=position;
//    fire.startSize=36;
//    fire.scale=.6;
    //fire.rotation=-45;
//    fire.speed=100;
    
    //[Actions incActionCount];
    
    [[Actions sharedManager] addChild:fire];
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:1.0],
//                     [CCScaleTo actionWithDuration:1.0 scale:.25],
//                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        //[Actions decActionCount];
        
    }],
                     nil]];

}

+(void)iceBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"iceBall.plist"];

    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    int randomVar=(arc4random()%80-40);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2+randomVar);
    fire.startSize=36;
    fire.scale=.6;
    //fire.rotation=-45;
    fire.speed=100;
    
    [Actions incActionCount];
    
    [[Actions sharedManager] addChild:fire];
    [fire runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1 position:ccp(spriteB.position.x+zPersonHeight/2,spriteB.position.y+zPersonHeight/2)],
                     [CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:1 withFinishedBlock:block];
}
+(void)fireSprite:(CCSprite*)spriteA withDuration:(float)duration withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"fired.plist"];
    
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    //int randomVar=(arc4random()%80-40);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y);
    //fire.startSize=36;
    fire.scale=.08;
    //fire.rotation=-45;
    //fire.speed=100;
    
    [Actions incActionCount];
    int useTag=arc4random();
    
    [[Actions sharedManager] addChild:fire z:10 tag:useTag];
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:duration],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];

}
+(void)fireSpriteEndByTag:(int)useTag{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"water.plist"];
    
    CCParticleSystem* water=particle_system;
    CCNode* fire=[[Actions sharedManager] getChildByTag:useTag];
    [fire runAction:[CCSequence actions:
                     [CCScaleTo actionWithDuration:1.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];
    

    water.position=ccp(fire.position.x,fire.position.y+zPersonHeight/2);
    water.scale=.6;
    
    [Actions incActionCount];
   [[Actions sharedManager] addChild:water];
    [water runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:2],
                     //[CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
        [Actions decActionCount];
        
    }],
                     nil]];
    
    


}

+(int)fireSpriteStart:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"fired.plist"];
    
    CCParticleSystem* fire=particle_system;
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y);

    fire.scale=.08;

    [Actions incActionCount];
    int useTag=arc4random();
    
    [[Actions sharedManager] addChild:fire z:10 tag:useTag]; 
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:999],
 
                     nil]];
    return useTag;

}
+(void)fireBallToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleFire *fire = [[CCParticleFire alloc]init];
    //fire.anchorPoint=ccp(0,0);
    int randomVar=(arc4random()%60-30);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2+randomVar);
    fire.startSize=81;
    fire.scale=.2;
    //fire.rotation=-45;
    fire.duration=3.0f;
    fire.gravity=ccp(-90,0);
    
     [Actions incActionCount];
   
    [[Actions sharedManager] addChild:fire];

    [fire runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:1 position:ccp(spriteB.position.x+zPersonHeight/2,spriteB.position.y+zPersonHeight/2)],
                     [CCScaleTo actionWithDuration:1.0 scale:.25],
                     [CCScaleTo actionWithDuration:.5 scale:0],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [node removeFromParentAndCleanup:YES];
                    [Actions decActionCount];
                        }],
                     nil]];
    [Actions shakeSprite:spriteB delay:1 withFinishedBlock:block];
}

+(void)hammerToSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"singleHammer.plist"];
   
    CCParticleSystem* fire=particle_system;
    //fire.anchorPoint=ccp(0,0);
    int randomVar=(arc4random()%40-20);
    fire.position=ccp(spriteA.position.x+zPersonHeight/2,spriteA.position.y+zPersonHeight/2+randomVar);
    //fire.startSize=36;
    fire.scale=1;
    //fire.rotation=-45;
    //fire.speed=100;
    fire.duration=2.0f;
    fire.life=1.0f;
    
    
     [Actions incActionCount];
    [[Actions sharedManager] addChild:fire];
    
    [fire runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:1],
                     [CCMoveTo actionWithDuration:.5 position:ccp(spriteB.position.x+zPersonHeight/2,spriteB.position.y+zPersonHeight/2)],
                     //[CCScaleTo actionWithDuration:1.0 scale:.25],
                     //[CCScaleTo actionWithDuration:.5 scale:0],
                     [CCDelayTime actionWithDuration:1],
                     [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
         [Actions decActionCount];
    }],
                     nil]];
    [Actions shakeSprite:spriteB delay:1.7];
    
    [spriteA runAction:[CCSequence actions:
                     [CCDelayTime actionWithDuration:1.7],
                     [CCCallBlock actionWithBlock:block],
    
                     nil]];
    
    
}





@end
