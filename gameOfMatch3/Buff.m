//
//  Buff.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-29.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

//什么是buff 一种持续的状态 记录保持并可以恢复

//buff类 用来得到自身的数值 
//buff类 中了之后的效果(冰之后变色 )（击中后退应该由projectile来做)

//火烧的时候 定期给call interaction  理由是 interaction 在计算伤害时 需要遍历buff，因此 对于观察buff间的作用应该是 举手之劳
//interaction 给出的是计算结果 与 是否有效

//自己管理生死

#import "Buff.h"
#import "BuffHelper.h"



@implementation Buff
-(id)init{
    self=[super init];
    [self makeBuff];

    
    return self;
}
-(void)makeBuff{
    
}
-(void)start{
    self.startTime=[[Global sharedManager]gameTime];
    [self schedule:@selector(update:)];
}

-(void)onTimeExpire{
    [self.buffHelper removeBuffWith:self];
}

-(void)onEnterFrame{
    
}

-(void)update:(ccTime)delta{
    
    if ([[Global sharedManager]gameTime]-self.startTime>self.liveTime) {
        [self onTimeExpire];
        return;
    }
    
    [self onEnterFrame];

    
    
}

-(void)recalcAttributeToOwner{
    
}

//-(StateValue)getStateByName:(NSString*)name{
//    NSDictionary* dict=self.state[name];
//    struct StateValue ret;
//    ret.p=[dict[@"p"] floatValue];
//    ret.n=[dict[@"n"] floatValue];
//    return ret;
//}


-(void)frozon{
    //    if ([obj.objectName isEqualToString:@"snowBall"]) {
    //        if(!self.state.frozen){
    //            self.state.frozen=YES;
    //            [self.sprite stopAllActions];
    //            self.state.frozenStartTime=[[Global sharedManager] gameTime];
    //            [self.sprite runAction:[CCTintBy actionWithDuration:1 red:-120 green:-120 blue:0]];
    //        }
    //        else{  //如果已经冻结;
    //            needHurt=NO;
    //        }
    //        
    //    }
}


@end
