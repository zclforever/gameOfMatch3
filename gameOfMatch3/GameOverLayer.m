//
//  GameOverLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameOverLayer.h"
#import "HelloWorldLayer.h"

@implementation GameOverLayer
+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won] ;
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        
        NSString * message;
        if (won) {
            message = @"Perfect!";
            [self addChild:[CCParticleFireworks node]];
            //[self addChild:[CCParticleMeteor node]];
            [self addChild:[CCParticleExplosion node]];
        } else {
            message = @"You Lose...";
            [self setColor:ccc3(0,0,0)];
            [self addChild:[CCParticleFire node]];
            //[self addChild:[CCParticleSmoke node]];
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:28];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2+10, winSize.height/2-20);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:8],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
         }],
          nil]];
        

    }
    return self;
}
@end
