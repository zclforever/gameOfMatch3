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
            @"bigFireBall",@"firedClear",@"hammer",
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
    self.needSkillPoint=[NSMutableArray arrayWithObjects:@0,@0,@0, nil];
    int value;
    //蓝 红 黄
    
    if ([name isEqualToString:@"bigFireBall"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=5;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"炎爆术";
        self.needSkillPoint=[NSMutableArray arrayWithObjects:@0,@3,@0, nil];
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@3,@0,@0, nil];
        
        
    }
    
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
   
    if ([name isEqualToString:@"hammer"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=5;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"圣锤";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@1,@2,@0, nil];
        
        
    }
    
    if ([name isEqualToString:@"fireBall"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=2;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"火球";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@1,@0,@0, nil];

        
    }
    
    if ([name isEqualToString:@"iceBall"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=4;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"冰弹";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@1,@0,@0,@0, nil];
        
        
    }
    if ([name isEqualToString:@"poison"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=1;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"毒气";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@0,@0,@1, nil];
        
        
    }
    if ([name isEqualToString:@"bloodAbsorb"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=3;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"吸血";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@0,@1,@0, nil];
        
        
    }
    if ([name isEqualToString:@"magicAttackType_1"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=value;
        self.type=@"magicAttack";
        self.CD=12.0f;
        self.showName=@"魔法集齐自动攻击";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@4,@1,@1,@1, nil];

    }
    //    range=[name rangeOfString:@"removeValue_"];
    //    if (range.location!=NSNotFound) {
    //        value=[name substringFromIndex:range.length];
    //        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",value]];
    //        //sprite.position=ccp(zStatePanel_LifeBarWidth/2,self.contentSize.height/2+50);
    //        //        sprite.scaleX=24.0f/sprite.contentSize.width;
    //        //        sprite.scaleY=24.0f/sprite.contentSize.height;
    //        //[self addChild:sprite];
    //        self.sprite=sprite;
    //        self.value=value;
    //        self.type=@"removeValue";
    //    }
    
    
    
    return self;
}

@end
