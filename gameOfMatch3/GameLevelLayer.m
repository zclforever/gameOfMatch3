//
//  GameLevelLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-9.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameLevelLayer.h"
#import "BattleLayer.h"
#import "GameMainLayer.h"
#import "Global.h"
@interface GameLevelLayer()


@end
@implementation GameLevelLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GameLevelLayer *layer = [GameLevelLayer node];
    
	[scene addChild: layer];
	
	return scene;
}
-(id) init
{
    self=[super initWithColor:ccc4(255, 0, 255, 80)];
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:18];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[GameMainLayer scene]];
    }];
    
    CCMenu* backMenu=[CCMenu menuWithItems:menuLabel, nil];
    backMenu.anchorPoint=ccp(0,0);
    backMenu.position = ccp(100,30);
    [self addChild:backMenu z:4];
    
    
    
    label=[CCLabelTTF labelWithString:@"选择关卡" fontName:@"Arial" fontSize:48];
    label.position=ccp(self.contentSize.width/2,self.contentSize.height-50);
    [self addChild:label];
    NSMutableArray* menuArray=[[NSMutableArray alloc]init];
    NSMutableArray* nameOfGameLevelArray=nil;
    if (![[Global sharedManager] nameOfGameLevelArray]) {
        nameOfGameLevelArray=[[NSMutableArray alloc]init];
        [[Global sharedManager] setNameOfGameLevelArray:nameOfGameLevelArray];
    }
    for (int j=0; j<6; j++) {
        
        [menuArray removeAllObjects];
        for (int i=0; i<5; i++) {
            int level=j*5+i+1;
            NSString* name=[NSString stringWithFormat:@"第%02d关",level];
            if (nameOfGameLevelArray) {
                [nameOfGameLevelArray addObject:name];
            }else{
                name=[[Global sharedManager] nameOfGameLevelArray][level-1];
            }
            CCLabelTTF* levelLabel = [CCLabelTTF labelWithString:name fontName:@"Arial" fontSize:12];
            
            levelLabel.opacity=250;
            levelLabel.color = ccc3(255,255,230);
            CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:levelLabel block:^(id sender) {
                [[Global sharedManager] setCurrentLevelOfGame:level];
                [[CCDirector sharedDirector] replaceScene:[BattleLayer sceneWithLevel:level]];
            }];
            
            
            [menuArray addObject:menuLabel];
            
            
        }
        CCMenu* menu=[CCMenu menuWithArray:menuArray];
        menu.anchorPoint=ccp(0,0);
        menu.position=ccp(250,self.contentSize.height-40-(j+1)*40);
        [menu alignItemsHorizontallyWithPadding:20.0f];
        [self addChild:menu];
        
    }
    
    //    NSMutableArray* menuArray=[[NSMutableArray alloc]init];
    //    for (int j=0; j<6; j++) {
    //
    //        [menuArray removeAllObjects];
    //        for (int i=0; i<5; i++) {
    //
    //            CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"enemy_%d.png",i%4+1]];
    //
    //
    //            CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemWithNormalSprite:sprite selectedSprite:nil block:^(id sender) {
    //                [[CCDirector sharedDirector] replaceScene:[BattleLayer sceneWithLevel:i+1]];
    //            }];
    //            menuSprite.scale=30/menuSprite.contentSize.height;
    //            [menuArray addObject:menuSprite];
    //
    //
    //        }
    //        CCMenu* menu=[CCMenu menuWithArray:menuArray];
    //        menu.anchorPoint=ccp(0,0);
    //        menu.position=ccp(250,self.contentSize.height-40-(j+1)*40);
    //        [menu alignItemsHorizontallyWithPadding:20.0f];
    //        [self addChild:menu];
    //        
    //    }
    return self;
}
@end
