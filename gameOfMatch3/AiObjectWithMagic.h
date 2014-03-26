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
#import "BuffHelper.h"

@interface AiObjectWithMagic : AiObject<MagicProtocol,BuffHelperProtocol> {
    
}
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;

@property AiObjectMagicDelegate* magicDelegate;
@property BuffHelper* buffHelper;
@end
