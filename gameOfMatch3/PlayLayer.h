//
//  PlayLayer.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box.h"
#import "AI.h"
#import "StatePanelLayer.h"
@interface PlayLayer : CCLayer {
	Box *box;
	//Tile *selectedTile;
	Tile *firstOne;
    AI *ai;
}
@property (strong,nonatomic) StatePanelLayer* statePanelLayerPlayer;
@property (strong,nonatomic) StatePanelLayer* statePanelLayerEnemy;
-(bool) changeWithTileA: (Tile *) a TileB: (Tile *) b;
//-(void) check: (id) sender data: (id) data;
@end
