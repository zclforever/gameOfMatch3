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

@implementation DamageData
-(id)init{
    self=[super init];
    return self;
}

@end



@implementation AiObjectInteraction




+(DamageData*)physicalDamageBy:(AiObject*)attacker{
    DamageData* damageData=[[DamageData alloc]init];
    damageData.phsicalDamage=attacker.damage;
    return damageData;
    
}
+(DamageData*)magicalDamageBy:(AiObject*)attacker{  
    DamageData* damageData=[[DamageData alloc]init];
    damageData.magicalDamage=attacker.damage;
    return damageData;
}
+(NSDictionary*)finalDamageOn:(AiObject*)defenser withData:(DamageData*)damageData{
    NSMutableDictionary* ret=[[NSMutableDictionary alloc]init];
    float hp=-(damageData.phsicalDamage+damageData.magicalDamage);
    ret[@"hp"]=[NSNumber numberWithFloat:hp];
   
     //todo calc damage
    return ret;
}



//+(NSDictionary*)getFinalAttributeFromData:(InteractionData*)data{
//    AiObjectWithMagic* obj=data.owner ;
//    BuffHelper* buffHelper=obj.buffHelper;
//    StateValue value;
//    NSMutableDictionary* retDict=[[NSMutableDictionary alloc]init];
//
//    
//    Buff* buff;
//
//    //moveSpeed
//    float moveSpeed=[data.baseAttributeDict[@"moveSpeed"] floatValue];
//    
//    buff=[buffHelper getBuffByName:@"slow"];
//    if(buff){
//        value=[buff getStateByName:@"moveSpeed"];
//        moveSpeed=(attribute.moveSpeed+value.n)*value.p;
//    }
//    ret.moveSpeed=moveSpeed;
//    
//    return ret;
//}
//+(float)finalMoveSpeed:(AiObject*)obj{
//    return [self getFinalAttributeFromData:[InteractionData dataFromAiObject:obj]].moveSpeed;
//       
//}

@end
