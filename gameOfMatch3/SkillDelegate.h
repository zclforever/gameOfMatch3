//
//  SkillDelegate.h
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Global.h"
#import "Tile.h"
#import "Hero.h"

@interface SkillDelegate : CCLayer <tileDelegate> {
    
}
//protocol
@property (strong,nonatomic) NSString* tileSpriteName;
@property (strong,nonatomic) NSString* tileType;
-(NSDictionary*) removeByMount:(int)mount;
@property bool readyToRemove;

//基本属性
@property (weak,nonatomic) Tile* tile;
@property (weak,nonatomic) Hero* parent;
@property (strong,nonatomic) NSMutableDictionary* attributeDatabase;
@property (strong,nonatomic) NSString* objectName;

-(id)initWithName:(NSString*)name;
@end
