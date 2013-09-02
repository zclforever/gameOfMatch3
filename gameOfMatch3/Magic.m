//
//  Magic.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-9-2.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Magic.h"
#import "const.h"
@implementation Magic

-(Magic*)initWithName:(NSString*)name forValue:(int)value{
    self=[super init];
    
    self.name=name;
    
    if([name isEqualToString:@"removeValue_1"]||[name isEqualToString:@"removeValue_2"]||[name isEqualToString:@"removeValue_2"]||[name isEqualToString:@"removeValue_4"]||[name isEqualToString:@"removeValue_5"]){
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",value]];
        //sprite.position=ccp(zStatePanel_LifeBarWidth/2,self.contentSize.height/2+50);
        sprite.scaleX=24.0f/sprite.contentSize.width;
        sprite.scaleY=24.0f/sprite.contentSize.height;
        //[self addChild:sprite];
        self.sprite=sprite;
        self.value=value;
    }
    
    return self;
}

@end
