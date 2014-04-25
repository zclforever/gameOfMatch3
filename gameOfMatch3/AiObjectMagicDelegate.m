//
//  AiObjectMagicDelegate.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

//magic类 知道自己的对象是谁 群攻还是单攻

#import "AiObjectMagicDelegate.h"
#import "AiObjectWithMagic.h"

@implementation AiObjectMagicDelegate
-(id)initWithOwner:(id<MagicProtocol>) obj{
    self=[super init];
    self.owner=obj;

    return self;
}
-(NSDictionary*)magicDataByName:(NSString *)name{
    return [Global searchArray:[[[Global sharedManager]dataBase] skills] whereKey:@"name" isEqualToValue:name][0];
}
-(NSDictionary*)skillDataFromOwnerByName:(NSString*)name{
    return [Global searchArray:self.owner.attributeDatabase[@"skills"] whereKey:@"name" isEqualToValue:name][0];
}
-(void)magicAttackWithName:(NSString *)magicName{
    [self magicAttackWithName:magicName withParameter:nil];
}

-(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{

    NSString* name=magicName;
    Projectile* projectile;
    //AiBehavior* projectileAi;
    CGPoint selfPosition=[self.owner getCenterPoint];
    NSArray* targetsArray=[NSArray arrayWithArray:self.owner.findTargetsResult[@"attackRadius"]];
    bool noTarget=(!targetsArray||targetsArray.count==0)?YES:NO;
    AiObject* target;
    if (!noTarget) {target=targetsArray[0];}
    
    DamageData* damageData=[[DamageData alloc]init];
    NSDictionary* skillDamageDict=[self skillDataFromOwnerByName:name][@"damage"];
    
    Attribute* physicalDamage=[[Attribute alloc]init];
    physicalDamage.value=[skillDamageDict[@"physicalDamage"] floatValue];
    [physicalDamage addWithAttribute:self.owner.physicalDamage];
    
    Attribute* magicalDamage=[[Attribute alloc]init];
    magicalDamage.value=[skillDamageDict[@"magicalDamage"] floatValue];
    [magicalDamage addWithAttribute:self.owner.magicalDamage];
    
    if ([name isEqualToString:@"skill_physicalAttack"]) {
        if (target) {
            damageData.phsicalDamage=[physicalDamage finalValue];
            [target hurtByObject:damageData];
        }
    }
    
    else if ([name isEqualToString:@"skill_fury"]){

            AiObjectWithMagic* obj=(AiObjectWithMagic*)self.owner;
            Buff* buff=[[BuffFury alloc]initWithBuffHelper:obj.buffHelper];
            [buff add];
            return;
    }
    
    else if([name isEqualToString:@"skill_bigFireBall"]){
        projectile=[[BigFireBall alloc]initWithAllObjectArray:self.owner.allObjectsArray withPostion:ccp(100,460) byName:name];
        //projectileAi=[[ProjectileAiWithTargetPosition alloc] initWithDestPosition:ccp(zEnemyMarginLeft,480-zPlayerMarginTop+zPersonHeight/2) withOwner:projectile] ;
         
        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
        
    }
    
    
    else if([name isEqualToString:@"skill_fireBall"]){
        projectile=[[FireBall alloc]initWithAllObjectArray:self.owner.allObjectsArray withPostion:selfPosition byName:name];
        
        if (noTarget) {
            //projectileAi=[[ProjectileAiWithNoTarget alloc]initWithOwner:projectile];
           
        }else{
            //projectileAi=[[ProjectileAiWithTargets alloc] initWithTargets:targetsArray withOwner:projectile];
        }

        [[SimpleAudioEngine sharedEngine] playEffect:@"fire_fly.wav"];
   
    }
    
    else if([name isEqualToString:@"skill_iceBall"]){
        CGPoint startPosition=ccp(selfPosition.x+zPersonWidth+5,selfPosition.y+zPersonHeight/2-10);
        CGPoint destPosition=ccp(zEnemyMarginLeft,selfPosition.y+zPersonHeight/2-10);
        
        projectile=[[IceBall alloc] initWithAllObjectArray:self.owner.allObjectsArray
                                               withPostion:startPosition
                                                    byName:name];
        
        
        NSDictionary* iceBallData=[self magicDataByName:name];
        AiBehavior* aiBehavior;
        for (NSDictionary* behaviorData in iceBallData[@"behaviors"]) {
            NSString* behaviorType=behaviorData[@"type"];
            if ([behaviorType isEqualToString:@"LinearMoveToPosition"]) {
                aiBehavior=[[AiLinearMoveToPosition alloc]initWithOwner:projectile withPosition:destPosition];
                [projectile pushAiBeharvior:aiBehavior];
            }
            
            else if ([behaviorType isEqualToString:@"InstantRangeAttack"]){
                int maxHit=[behaviorData[@"max_hit"] intValue];
                int maxHitPerEntity=[behaviorData[@"max_hit_per_entity"] intValue];
                aiBehavior=[[AiInstantRangeAttack alloc]initWithOwner:projectile totalHit:maxHit maxHitPerEntity:maxHitPerEntity];
                [projectile pushAiBeharvior:aiBehavior];
            }
          
            
            else if ([behaviorType isEqualToString:@"DieWhen"]){
                id when=behaviorData[@"when"];
                aiBehavior=[[AiDieWhen alloc]initWithOwner:projectile when:when];
                [projectile pushAiBeharvior:aiBehavior];
            }
            
            else if ([behaviorType isEqualToString:@"ContinualAttack"]){
                //aiBehavior=[[ alloc]initWithOwner:projectile withPosition:startPosition];
                //[projectile pushAiBeharvior:aiBehavior];
            }
            else if ([behaviorType isEqualToString:@"Buff"]){
                
            }
        }

        damageData.magicalDamage=[magicalDamage finalValue];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"ice_fly.wav"];
        
    }
    else if([name isEqualToString:@"skill_iceBall_through"]){
        projectile=[[IceBall alloc]initWithAllObjectArray:self.owner.allObjectsArray withPostion:ccp(selfPosition.x+zPersonWidth+5,selfPosition.y+zPersonHeight/2-10) byName:name];
        //projectileAi=[[ProjectileAiWithTargetPosition alloc] initWithDestPosition:ccp(zEnemyMarginLeft,selfPosition.y+zPersonHeight/2-10) withOwner:projectile] ;
        
        damageData.magicalDamage=2.0f;
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"ice_fly.wav"];
        
    }
    else if([name isEqualToString:@"skill_snowBall"]){
        float randomX=50+arc4random()%220;
        projectile=[[SnowBall alloc]initWithAllObjectArray:self.owner.allObjectsArray withPostion:ccp(randomX,460) byName:name];
        //projectileAi=[[ProjectileAiWithTargetPosition alloc] initWithDestPosition:ccp(zEnemyMarginLeft,480-zPlayerMarginTop+zPersonHeight/2) withOwner:projectile] ;
        
        //[projectile attackPosition:ccp(0,self.sprite.position.y)];
        
    }else{
        return;
    }
    
    if (projectile) {
        projectile.targetTags=self.owner.targetTags; //buff不应该是 projectile
        projectile.damageData=damageData;
        projectile.owner=(AiObject*)self.owner;
        [self.owner addChild:projectile];
        [projectile start];
    }

}

@end
