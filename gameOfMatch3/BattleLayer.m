//
//  HelloWorldLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright Wei Ju 2013年. All rights reserved.
//


// Import the interfaces
#import "BattleLayer.h"
#import "Global.h"
#import "PlayLayer.h"
#import "StatePanelLayerInBattle.h"

#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
#pragma mark - HelloWorldLayer
@interface BattleLayer()
@property int level;

@end

@implementation BattleLayer


+(CCScene *) sceneWithLevel:(int)level
{
	CCScene *scene = [CCScene node];
	BattleLayer *layer = [[BattleLayer alloc]initWithLevel:level];
	[scene addChild: layer];
    layer.scene=scene;
    
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:1 scene:scene]];
	return scene;
}
-(id) initWithLevel:(int)level
{
    
	if( (self=[super init]) ) {
		self.level=level;
        
        float kStartX=1.0*(self.contentSize.width-kBoxWidth*kTileSize)/2;
        float kStartY=1.0;
        [[Global sharedManager] setKStartX:kStartX];
        [[Global sharedManager] setKStartY:kStartY];
        PlayLayer  *playLayer = [[PlayLayer alloc]initWithLevel:level];
        [self addChild: playLayer z:0];
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"superMario.mp3"];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"battleMusic02.mp3"];
        
	}
	return self;
}



#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
