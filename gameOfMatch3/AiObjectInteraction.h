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
@class AiObjectWithMagic;
@class AiObject;


@interface InteractionData : NSObject{
    
}
    @property (weak,nonatomic)id owner;
    @property  AiObjectAttribute attribute;

+(InteractionData*)dataFromAiObject:(AiObject*)aiObject;

-(void)makeBuffData:(NSString *)buffName;

@end




@interface AiObjectInteraction : NSObject {
    
}
+(float)attackFrom:(InteractionData*)attackerData to:(InteractionData*)defenderData;

+(void)addBufferTo:(InteractionData *)defenderData withName:(NSString*)name;





+(float)getFinalMoveSpeed:(AiObject*)obj;







@end
