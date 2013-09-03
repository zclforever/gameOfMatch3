//
//  MagicLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-3.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Magic.h"
@interface MagicLayer : CCLayerGradient {
    
}
@property ccColor4B colorOfMagicEnabled;
@property ccColor4B colorOfMagicDisabled;
@property (strong,nonatomic) Magic* magic;
@property bool magicEnabled;
-(id)initWithMagicName:(NSString *)name withWidth:(float)width withHeight:(float)height;
@end
