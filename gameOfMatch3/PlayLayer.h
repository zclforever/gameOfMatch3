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
#import "StatePanelLayerInBattle.h"
#import "GameOverLayer.h"
#import "Person.h"
#import "ManaLayer.h"
#import "Player.h"
#import "BossEnemy.h"
@interface MyPoint:NSObject{
    
}
-(id)initWithX:(int)x Y:(int)y;
@property int x;
@property int y;
@end

@interface PlayLayer : CCLayer <UIAccelerometerDelegate>{
	Box *box;
	//Tile *selectedTile;
	Tile *firstOne;
    AI *ai;
}

//@property (strong,nonatomic) StatePanelLayerInBattle* statePanelLayerPlayer;
//@property (strong,nonatomic) StatePanelLayerInBattle* statePanelLayerEnemy;
@property (strong,nonatomic) Person* player;
@property (strong,nonatomic) BossEnemy* enemy;
@property (strong,nonatomic) NSMutableArray* tileDelegateArray;
@property (strong,nonatomic) NSMutableArray* heroArray;
@property int gameLevel; //第几关



-(bool) changeWithTileA: (Tile *) a TileB: (Tile *) b;
//-(void) check: (id) sender data: (id) data;

-(id)initWithLevel:(int)level;
@end
