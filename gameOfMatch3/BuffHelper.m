//
//  BuffHelper.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

//只负责在增减 BUFF 队列 至于BUFF 做什么 不管

#import "BuffHelper.h"



@implementation BuffHelper  

-(id)initWithOwner:(id)owner{
    self=[super init];
    self.owner=owner;
    
    //[self schedule:@selector(update)];
    return self;
}
-(void)onEnterFrame{
    //AiObjectWithMagic* owner=self.owner;
}

-(void)addBuffWith:(Buff*)buff{
    //是否存在BUFF如果有则根据类型作叠加重置等 如果没有则添加
    if ([self hasBuff:buff.name]) {
        if (buff.type==reset) { //重置
            
        }else if(buff.type==stackable){  //好几层BUFF
            
        }else if(buff.type==prolong){  //延长
            
        }
        
        
    }else{
        self.buffDict[buff.name]=@{@"buff": buff}; //todo 这里还没想好 也许不需要用dict
        [self.buffArray addObject:buff];
        buff.buffHelper=self;
        [buff start];
        [self addChild:buff];
    }

    
    //
}
-(void)removeBuffWith:(Buff*)buff{
    
}

-(bool)hasBuff:(NSString*)name{
    
    return NO;
}

-(void)recalcAttribute{
    for (Buff* buff in self.buffArray) {
        [buff recalcAttributeToOwner];
    }
}


@end
