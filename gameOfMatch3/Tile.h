//
//  Tile.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "const.h"

@interface Tile : NSObject
{
    int x, y, value;
	CCSprite *sprite;
}
-(id) initWithX: (int) posX Y: (int) posY;
@property (nonatomic) int x, y;
@property (nonatomic) int value;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic,strong) NSMutableArray* actionSequence;
@property (nonatomic,strong)  CCSequence* ccSequnce;
@property (nonatomic,strong)  CCSequence* ccSequnce2;
@property (nonatomic) bool isActionDone;
@property bool readyToEnd;

-(void)lock;
-(void)unlock;
-(Tile*)copyTile;
-(void)scaleToNone;
-(void)scaleToTileSize;
-(BOOL) nearTile: (Tile *)othertile;
-(void) trade:(Tile *)otherTile;
-(CGPoint) pixPosition;
@end
