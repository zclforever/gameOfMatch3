//
//  GameMoneyBuyLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameMoneyBuyLayer.h"
#import "Person.h"
#import "GameMainLayer.h"

@implementation GameMoneyBuyLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GameMoneyBuyLayer *layer = [GameMoneyBuyLayer node];
    
	[scene addChild: layer];
    
	return scene;
}
- (id)init
{
    self = [super init];
    if (self) {
        int fontSize=18;
        
        NSMutableArray* menuItemArray=[[NSMutableArray alloc]init];
        CCLabelTTF* label;
        CCMenuItemLabel* menuLabel;
        label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:36];
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
        
        int hpPlus=[[person.moneyBuyDict valueForKey:@"hpPlus"] intValue];
        int shakeStopFire=[[person.moneyBuyDict valueForKey:@"shakeStopFire"] intValue];
        int moneyLeft=person.money;
        int hpPlusNeedMoney=(hpPlus+10)*(hpPlus+10)/2;
        int shakeStopFireNeedMoney=250;
        
        
        CCMenu* backMenu=[CCMenu menuWithArray:menuItemArray];
        //CCMenu* backMenu=[CCMenu menuWithItems:menuItemArray[0],menuItemArray[1],nil];
        backMenu.anchorPoint=ccp(0,0);
        backMenu.position = ccp(100,30);
        [backMenu alignItemsHorizontallyWithPadding:80.0f];
        [self addChild:backMenu z:4];
        
        
        int labelHeight=280;
        int labelLeft=70;
        int labelSpace=100;
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"血量+ %d",hpPlus+10] fontName:@"Arial" fontSize:fontSize];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            
            if (moneyLeft>=hpPlusNeedMoney) {
                person.money-=hpPlusNeedMoney;
                [person.moneyBuyDict setValue:[NSNumber numberWithInt:hpPlus+10] forKey:@"hpPlus"];
                [[CCDirector sharedDirector]replaceScene:[GameMoneyBuyLayer scene]];
            }
            
        }];
        CCMenu* menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(labelLeft,labelHeight);
        [self addChild:menu];
        
        
        NSString* shakeStopFireStr;
        if (shakeStopFire==0) {
            shakeStopFireStr=@"摇动灭火";
        }else{
            shakeStopFireStr=@"摇动可灭火";
            shakeStopFireNeedMoney=0;
        }
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",shakeStopFireStr] fontName:@"Arial" fontSize:fontSize];
        
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            if (shakeStopFire==0) {
                if (moneyLeft>=shakeStopFireNeedMoney) {
                    person.money-=shakeStopFireNeedMoney;
                    [person.moneyBuyDict setValue:[NSNumber numberWithInt:shakeStopFire+1] forKey:@"shakeStopFire"];
                    [[CCDirector sharedDirector]replaceScene:[GameMoneyBuyLayer scene]];
                }
            }
        }];
        menu=[CCMenu menuWithItems:menuLabel, nil];
        menu.position=ccp(labelLeft+labelSpace,labelHeight);
        [self addChild:menu];
        
        
        
        
        
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"剩余金钱数 %02d",moneyLeft] fontName:@"Arial" fontSize:fontSize];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(150,350);
        [self addChild:label];
        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d金",hpPlusNeedMoney] fontName:@"Arial" fontSize:fontSize];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(labelLeft,labelHeight-30);
        [self addChild:label];

        
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d金",shakeStopFireNeedMoney] fontName:@"Arial" fontSize:fontSize];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(labelLeft+labelSpace,labelHeight-30);
        [self addChild:label];
        
    }
    return self;
}

@end
