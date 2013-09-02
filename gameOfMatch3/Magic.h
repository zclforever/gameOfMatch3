//
//  Magic.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-2.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface Magic : NSObject
@property (strong,nonatomic)  CCSprite* sprite;
@property (strong,nonatomic) NSMutableArray* manaCostArray;
@property (strong,nonatomic) NSString* name;
@property  int value;
-(Magic*)initWithName:(NSString*)name forValue:(int)value;
@end
