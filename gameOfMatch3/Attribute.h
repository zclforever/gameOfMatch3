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
-(void)loadWithKey:(NSString*)key fromDict:(NSDictionary*)dict;
-(void)resetWithValue:(float)value;
-(void)resetWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage;

+(Attribute*)initWithValue:(float)value;
+(Attribute*)initWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage;
+(Attribute*)initWithKey:(NSString*)key fromDict:(NSDictionary*)dict;

@end
