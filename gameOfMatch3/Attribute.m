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
    return (self.value+self.addition)*(1+self.percentage);
}
-(void)resetWithValue:(float)value{
    self.value=value;
    self.addition=0;
    self.percentage=0;
}
-(void)resetWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage{
    self.value=value;
    self.addition=addition;
    self.percentage=percentage;
}

-(void)loadWithKey:(NSString*)key fromDict:(NSDictionary*)dict{
    [self resetWithValue:[dict[key][@"value"] floatValue] withAddition:[dict[key][@"n"] floatValue] withPercentage:[dict[key][@"p"] floatValue]];
}

+(Attribute*)initWithValue:(float)value{
    Attribute* attribute=[[Attribute alloc]init];
    [attribute resetWithValue:value];
    return attribute;
}
+(Attribute*)initWithValue:(float)value withAddition:(float)addition withPercentage:(float)percentage{
    Attribute* attribute=[[Attribute alloc]init];
    [attribute resetWithValue:value withAddition:addition withPercentage:percentage];
    return attribute;
}
+(Attribute*)initWithKey:(NSString*)key fromDict:(NSDictionary*)dict{
    return [Attribute initWithValue:[dict[key][@"value"] floatValue] withAddition:[dict[key][@"n"] floatValue] withPercentage:[dict[key][@"p"] floatValue] ];
}
@end