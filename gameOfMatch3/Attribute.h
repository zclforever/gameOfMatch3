//
//  Attribute.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-4-10.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Attribute : NSObject {
    
}
@property float value;
@property float addition;
@property float percentage;

-(float)finalValue;
-(void)loadWithDict:(NSDictionary*)dict; //[value n p] to attribute

-(void)resetWithValue:(float)value;
-(void)resetWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage;

+(Attribute*)initWithValue:(float)value;
+(Attribute*)initWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage;

+(Attribute*)attributeFromDict:(NSDictionary*)dict;

-(void)addWithAttribute:(Attribute*)attribute;
@end
