//
//  HelloWorldLayer.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright Wei Ju 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface BattleLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) sceneWithLevel:(int)level;

@end
