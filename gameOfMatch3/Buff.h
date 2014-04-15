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
#import "Attribute.h"
@class BuffHelper;



@interface Buff : NSObject {
    
}
-(id)initWithBuffHelper:(BuffHelper*)buffHelper;

@property (strong,nonatomic) NSDictionary* attributeDict;
@property float liveTime;
@property float startTime;


@property BuffHelper* buffHelper;
@property BuffType type;
@property (strong,nonatomic) NSString* name;

-(void)onTimeExpire;
-(void)onEnterFrame;

//-(StateValue)getStateByName:(NSString*)name;
-(void)makeBuff;
-(void)recalcAttributeToOwner;
-(void)start;
-(void)add;
@end
