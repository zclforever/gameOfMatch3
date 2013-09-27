//
//  const.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//
#import "cocos2d.h"


#ifndef gameOfMatch3_const_h
#define gameOfMatch3_const_h

#define zScoreLabelLeft 220.0f
#define zScoreLabelBottom 450.0f
#define zStatePanelWidth 180.0f
#define zStatePanel_LifeBarWidth 90.0f
#define zStatePanel_LifeBarHeight 40.0f
#define zStatePanel_LifeBarMarginLeft 5.0f
#define zStatePanel_LifeBarMarginTop 10.0f


#define zStatePanel_MagicLayerMarginLeft 100.0f
#define zStatePanel_MagicLayerMarginTop 155.0f
#define zStatePanel_MagicLayerWidth 40.0f
#define zStatePanel_MagicLayerHeight 40.0f
#define zStatePanel_MagicLayerSpace 5.0f
#define zMagicLayer_SpriteSize 32.0f


#define zStatePanel_ManaLayerHeight 80.0f
#define zStatePanel_ManaLayerWidth 100.0f
#define zStatePanel_ManaLayerMarginTop 120.0f

#define zStatePanel_ExpLabelMarginTop 10.0f
#define zStatePanel_MoneyLabelMarginTop 30.0f

#define Turn_Player 0
#define Turn_Enemy 1
#define zTileMaxAction 3;

#define kTileSize 40.0f
#define kMoveTileTime 0.2f
#define kBoxWidth 8
#define kBoxHeight 8

#define kMaxLevelNo 10
#define kMaxRecordCount 15
#define kKindCount 7

enum Orientation{
	OrientationHori,
	OrientationVert,
};
typedef enum Orientation Orientation;


#endif
@interface Global :CCLayer
+ (id)sharedManager;
+(id)menuOfBackTo:(CCScene*)scene;
@property float kStartX;
@property float kStartY;
@property int currentLevelOfGame;
@property (strong,nonatomic) NSMutableArray* nameOfGameLevelArray;
@end

