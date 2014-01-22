//
//  Magic.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-2.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Magic.h"
#import "Global.h"

@implementation Magic
+(NSMutableArray*)allMagicNameList{  //决定优先权
    return [
            [NSMutableArray alloc]initWithObjects:
            @"bigFireBall",@"snowBall",@"firedClear",@"hammer",
            @"iceBall",@"fireBall",@"bloodAbsorb",@"poison",
            
            
            nil];
}
+(NSMutableArray*)getNameListByPointDict:(NSDictionary*)pointDict{
    
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    
    for (NSString* name in [Magic allMagicNameList]) {

        int point=[[pointDict valueForKey:name] intValue];
        if (point>0) {
             [ret addObject:name];
        }
    }
    if (ret.count==0) {
        return nil;
    }
    return ret;
}
//+(NSMutableArray*)getNameListByPointDict:(NSDictionary*)pointDict{
//
//    NSMutableArray* ret=[[NSMutableArray alloc]init];
//    bool enough;
//    
//    for (NSString* name in [Magic allMagicNameList]) {
//        enough=YES;
//        Magic* magic=[[Magic alloc]initWithName:name];
//        for (int i=0; i<magic.needSkillPoint.count; i++) {
//            NSString* skillName=[NSString stringWithFormat:@"skill%d",i+1];
//            int point=[[pointDict valueForKey:skillName] intValue];
//            int needPoint=[magic.needSkillPoint[i] intValue];
//            if (point<needPoint) {
//                enough=NO;
//                break;
//            }
//        }
//        if (enough) {
//            [ret addObject:name];
//        }
//    }
//    if (ret.count==0) {
//        return nil;
//    }
//    return ret;
//}

+(NSString *)getNameByCountArray:(NSMutableArray *)manaArray withMagicNameList:(NSMutableArray*)magicNameList{
    if(!magicNameList) return nil;
    NSMutableArray* manaCostArray;
    bool enough;
    for (NSString* name in magicNameList) {
        Magic* magic=[[Magic alloc]initWithName:name];
        enough=YES;
        manaCostArray=magic.manaCostArray;
        for(int i=0;i<3;i++){
            if ([manaArray[i] intValue]<[manaCostArray[i] intValue]){
                enough=NO;
                break;
            }
        }
        if(enough){
            
            return name;
        }
    }

    return nil;
}

+(NSString *)getNameByCountArray:(NSMutableArray *)manaArray{
    return [Magic getNameByCountArray:manaArray withMagicNameList:[Magic allMagicNameList]];
    
}
-(Magic*)initWithID:(int)ID{
    NSString* name;
    switch (ID) {
        case 104:
            name=@"poison";
            break;
        case 102:
            name=@"fireBall";
            break;
        case 103:
            name=@"bloodAbsorb";
            break;
        case 101:
            name=@"iceBall";
            break;
        default:
            break;
    }
    self=[self initWithName:name];
    return self;
    
     
}

-(Magic*)initWithName:(NSString*)name{
    self=[super init];

    self.name=name;
    //蓝 红 黄
    
    NSDictionary* magicDict=[[Magic magicDict] valueForKey:name];
    self.showName=[magicDict valueForKey:@"showName"];
    self.damage=[[magicDict valueForKey:@"damage"] floatValue];
    self.needSkillPoint=[magicDict valueForKey:@"requirePoint"];
    self.manaCostArray=[magicDict valueForKey:@"cost"];
    
    return self;
    
    if ([name isEqualToString:@"firedClear"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=5;
        self.type=@"recover";
        self.CD=12.0f;
        self.showName=@"灭火";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@1,@0,@1,@1, nil];
        
        //蓝 红 黄       
    }

    
    return self;
}
+(NSDictionary*)magicDict{
    NSDictionary* magicDict=[NSDictionary dictionaryWithObjectsAndKeys:
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"bigFireBall",@"name",
                              @"流星火",@"showName",
                              @50.0,@"damage",
                              [NSArray arrayWithObjects:@0,@3,@0, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@0,@1,@0,@0, nil],@"cost",
                              nil],@"bigFireBall",

                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"fireBall",@"name",
                              @"火球",@"showName",
                              @3.0,@"damage",
                              [NSArray arrayWithObjects:@0,@1,@0, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@0,@4,@0,@0, nil],@"cost",
                              nil],@"fireBall",
                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"iceBall",@"name",
                              @"冰弹",@"showName",
                              @1.0,@"damage",
                              [NSArray arrayWithObjects:@1,@0,@0, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@4,@0,@0,@0, nil],@"cost",
                              nil],@"iceBall",
                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"bloodAbsorb",@"name",
                              @"南瓜吸吸",@"showName",
                              @1.0,@"damage",
                              [NSArray arrayWithObjects:@0,@0,@1, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@0,@0,@1,@0, nil],@"cost",
                              nil],@"bloodAbsorb",
                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"hammer",@"name",
                              @"光明之锤",@"showName",
                              @0.0,@"damage",
                              [NSArray arrayWithObjects:@0,@0,@3, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@0,@1,@2,@0, nil],@"cost",
                              nil],@"hammer",
                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"poison",@"name",
                              @"巫毒",@"showName",
                              @1.0,@"damage",
                              [NSArray arrayWithObjects:@0,@0,@0, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@0,@0,@0,@1, nil],@"cost",
                              nil],@"poison",
                             
                             
                             [NSDictionary dictionaryWithObjectsAndKeys:
                              @"snowBall",@"name",
                              @"雪崩",@"showName",
                              @2.0,@"damage",
                              [NSArray arrayWithObjects:@0,@0,@0, nil],@"requirePoint",
                              [NSArray arrayWithObjects:@1,@0,@0,@1, nil],@"cost",
                              nil],@"snowBall",
                             
                             nil];
    return magicDict;
}
@end
