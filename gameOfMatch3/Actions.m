//
//  ActionManager.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Actions.h"


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

+(void)shakeSprite:(CCSprite*)sprite{
    [Actions shakeSprite:sprite delay:0];
}
+(void)shakeSprite:(CCSprite*)sprite delay:(float)delay{
    CGPoint position=sprite.position;
    float totalShakeDuration=.4f;
    float perShakerDurtation=totalShakeDuration/8;
    [sprite runAction:[CCSequence actions:
                       [CCDelayTime actionWithDuration:delay],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(10,0)],
                        [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-10,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-10,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(10,0)],
                       
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(10,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-10,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(-10,0)],
                       [CCMoveBy actionWithDuration:perShakerDurtation position:ccp(10,0)],
                       
                       nil]];
}

+(void)attackSpriteB:(CCSprite*)spriteB fromSpriteA:(CCSprite*)spriteA withFinishedBlock:(void(^)())block{
    CGPoint positionA=spriteA.position;
    CGPoint positionB=spriteB.position;
    float moveDuration=0.5f;
    [spriteA runAction:[CCSequence actions:
                       [CCMoveTo actionWithDuration:moveDuration position:ccp(positionB.x-40,positionB.y)],
                      
                       nil]];
    [Actions shakeSprite:spriteB delay:moveDuration];
    [spriteA runAction:[CCSequence actions:
                        [CCDelayTime actionWithDuration:1],
                        [CCMoveTo actionWithDuration:moveDuration position:ccp(positionA.x,positionA.y)],
                        [CCCallBlock actionWithBlock:block],
                        nil]];

}
@end
