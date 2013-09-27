//
//  ManaLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-4.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Magic.h"
@interface ManaLayer : CCLayerColor {
    
}
-(id)initWithWidth:(float)width withHeight:(float)height;
@property (strong,nonatomic) NSMutableArray* manaArray;  //stringArray
@property (strong,nonatomic) NSMutableArray* spriteArray;
-(void)setManaArrayAtIndex:(int)index withValue:(int)value;
-(void)addManaArrayAtIndex:(int)index withValue:(int)value;
-(void)calcManaAfterShootWithMagic:(Magic*) magic;
@end
