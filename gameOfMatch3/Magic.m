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
+(NSString *)getNameByCountArray:(NSMutableArray *)countArray{
    NSString* name;
    NSMutableArray* magicCostArray;
    bool enough=NO;
    
    
    magicCostArray=[NSMutableArray arrayWithObjects:@1,@0,@2,@0, nil];
    name=@"hammer";
    enough=YES;
    for(int i=0;i<4;i++){
        if ([countArray[i] intValue]<[magicCostArray[i] intValue]){
            enough=NO;break;
        }
    }
    if(enough)return name;
    

    
    return nil;
    
}
-(Magic*)initWithID:(int)ID{
    NSString* name;
    switch (ID) {
        case 101:
            name=@"poison";
            break;
        case 102:
            name=@"fireBall";
            break;
        case 103:
            name=@"bloodAbsorb";
            break;
        case 104:
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
    int value;
    
    if ([name isEqualToString:@"hammer"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=5;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"圣锤";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@1,@0,@2,@0, nil];
        
        
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
        self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@0,@0,@1, nil];
        
        
    }
    if ([name isEqualToString:@"poison"]) {
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"transparent.png"]];
        self.sprite=sprite;
        self.value=1;
        self.type=@"damage";
        self.CD=12.0f;
        self.showName=@"毒气";
        self.manaCostArray=[NSMutableArray arrayWithObjects:@1,@0,@0,@0, nil];
        
        
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
