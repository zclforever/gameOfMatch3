//
//  BuffHelper.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-26.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AiObject.h"




@protocol BuffHelperProtocol <NSObject>

@property NSMutableDictionary* buffDict;

@end

@interface BuffHelper : CCLayer {
    
}
@property id<BuffHelperProtocol> owner;

-(id)initWithOwner:(id<BuffHelperProtocol>)owner;
@end
