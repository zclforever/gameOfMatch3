//
//  StatePanelLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StatePanelLayer : CCLayerColor {
    
}

@property (strong,nonatomic) NSString* curHP;
@property (strong,nonatomic) NSString* maxHP;

-(id)initWithPositon:(CGPoint)pos;
-(void)addMagic;
-(bool)checkMagicTouched:(CGPoint)pos;
@end
