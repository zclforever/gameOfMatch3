//
//  BarHelper.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"


@interface BarHelper : CCLayer {
    
}
@property id owner;

-(id)initWithOwner:(id)owner;
-(void)addLifeBar;
-(void)addEnergyBar;
@end
