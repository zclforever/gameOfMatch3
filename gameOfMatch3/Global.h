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

#define zMagicCD 1.0f

#define zPlayerMarginLeft 20.0f
#define zPlayerMarginTop 150.0f
#define zEnemyMarginLeft 240.0f

#define zPersonWidth 60.0f
#define zPersonHeight 60.0f
#define zStatePanel_MagicBorderMarginBottom 320.0f
#define zStatePanel_MagicBorderHeight 60.0f

#define zScoreLabelLeft 220.0f
#define zScoreLabelBottom 1450.0f
#define zStatePanelWidth 180.0f
#define zStatePanel_LifeBarWidth 60.0f
#define zStatePanel_LifeBarHeight 8.0f
#define zStatePanel_LifeBarMarginLeft 5.0f
#define zStatePanel_LifeBarMarginTop 10.0f


#define zStatePanel_MagicLayerMarginLeft 100.0f
#define zStatePanel_MagicLayerMarginTop 150.0f
#define zStatePanel_MagicLayerWidth 40.0f
#define zStatePanel_MagicLayerHeight 40.0f
#define zStatePanel_MagicLayerSpace 8.0f
#define zMagicLayer_SpriteSize 32.0f


#define zStatePanel_ManaLayerHeight 80.0f
#define zStatePanel_ManaLayerWidth 100.0f
#define zStatePanel_ManaLayerMarginTop 155.0f
#define zStatePanel_ManaLayerMarginLeft 30.0f
#define zStatePanel_ManaLayerSpace 5.0f

#define zStatePanel_ExpLabelMarginTop -10.0f
#define zStatePanel_MoneyLabelMarginTop -30.0f

#define Turn_Player 0
#define Turn_Enemy 1
#define zTileMaxAction 3;

#define kTileSize 50.0f
#define kMoveTileTime 0.2f
#define kBoxWidth 6
#define kBoxHeight 6

#define kMaxLevelNo 10
#define kMaxRecordCount 15
#define kKindCount 5

#define Tag_skillMenu 10

enum Orientation{
	OrientationHori,
	OrientationVert,
};
typedef enum Orientation Orientation;


#endif
@interface Global :CCLayer
+ (id)sharedManager;
+(id)menuOfBackTo:(CCScene*)scene;
@property int debugTest;
@property float kStartX;
@property float kStartY;
@property int currentLevelOfGame;
@property (strong,nonatomic) NSString* lastSelectedString;
@property (strong,nonatomic) NSMutableArray* nameOfGameLevelArray;
@property (strong,nonatomic) CCSprite* setTimeOut;
@end

