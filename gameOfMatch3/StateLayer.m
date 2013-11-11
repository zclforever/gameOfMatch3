//
//  StateLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-9.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "StateLayer.h"
#import "Global.h"
#import "GameMainLayer.h"
@implementation StateLayer
+(CCScene *) sceneWith:(Person*)person
{
    
	CCScene *scene = [CCScene node];
	
	StateLayer *layer = [[StateLayer alloc]initWith:person];
    
	[scene addChild: layer];
	
	return scene;
}
-(id) initWith:(Person*)person
{

	if( (self=[super init]) ) {
    
        NSMutableArray* labelArray=[[NSMutableArray alloc]init];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label ;
        int padding=40;
        for(int i=0;i<6;i++){
            label= [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:28];
            label.color = ccc3(255,255,0);
            label.position = ccp(winSize.width/2+10, winSize.height-padding*(i+1));
            [self addChild:label];
            [labelArray addObject:label];
            
        }



        [labelArray[0] setString:[NSString stringWithFormat:@"等级:%d",person.lv]];
        [labelArray[1] setString:[NSString stringWithFormat:@"金线:%d",person.money]];
        [labelArray[2] setString:[NSString stringWithFormat:@"魔伤:%d",person.magicDamage]];
        [labelArray[3] setString:[NSString stringWithFormat:@"血量:%d",(int)person.maxHP]];
        [labelArray[4] setString:[NSString stringWithFormat:@"经验:%d",person.experience]];
        [labelArray[5] setString:[NSString stringWithFormat:@"下一级需:%d",[person expToNextLV]]];

    }
    [self addChild:[Global menuOfBackTo:[GameMainLayer scene]]];
    
    return self;
}

@end
