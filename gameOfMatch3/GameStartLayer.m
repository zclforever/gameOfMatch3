//
//  GameStartLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-1.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameStartLayer.h"


@implementation GameStartLayer
+(CCScene *) scene
{

	CCScene *scene = [CCScene node];
	
	GameStartLayer *layer = [GameStartLayer node];

	[scene addChild: layer];
	
	return scene;
}
@end
