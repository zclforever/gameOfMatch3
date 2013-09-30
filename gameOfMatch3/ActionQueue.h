//
//  ActionQueue.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-30.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionQueue : CCLayer {
    
}
@property (strong,nonatomic) NSMutableArray* actionArray;
@property (strong,nonatomic) NSMutableArray* actionFinishedArray;
@property bool lock;
-(void)nextAction;  //动作完成后要通知这个解锁
-(void)addActionWithBlock:(void(^)())block;


@end
