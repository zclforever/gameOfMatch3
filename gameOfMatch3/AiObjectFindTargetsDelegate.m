//
//  FindTargetsDelegate.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "AiObjectFindTargetsDelegate.h"


@implementation AiObjectFindTargetsDelegate

-(id)initWithOwner:(id<FindTargetsProtocol>) obj{
    self=[super init];
    self.owner=obj;
    self.findTargetsObserverArray=[[NSMutableArray alloc]init];
    return self;
}
-(void)addObserverWithType:(NSString*)type{
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_handleWhateverChange) name:@"whateverChange" object:nil];
    [self.findTargetsObserverArray addObject:type];
    
}
-(void)onFindTargets:(NSDictionary*) findTargetsResult{
    
    if (findTargetsResult[@"attackRadius"]) {
        [self.owner onInAttackRange];
    }
    else if (findTargetsResult[@"sightRadius"]){
        [self.owner onInSightButNotInAttackRange];
    }
}
-(NSArray*)findTargetsByDistance:(float)Distance withObjectsArray:(NSArray*)objectsArray{
    return [self.owner collisionObjectsByDistance:Distance withObjectsArray:objectsArray];
}

-(NSDictionary *)findTargets{
    NSArray* ret;
    NSMutableDictionary* resultDict=[[NSMutableDictionary alloc]init];
    
    float radius;
    
    for (NSString* observerRadiusType in self.findTargetsObserverArray) {
        radius=[self.owner.attributeDict[observerRadiusType] floatValue];
        ret=[self findTargetsByDistance:radius withObjectsArray:self.owner.allObjectsArray];
        //过滤不喜欢的目标
        ret=[self.owner objectsByTags:self.owner.targetTags from:ret];
        
        
        if(ret.count>0){
            [resultDict setValue:ret forKey:observerRadiusType];
        }
    }
    self.owner.findTargetsResult=resultDict;
    
    if (resultDict.count==0) {
        [self.owner onFindNothing];
    }else{
        [self.owner onFindTargets];
        [self onFindTargets:resultDict];
    }
    
    return resultDict;
}
@end
