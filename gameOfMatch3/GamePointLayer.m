//
//  GamePointLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-11-29.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GamePointLayer.h"
#import "GameMainLayer.h"
#import "Person.h"

@implementation GamePointLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GamePointLayer *layer = [GamePointLayer node];
    
	[scene addChild: layer];
    
	
	return scene;
}
- (id)init
{
    self = [super init];
    if (self) {
        NSMutableArray* menuItemArray=[[NSMutableArray alloc]init];
        CCLabelTTF* label;
        CCMenuItemLabel* menuLabel;
        label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            [[CCDirector sharedDirector]replaceScene:[GameMainLayer scene]];
        }];
        
        [menuItemArray addObject:menuLabel];
        
        __block Person* person=[Person sharedPlayer];
        
        int point1=[[person.pointDict valueForKey:@"skill1"] intValue];
        int point2=[[person.pointDict valueForKey:@"skill2"] intValue];
        int point3=[[person.pointDict valueForKey:@"skill3"] intValue];
        int totalStar=0;
        for (int i=0; i<100; i++) {
            totalStar+=[person.starsOfLevelArray[i] intValue];
        }
        
        int leftPoint=totalStar-(point1+point2+point3)*3;
        
        
        
        label = [CCLabelTTF labelWithString:@"重置" fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            [person.pointDict setValue:@0 forKey:@"skill1"];
            [person.pointDict setValue:@0 forKey:@"skill2"];
            [person.pointDict setValue:@0 forKey:@"skill3"];
            
            [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
        }];
        
        [menuItemArray addObject:menuLabel];
            
        
        
        CCMenu* backMenu=[CCMenu menuWithArray:menuItemArray];
        //CCMenu* backMenu=[CCMenu menuWithItems:menuItemArray[0],menuItemArray[1],nil];
        backMenu.anchorPoint=ccp(0,0);
        backMenu.position = ccp(100,30);
        [backMenu alignItemsHorizontallyWithPadding:80.0f];
        [self addChild:backMenu z:4];
        
        
        int labelHeight=200;
        int labelLeft=60;
        int labelSpace=100;

        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"寒冰 %d",point1] fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        
            if (point1<3&&leftPoint>=3) {
                 [person.pointDict setValue:[NSNumber numberWithInt:point1+1] forKey:@"skill1"];
                [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
            }
            
        }];
        CCMenu* menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(labelLeft,labelHeight);        
        [self addChild:menu];
        
        
        
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"火神 %d",point2] fontName:@"Arial" fontSize:28];

        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            if (point2<3&&leftPoint>=3) {
                [person.pointDict setValue:[NSNumber numberWithInt:point2+1] forKey:@"skill2"];
                [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
            }
        }];
        menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(labelLeft+labelSpace,labelHeight);        
        [self addChild:menu];
        
        
        
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"南瓜 %d",point3] fontName:@"Arial" fontSize:28];

        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            if (point3<3&&leftPoint>=3) {
                [person.pointDict setValue:[NSNumber numberWithInt:point3+1] forKey:@"skill3"];
                [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
            }
        }];
        menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(labelLeft+labelSpace*2,labelHeight);        
        [self addChild:menu];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"剩余点数 %02d",leftPoint] fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(150,300);
        [self addChild:label];
        
        
    }
    return self;
}
@end
