//
//  FindTargetsDelegate.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol FindTargetsProtocol <NSObject>
    @property (strong,nonatomic) NSDictionary* findTargetsResult;
    @property (strong,nonatomic) NSMutableDictionary* attributeDict;
    @property (strong,nonatomic) NSMutableArray* targetTags;

    -(NSMutableArray*)collisionObjectsByDistance:(float)distance;
    -(NSArray*)objectsByTags:(NSArray*)tags from:(NSArray*)objectsArray;

    -(void)onInAttackRange;
    -(void)onFindNothing;
    -(void)onFindTargets;
@optional
    -(void)onInSightButNotInAttackRange;

@end



@interface AiObjectFindTargetsDelegate : NSObject {
    
}

    @property id<FindTargetsProtocol> owner;

    -(id)initWithOwner:(id<FindTargetsProtocol>) obj;

    -(void)addObserverWithType:(NSString*)type;
    -(NSDictionary *)findTargets;

    @property NSMutableArray* findTargetsObserverArray;
   
    
@end
