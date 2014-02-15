//
//  Item.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ItemDelegate.h"


@implementation ItemDelegate
-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        self.objectName=name;
        [self initFromPlist];

    }
    return self;
}
-(void)initFromPlist{
    self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
    //    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];
}
-(NSDictionary*) removeByMount:(int)mount{
    NSDictionary* result=[[NSMutableDictionary alloc] init];
    [result setValue:nil forKey:@"newDelegate"];
    
    return result;
}
@end
