//
//  AiObjectDataInteraction.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiObjectDataInteraction.h"

@implementation InteractionData
-(id)init{
    self=[super init];
    
//    self.bufferDict=[[NSMutableDictionary alloc]init];
//    self.commandArray=[[NSMutableArray alloc]init];
    return self;
}

-(void)makeBuffData:(NSString *)buffName{
    //得到buff各种最终值
}

@end

@implementation AiObjectDataInteraction

+(InteractionData*)makeDataWith:(AiObject*)object{
    InteractionData* data=[[InteractionData alloc]init];
    data.owner=object;
    return data;
}

+(void)addBufferFrom:(InteractionData *)attackerData to:(InteractionData *)defenderData{
    //这一层 加入buff的种类
    defenderData.owner
}

+(void)attackFrom:(InteractionData *)attackerData to:(InteractionData *)defenderData{
    
    attackerData.owner.curHP-=defenderData.owner.damage;  //todo calc damage
}

@end
