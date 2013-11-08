//
//  Tile.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"

@interface Tile : CCLayer
{
    int x, y, value;
	
}
-(id) initWithX: (int) posX Y: (int) posY;
@property (nonatomic) int x, y;
@property (nonatomic) int value;
@property (nonatomic, strong) CCSprite *sprite;
@property (nonatomic,strong) NSMutableArray* actionSequence;
@property (nonatomic,strong)  CCSequence* ccSequnce;
@property (nonatomic,strong)  CCSequence* ccSequnce2;
@property (nonatomic) bool isActionDone;
@property bool readyToEnd;
@property bool selected;
@property int skillBall;  // 看是消掉的等同于几个球。。过渡  已作废 （起初是以消掉个数来计量球的大波，后来以技能球的数量来决定技能大小
-(void)lock;
-(void)unlock;
-(Tile*)copyTile;
-(void)scaleToNone;
-(void)scaleToTileSize;
-(BOOL) nearTile: (Tile *)othertile;
-(void) trade:(Tile *)otherTile;
-(CGPoint) pixPosition;
-(CCAction*)disappareAction;
-(CCAction*)appareAction;
@end
