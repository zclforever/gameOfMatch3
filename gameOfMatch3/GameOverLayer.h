//
//  GameOverLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "BattleLayer.h"
#import "GameLevelLayer.h"
#import "PlayLayer.h"
#import "Person.h"
@interface GameOverLayer : CCLayerColor {
    
}
+(CCScene *) sceneWithWon:(BOOL)won;
+(CCScene *) sceneWithWon:(BOOL)won FromBattle:(id) playLayer;
@end
