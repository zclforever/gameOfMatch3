//
//  GameMainLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-9.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameMainLayer.h"
#import "GameLevelLayer.h"
#import "StateLayer.h"
#import "GamePointLayer.h"

@implementation GameMainLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GameMainLayer *layer = [GameMainLayer node];
    
	[scene addChild: layer];
	
	return scene;
}
-(id) init
{
    //self=[super initWithColor:ccc4(255, 0, 255, 80)];
    self=[super init];
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"rainFall.plist"];
    
    [self addChild:particle_system];
    
    NSMutableArray* menuItemArray=[[NSMutableArray alloc]init];
    CCLabelTTF* label;
    CCMenuItemLabel* menuLabel;
    label = [CCLabelTTF labelWithString:@"战斗" fontName:@"Arial" fontSize:28];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[GameLevelLayer scene]];
    }];
    
    [menuItemArray addObject:menuLabel];
    
    
    
    label = [CCLabelTTF labelWithString:@"加点" fontName:@"Arial" fontSize:28];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
    }];
    
    [menuItemArray addObject:menuLabel];
    
    
    
    label = [CCLabelTTF labelWithString:@"人物" fontName:@"Arial" fontSize:28];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[StateLayer sceneWith:[Person sharedPlayer]]];
    }];
    
    //[menuItemArray addObject:menuLabel];
    
    
    
    
    CCMenu* backMenu=[CCMenu menuWithArray:menuItemArray];
    //CCMenu* backMenu=[CCMenu menuWithItems:menuItemArray[0],menuItemArray[1],nil];
    backMenu.anchorPoint=ccp(0,0);
    backMenu.position = ccp(100,30);
    [backMenu alignItemsHorizontallyWithPadding:80.0f];
    [self addChild:backMenu z:4];
    
    

    return self;
}
@end
