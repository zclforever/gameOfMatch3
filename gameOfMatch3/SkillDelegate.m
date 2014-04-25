//
//  SkillDelegate.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "SkillDelegate.h"


@implementation SkillDelegate
-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        self.objectName=name;
        self.tileType=@"skill";
        [self initFromPlist];
        
    }
    return self;
}
-(void)initFromPlist{
    self.attributeDatabase=[Global searchArray:[[[Global sharedManager]dataBase] skills]  whereKey:@"name" isEqualToValue:self.objectName][0];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
    //    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    self.tileSpriteName=[self.attributeDatabase valueForKey:@"tileSpriteName"];
}
-(NSDictionary*) removeByMount:(int)mount{
    NSMutableDictionary* result=[[NSMutableDictionary alloc] init];
    
    [self.parent.magicDelegate magicAttackWithName:self.objectName];
    [self.parent.skillDelegates removeObject:self];
    
    self.readyToRemove=YES;
    //result[@"newDelegate"]=nil;
    [result setValue:nil forKey:@"newDelegate"];
    
    return result;
}

@end
