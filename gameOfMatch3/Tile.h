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
@property (nonatomic, readonly) int x, y;
@property (nonatomic) int value;
@property (nonatomic, retain) CCSprite *sprite;
-(BOOL) nearTile: (Tile *)othertile;
-(void) trade:(Tile *)otherTile;
-(CGPoint) pixPosition;
@end
