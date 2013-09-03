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

-(Magic*)initWithName:(NSString*)name{
    self=[super init];
    
    self.name=name;
    int value;
    
    NSRange range;
    range=[name rangeOfString:@"removeValue_"];
    if (range.location!=NSNotFound) {
        value=[[name substringFromIndex:range.length] intValue];
        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",value]];
        self.sprite=sprite;
        self.value=value;
        self.type=@"removeValue";
        if(value==1)
        {
            self.showName=@"帽子失踪";
            self.manaCostArray=[NSMutableArray arrayWithObjects:@3,@1,@0,@3, nil];
        }
        if(value==2)
        {
            self.showName=@"绿之消亡";
            self.manaCostArray=[NSMutableArray arrayWithObjects:@1,@3,@4,@3, nil];
        }
        if(value==3)
        {
            self.showName=@"紫气东去";
            self.manaCostArray=[NSMutableArray arrayWithObjects:@4,@1,@2,@3, nil];
        }
        if(value==4)
        {
            self.showName=@"宝石私逃";
            self.manaCostArray=[NSMutableArray arrayWithObjects:@0,@2,@3,@2, nil];
        }
    }
    
    
    //    range=[name rangeOfString:@"removeValue_"];
    //    if (range.location!=NSNotFound) {
    //        value=[name substringFromIndex:range.length];
    //        CCSprite* sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",value]];
    //        //sprite.position=ccp(zStatePanel_LifeBarWidth/2,self.contentSize.height/2+50);
    //        //        sprite.scaleX=24.0f/sprite.contentSize.width;
    //        //        sprite.scaleY=24.0f/sprite.contentSize.height;
    //        //[self addChild:sprite];
    //        self.sprite=sprite;
    //        self.value=value;
    //        self.type=@"removeValue";
    //    }
    
    
    
    return self;
}

@end
