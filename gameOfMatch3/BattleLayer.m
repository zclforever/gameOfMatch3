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

#pragma mark - HelloWorldLayer


@implementation BattleLayer

+(CCScene *) sceneWithPlayer:(Person*)player withEnemy:(Person*)enemy{
    
	CCScene *scene = [CCScene node];
	BattleLayer *layer = [[BattleLayer alloc]initWithPlayer:player withEnemy:enemy];
	[scene addChild: layer];

	return scene;
}
+(CCScene *) sceneWithLevel:(int)level
{
	CCScene *scene = [CCScene node];
	BattleLayer *layer = [[BattleLayer alloc]initWithLevel:level];
	[scene addChild: layer];
	return scene;
}
-(id) initWithPlayer:(Person*)player withEnemy:(Person*)enemy
{
    
	if( (self=[super init]) ) {
		
        
        float kStartX=1.0*(self.contentSize.width-kBoxWidth*kTileSize)-10;
        float kStartY=5.0;
        [[Global sharedManager] setKStartX:kStartX];
        [[Global sharedManager] setKStartY:kStartY];
        PlayLayer  *playLayer = [[PlayLayer alloc]initWithPlayer:player withEnemy:enemy];
        [self addChild: playLayer z:0];
        
	}
	return self;
}

-(id) initWithLevel:(int)level
{
    Person  *playLayer = [Person sharedPlayerCopy];
    Person  *enemy=[Person enemyWithLevel:level];
 	return [self initWithPlayer:playLayer withEnemy:enemy];
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
