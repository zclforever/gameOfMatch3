//
//  Item.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"
#import "Tile.h"
@interface ItemDelegate : CCLayer <tileDelegate> {
    
}
//protocol
@property (strong,nonatomic) NSString* tileSpriteName;
@property (strong,nonatomic) NSString* tileType;
-(NSDictionary*) removeByMount:(int)mount;

//基本属性
@property (strong,nonatomic) NSMutableDictionary* attributeDict;
@property (strong,nonatomic) NSString* objectName;

-(id)initWithName:(NSString*)name;

@end
