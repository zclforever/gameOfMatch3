//
//  HelloWorldLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright Wei Ju 2013年. All rights reserved.
//


// Import the interfaces
#import "BattleLayer.h"
#import "const.h"
#import "PlayLayer.h"
#import "StatePanelLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation BattleLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) sceneWithLevel:(int)level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BattleLayer *layer = [[BattleLayer alloc]initWithLevel:level];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) initWithLevel:(int)level
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
        
        float kStartX=1.0*(self.contentSize.width-kBoxWidth*kTileSize)-10;
//        float kStartY=1.0*(self.contentSize.height-kBoxHeight*kTileSize)/2;
//        float kStartX=0.0;
        float kStartY=5.0;
        [[consts sharedManager] setKStartX:kStartX];
        [[consts sharedManager] setKStartY:kStartY];

        
//        StatePanelLayer *statePanelLayer=[[StatePanelLayer alloc]initWithPositon:ccp(0,0)];
//        [self addChild:statePanelLayer z:2];
//        
//
//        StatePanelLayer *statePanelLayerEnemy=[[StatePanelLayer alloc]initWithPositon:ccp(kStartX+kBoxWidth*kTileSize,0)];
//        [self addChild:statePanelLayerEnemy z:3];

        Person* enemy=[Person enemyWithLevel:level];
        PlayLayer  *playLayer = [[PlayLayer alloc]initWithPlayer:nil withEnemy:enemy];
//        playLayer.statePanelLayerPlayer=statePanelLayer;
//        playLayer.statePanelLayerEnemy=statePanelLayerEnemy;
        [self addChild: playLayer z:0];
        
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
