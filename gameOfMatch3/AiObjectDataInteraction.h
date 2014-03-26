//
//  AiObjectDataInteraction.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"

@class AiObject;

@interface InteractionData : NSObject{
    
}
@property (weak,nonatomic)AiObject* owner;


-(void)makeBuffData:(NSString *)buffName;
@end


@interface AiObjectDataInteraction : NSObject {
    
}
+(InteractionData*)makeDataWith:(AiObject*)object;
+(void)attackFrom:(InteractionData*)attackerData to:(InteractionData*)defenderData;

+(void)addBufferFrom:(InteractionData *)attackerData to:(InteractionData *)defenderData;

@end
