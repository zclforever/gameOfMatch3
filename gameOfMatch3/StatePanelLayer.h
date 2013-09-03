//
//  StatePanelLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MagicLayer.h"
@interface StatePanelLayer : CCLayerColor {
    
}

@property (strong,nonatomic) NSString* curHP;
@property (strong,nonatomic) NSString* maxHP;

-(id)initWithPositon:(CGPoint)pos;

-(CCLayer*) addMagicLayerWithMagicName:(NSString*)name;
-(int)findMagicTouchedIndex:(CGPoint)pos;
-(bool)checkMagicTouched:(CGPoint)pos;

@property (strong,nonatomic) NSMutableArray* magicArray; //add Magic Class
@property (strong,nonatomic) NSMutableArray* magicLayerArray; //add MagicLayer
-(void)setMagicState:(bool)state atIndex:(int)index;
@end
