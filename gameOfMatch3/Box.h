//
//  Box.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Global.h"
#import "Tile.h"
@interface Box : NSObject
{
	id first, second;
	CGSize size;
	NSMutableArray *content;
	BOOL lock;
    NSMutableSet *readyToRemoveTiles;
	CCLayer *layer;
	Tile *OutBorderTile;
    BOOL allMoveDone;
}
@property(nonatomic) BOOL allMoveDone;
@property(nonatomic, retain) CCLayer *layer;
@property(nonatomic, strong) CCSprite* lockedEnemy;
@property(nonatomic, strong) CCSprite* lockedPlayer;
@property(nonatomic, readonly) CGSize size;
@property(nonatomic) BOOL lock;
@property(nonatomic,retain) NSMutableSet *readyToRemoveTiles;
@property(nonatomic,strong) NSMutableArray *removeResultArray;
@property bool isSoundEnabled;
-(id) initWithSize: (CGSize) size factor: (int) factor;
-(Tile *) objectAtX: (int) posX Y: (int) posY;
-(BOOL) check;
-(BOOL)removeAndRepair;
-(void) unlock;
-(void) removeSprite: (id) sender;
-(void) afterAllMoveDone;


-(int) pushTilesToRemoveForValue:(int)value;  //magic


-(void) swapWithTile:(Tile*)a B:(Tile*)b;
-(NSMutableArray*) findMatchWithSwap:(Tile*)A B:(Tile*)B;
-(NSMutableArray*) scanSwapMatch;
-(NSMutableArray*) findMatchAtRowIndex:(int)rowIndex;
-(NSMutableArray*) findMatchAtColumnIndex: (int) columnIndex;
-(NSArray*) findMatchedSwapArray:(NSArray*)matchedArray forValue:(int)value;
-(NSArray*) findMatchedArray:(NSArray*)matchedArray forValue:(int)value;
//-(BOOL) haveMore;
@end
