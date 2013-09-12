//
//  StateLayer.h
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-9.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Person.h"
@interface StateLayer : CCLayerColor {
    
}
+(CCScene *) sceneWith:(Person*)person;
@end
