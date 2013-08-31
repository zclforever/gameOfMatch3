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
@interface PlayLayer : CCLayer {
	Box *box;
	Tile *selectedTile;
	Tile *firstOne;
    AI *ai;
}

-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b;
//-(void) check: (id) sender data: (id) data;
@end
