//
//  AiObjectDataInteraction.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiObjectInteraction.h"
#import "AiObjectWithMagic.h"
#import "BuffHelper.h"

@implementation InteractionData
-(id)init{
    self=[super init];
    
//    self.bufferDict=[[NSMutableDictionary alloc]init];
//    self.commandArray=[[NSMutableArray alloc]init];

    return self;
}
+(InteractionData*)dataFromAiObject:(AiObject*)aiObject{
    InteractionData* ret=[[InteractionData alloc]init];
    AiObjectAttribute attr;
    attr.damage=aiObject.damage;
    ret.attribute=attr;
    return ret;
}
-(void)makeBuffData:(NSString *)buffName{
    //得到buff各种最终值
}

@end

@implementation AiObjectInteraction



+(void)addBufferTo:(InteractionData *)defenderData withName:(NSString*)name{
    //buff helper 只处理buff本身的增删改
    //interaction负责 buff交互 (无敌时免疫buff)
    //决定后去调用helper增减buff
    AiObjectWithMagic* obj=defenderData.owner ;
    Buff* buff;
    
    if ([name isEqualToString:@"slow"]) {
        buff=[[BuffSlow alloc]init];
        
        [obj.buffHelper addBuffWith:buff];
    }
    
    
    
}

+(float)attackFrom:(InteractionData *)attackerData to:(InteractionData *)defenderData{
    float damage;
    damage=attackerData.attribute.damage;  //todo calc damage
    return damage;
}

+(NSDictionary*)getFinalAttributeFrom:(AiObject*)obj withName:(NSString*)name{
    
}

+(AiObjectAttribute)getFinalAttributeFromData:(InteractionData*)data{
    AiObjectWithMagic* obj=data.owner ;
    BuffHelper* buffHelper=obj.buffHelper;
    AiObjectAttribute attribute=data.attribute;
    StateValue value;
    
    AiObjectAttribute ret;
    
    Buff* buff;

    //moveSpeed
    float moveSpeed=attribute.moveSpeed;
    
    buff=[buffHelper getBuffByName:@"slow"];
    if(buff){
        value=[buff getStateByName:@"moveSpeed"];
        moveSpeed=(attribute.moveSpeed+value.n)*value.p;
    }
    ret.moveSpeed=moveSpeed;
    
    return ret;
}
+(float)getFinalMoveSpeed:(AiObject*)obj{
    return [self getFinalAttributeFromData:[InteractionData dataFromAiObject:obj]].moveSpeed;
       
}

@end
