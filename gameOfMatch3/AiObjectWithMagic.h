//
//  AiObjectWithMagic.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-14.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"
#import "AiObjectMagicDelegate.h"
@interface AiObjectWithMagic : AiObject<MagicDelegate> {
    
}
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;

@property AiObjectMagicDelegate* magicDelegate;
@end
