//
//  ProjectileAI.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Projectile.h"
#import "AiObject.h"

@interface AiBehavior : NSObject<ProjectileAiDelegate> {
    
}
-(id)initWithOwner:(AiObject*)obj;
-(void)start;
@property bool started;
@property (nonatomic,weak) AiObject* owner;
@property (nonatomic,strong) NSString* name;
@end



//LinearMoveToPosition

@interface AiLinearMoveToPosition:AiBehavior{
    
}
-(id)initWithOwner:(AiObject *)obj withPosition:(CGPoint)position;
@property CGPoint destPostion;
@end



//InstantRangeAttasck
@interface AiInstantRangeAttack:AiBehavior{
    
}
-(id)initWithOwner:(AiObject *)obj totalHit:(int)totalHit maxHitPerEntity:(int)maxHitPerEntity;
@property int totalHit;
@property int hitCount;
@property int maxHitPerEntity;
@end



//DieWhen
@interface AiDieWhen:AiBehavior{
    
}
@property (nonatomic,strong) NSMutableArray* messageArray;
@property (nonatomic,strong) NSMutableDictionary* messageArrived;
@end
