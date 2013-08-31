//
//  const.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#ifndef gameOfMatch3_const_h
#define gameOfMatch3_const_h


#define Turn_Player 0
#define Turn_Enemy 1

#define kTileSize 35.0f
#define kMoveTileTime 0.2f
#define kBoxWidth 8
#define kBoxHeight 8

#define kMaxLevelNo 10
#define kMaxRecordCount 15
#define kKindCount 3

enum Orientation{
	OrientationHori,
	OrientationVert,
};
typedef enum Orientation Orientation;


#endif
@interface consts : NSObject
+ (id)sharedManager;
@property float kStartX;
@property float kStartY;
@end

