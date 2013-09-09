//
//  GameLevelLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-9.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameLevelLayer.h"
#import "BattleLayer.h"

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
    
    CCLabelTTF* label=[CCLabelTTF labelWithString:@"选择关卡" fontName:@"Arial" fontSize:48];
    label.position=ccp(self.contentSize.width/2,self.contentSize.height-50);
    [self addChild:label];
    
    NSMutableArray* menuArray=[[NSMutableArray alloc]init];
    for (int i=0; i<4; i++) {
            
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"enemy_%d.png",i+1]];


        CCMenuItemSprite* menuSprite=[CCMenuItemSprite itemWithNormalSprite:sprite selectedSprite:nil block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[BattleLayer sceneWithLevel:i+1]];
        }];
        menuSprite.scale=120/menuSprite.contentSize.height;
        [menuArray addObject:menuSprite];
        
        
    }
    CCMenu* menu=[CCMenu menuWithArray:menuArray];
    menu.anchorPoint=ccp(0,0);
    menu.position=ccp(250,self.contentSize.height/2);
    [menu alignItemsHorizontallyWithPadding:20];
    [self addChild:menu];
    return self;
}
@end
