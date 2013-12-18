//
//  GameStartLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-1.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameStartLayer.h"
#import "Global.h"
#import "PlayLayer.h"
#import "StatePanelLayerInBattle.h"
#import "BattleLayer.h"
#import "GameLevelLayer.h"
#import "GameMainLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLevelLayer.h"
@implementation GameStartLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GameStartLayer *layer = [GameStartLayer node];
    
	[scene addChild: layer];
	
	return scene;
}
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Contra.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"superMario.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"marioWorld.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"coinDing.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"thunderDone.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"deny.wav"];
        
        CCLabelTTF* start=[CCLabelTTF labelWithString:@"新的开始" fontName:@"Arial" fontSize:48];
        
        CCMenuItemLabel* menuLabel=[[CCMenuItemLabel alloc]initWithLabel:start block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
        }];
        CCMenu* menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:menu];
        
        self.isTouchEnabled=YES;
        [Person initSharedPlayer];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Contra.mp3"];
        

        
        CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"fired.plist"];
        
        [self addChild:particle_system];
//        
//        CCParticleSystem* test = [CCParticleSystemQuad particleWithFile:@"bigFireBall.plist"];
//        
//        [self addChild:test];
        
        [[Global sharedManager] setSetTimeOut:[CCSprite spriteWithFile:@"transparent.png"]];
        
        


	}
    

	return self;
}



@end
