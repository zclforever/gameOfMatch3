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

@interface AiObjectWithMagic : AiObject <MagicProtocol> {
    
}
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString*)name;

@property (strong,nonatomic) AiObjectMagicDelegate* magicDelegate;
@property (strong,nonatomic) BuffHelper* buffHelper;
@property (strong,nonatomic) NSMutableDictionary* buffDict;

@end
