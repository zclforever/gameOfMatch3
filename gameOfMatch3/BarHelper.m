//
//  BarHelper.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-3-5.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "BarHelper.h"
@interface BarHelper()  
@property (strong,nonatomic) NSMutableArray* bars;
@property (strong,nonatomic) NSMutableArray* borders;
@property (strong,nonatomic) NSMutableArray* labels;
@property (strong,nonatomic) NSMutableArray* attributes;
@property (strong,nonatomic) NSDictionary* lifeBarAttributeDict;

@end
@implementation BarHelper
-(id)initWithOwner:(id)owner{
    self=[super init];
    self.owner=owner;
    
    self.bars=[[NSMutableArray alloc]init];
    self.borders=[[NSMutableArray alloc]init];
    self.labels=[[NSMutableArray alloc]init];
    self.attributes=[[NSMutableArray alloc]init];
    
    

    
    [self schedule:@selector(update)];
    return self;
}
-(void)addLifeBar{
    NSDictionary* dict=@{
                         @"type":@"life",
                         @"width": @10,
                         @"height":@8,
                         @"barSpriteName":@"lifeBar.png",
                         @"borderSpriteName":@"border.png"
                         };
    [self addBarWithDict:dict];
}
-(void)addBarWithDict:(NSDictionary*)dict{
    
    //init LifeBar
    float width=[dict[@"width"] floatValue];
    float height=[dict[@"height"] floatValue];
    
    CCSprite* sprite;
    sprite=[CCSprite spriteWithFile: dict[@"barSpriteName"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.scaleX=width/sprite.contentSize.width;
    sprite.scaleY=height/sprite.contentSize.height;
    sprite.visible=NO;
    
    [self.bars addObject:sprite];
    [self addChild:sprite];
    
    sprite=[CCSprite spriteWithFile:dict[@"borderSpriteName"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.scaleX=width/sprite.contentSize.width;
    sprite.scaleY=height/sprite.contentSize.height;
    sprite.visible=NO;
    
    [self.borders addObject:sprite];
    [self addChild:sprite];
    
    [self.attributes addObject:dict];
    
}
-(void)update{
    
    CCSprite* bar;
    CCSprite* border;
    NSDictionary* dict;
    float cur;
    float max;
    
    AiObject* owner=self.owner;
    CGPoint pos=owner.node.position;
    CGRect rect=[owner getBoundingBox];
    
    for (int i=0; i<self.bars.count; i++) {
        bar=self.bars[i];
        border=self.borders[i];
        dict=self.attributes[i];
        bar.visible=YES;
        border.visible=YES;
        
        float marginHead=5;
        
        float width=[dict[@"width"] floatValue];
        if( [dict[@"type"] isEqualToString:@"life"]){
            cur=owner.curHP;
            max=owner.maxHP;
        }
        if( [dict[@"type"] isEqualToString:@"energy"]){
            cur=owner.curEnergy;
            max=owner.maxEnergy;
        }
        if(cur<0) cur=0;
        
        bar.position=ccp(pos.x-10,pos.y+rect.size.height+marginHead);
        border.position=bar.position;
        
        bar.scaleX=cur/max*width/bar.contentSize.width;
        
        
    }
    

    
}
@end
