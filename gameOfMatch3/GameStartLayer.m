//
//  GameStartLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-1.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameStartLayer.h"
#import "const.h"
#import "PlayLayer.h"
#import "StatePanelLayer.h"
#import "BattleLayer.h"
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
		
		// create and initialize a Label
        
//        float kStartX=1.0*(self.contentSize.width-kBoxWidth*kTileSize)-10;
//        float kStartY=5.0;
//        [[consts sharedManager] setKStartX:kStartX];
//        [[consts sharedManager] setKStartY:kStartY];
//     
//        PlayLayer  *playLayer = [PlayLayer node];
//
//        [self addChild: playLayer z:0];

        CCLabelTTF* start=[CCLabelTTF labelWithString:@"新的开始" fontName:@"Arial" fontSize:48];

        
        CCMenuItemLabel* menuLabel=[[CCMenuItemLabel alloc]initWithLabel:start block:^(id sender) {

            [[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
        }];
        CCMenu* menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(self.contentSize.width/2,self.contentSize.height/2);
        [self addChild:menu];

        self.isTouchEnabled=YES;
	}
	return self;
}



@end
