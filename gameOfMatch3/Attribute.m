//
//  Attribute.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-4-10.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "Attribute.h"


@implementation Attribute
-(id)init{
    self=[super init];
    return self;
}
-(float)finalValue{
    return (self.value+self.addition)*self.percentage;
}
-(void)resetWithValue:(float)value{
    self.value=value;
    self.addition=0;
    self.percentage=0;
}
-(void)loadWithKey:(NSString*)key fromDict:(NSDictionary*)dict{
    [self resetWithValue:[dict[key] floatValue]];
}

+(Attribute*)initWithValue:(float)value{
    Attribute* attribute=[[Attribute alloc]init];
    [attribute resetWithValue:value];
    return attribute;
}
+(Attribute*)initWithKey:(NSString*)key fromDict:(NSDictionary*)dict{
    return [Attribute initWithValue:[dict[key]floatValue] ];
}
@end