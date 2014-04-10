//
//  AiObjectDataInteraction.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"
#import "Attribute.h"
@class AiObjectWithMagic;
@class AiObject;





@interface DamageData : NSObject{
    
}


@property (weak,nonatomic)id owner;
@property float phsicalDamage;
@property float magicalDamage;
//@property (strong,nonatomic) NSMutableDictionary* baseAttributeDict;

@end



@interface AiObjectInteraction : NSObject {
    
}
+(DamageData*)physicalDamageBy:(AiObject*)attacker;
+(DamageData*)magicalDamageBy:(AiObject*)attacker;


+(NSDictionary*)finalDamageOn:(AiObject*)defenser withData:(DamageData*)damageData;

//
//+(float)finalMoveSpeed:(AiObject*)obj;







@end
