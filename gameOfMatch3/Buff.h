//
//  Buff.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-29.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"
@class BuffHelper;

struct StateValue {
    float n;
    float p;
};
typedef struct StateValue StateValue;


@interface Buff : CCLayer {
    
}
@property float liveTime;
@property float startTime;


@property BuffHelper* buffHelper;
@property BuffType type;
@property (strong,nonatomic) NSString* name;
@property (strong,nonatomic) NSMutableDictionary* state;

-(void)onTimeExpire;
-(void)onEnterFrame;

-(StateValue)getStateByName:(NSString*)name;

-(void)start;
@end
