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
        dataBase.skills=[Global arrayFromPlist:@"skill.plist"];
        dataBase.heros=[Global arrayFromPlist:@"hero.plist"];
        dataBase.enemys=[Global arrayFromPlist:@"enemy.plist"];
        dataBase.levelData=[Global arrayFromPlist:@"levelData.plist"];
        dataBase.itemDelegate=[Global arrayFromPlist:@"itemDelegate.plist"];
        dataBase.buffs=[Global arrayFromPlist:@"buff.plist"];
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
+(NSString*) stringID:(id)object{
    return [NSString stringWithFormat:@"%d",(int)object];
}
+(NSArray*)arrayFromPlist:(NSString*)plistName{
        return [NSMutableArray arrayWithContentsOfFile:[[CCFileUtils sharedFileUtils] fullPathForFilename:plistName]];
}
+(NSArray*)searchArray:(NSArray*)array whereKey:(NSString*)key isEqualToValue:(id)value{
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"%K == %@",key,value];
    NSArray* ret= [array filteredArrayUsingPredicate:predicate];
    if(ret.count==0){
        NSString* show=[value isKindOfClass:[NSString class]]?value:[NSString stringWithFormat:@"%d",[(NSNumber*)value intValue]];
        NSLog(@"%@",show);
    }
    return ret;
    
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