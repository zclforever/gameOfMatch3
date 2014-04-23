//
//  const.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

/* 非线程安全的实现 */
/*
@implementation SomeManager

+ (id)sharedManager {
    static id sharedManager = nil;
    
    if (sharedManager == nil) {
        sharedManager = [[self alloc] init];
    }
    
    return sharedManager;
}
@end
*/

#import "Global.h"

@implementation DataBase

@end

/* 线程安全的实现 */
@implementation Global

static id sharedManager = nil;

+ (void)initialize {
    if (self == [Global class]) {
        sharedManager = [[self alloc] init];
        DataBase* dataBase=[[DataBase alloc]init];
        dataBase.skills=[sharedManager arrayFromPlist:@"skill.plist"];
        dataBase.heros=[sharedManager arrayFromPlist:@"hero.plist"];
        dataBase.enemys=[sharedManager arrayFromPlist:@"enemy.plist"];
        dataBase.levelData=[sharedManager arrayFromPlist:@"levelData.plist"];
        
        
        [sharedManager setDataBase:dataBase];

        
        
        [sharedManager setAllEnemys:[NSMutableArray arrayWithObjects:@"smallEnemy_mouse",@"smallEnemy_knight",@"smallEnemy_stoneMan", @"bossEnemy",nil]];
    }
}

+ (id)sharedManager {
    return sharedManager;
}

+(bool)rectInsect:(CGRect)rect1 :(CGRect)rect2{
    float distanceX=rect1.origin.x+rect1.size.width/2-rect2.origin.x-rect2.size.width/2;
    float distanceY=rect1.origin.y+rect1.size.height/2-rect2.origin.y-rect2.size.height/2;
    float widthMax=rect1.size.width/2+rect2.size.width/2;
    float heightMax=rect1.size.height/2+rect2.size.height/2;
    
    bool ret=(abs(distanceX)<=widthMax&&abs(distanceY)<=heightMax);

    return ret;
    
}

+(NSArray*)arrayFromPlist:(NSString*)plistName{
        return [NSMutableArray arrayWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:plistName]];
}
+(NSDictionary*)searchArray:(NSArray*)array whereKey:(NSString*)key isEqualToValue:(NSString*)value{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"%K == %@",key,value];
    return [array filteredArrayUsingPredicate:predicate][0];
    
}
+(id)menuOfBackTo:(CCScene*)scene{

    
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:18];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:scene];
    }];
    
    CCMenu* backMenu=[CCMenu menuWithItems:menuLabel, nil];
    backMenu.anchorPoint=ccp(0,0);
    backMenu.position = ccp(100,30);
    return backMenu;
}
@end