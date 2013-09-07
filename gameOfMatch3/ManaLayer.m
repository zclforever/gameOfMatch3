//
//  ManaLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-4.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "ManaLayer.h"
@interface ManaLayer()

@property (strong,nonatomic) NSMutableArray* manaLabelArray;
@end

@implementation ManaLayer

-(id)initWithWidth:(float)width withHeight:(float)height{
    self=[super initWithColor:ccc4(0,0,0,0) width:width height:height];
    self.anchorPoint=ccp(0,0);
    //add manaCostIcon&NumOfLabel
    CCSprite* sprite;
    CCLabelTTF* costLabel;
    
    float magicIconSize=height*7/24;  //定义
    float magicIconBottom=height/12;  //定义 这个也是vertical space

    
    
    float magicIconSpace=(width-magicIconSize*2*4)/7;
    float magicCostLabelSize=(width-magicIconSpace*5)/4-magicIconSize-magicIconSpace/2;
    float magicHeadSize=height-magicIconSize-magicIconBottom*3;
    
    self.manaArray=[[NSMutableArray alloc]init];
    self.manaLabelArray=[[NSMutableArray alloc]init];
    self.spriteArray=[[NSMutableArray alloc]init];
    
    for(int i=1;i<5;i++){
        //add manaCostSprite
        sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",i]];
        
        sprite.anchorPoint=ccp(0,0);
        sprite.position=ccp(magicIconSpace+(magicIconSpace+magicIconSize+magicIconSpace/2+magicCostLabelSize)*(i-1),magicIconBottom);
        sprite.scaleX=magicIconSize/sprite.contentSize.width;
        sprite.scaleY=magicIconSize/sprite.contentSize.height;
        
        [self addChild:sprite];
        
        
        //add manaCostLabel
        NSString* cost=@"0";
        costLabel=[CCLabelTTF labelWithString:cost fontName:@"Arial" fontSize:28];
        [costLabel setHorizontalAlignment:kCCTextAlignmentRight];
        costLabel.anchorPoint=ccp(0,0);
        costLabel.scaleX=magicCostLabelSize/costLabel.contentSize.width;
        costLabel.scaleY=magicCostLabelSize/costLabel.contentSize.height;
        if(costLabel.contentSize.width>costLabel.contentSize.height){
            costLabel.scaleY=costLabel.scaleX;
        }else{costLabel.scaleX=costLabel.scaleY;}
        
        costLabel.position=ccp(sprite.position.x+magicIconSize+magicIconSpace/2,magicIconBottom);
        
        [self addChild:costLabel];
        
        [self.manaArray addObject:cost];
        [self.manaLabelArray addObject:costLabel];
        [self.spriteArray addObject:sprite];
    }
    //add skull
    
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",5]];
    
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(self.contentSize.width/2-magicHeadSize/2,magicIconBottom+magicIconSize+magicIconBottom);
    sprite.scaleX=magicHeadSize/sprite.contentSize.width;
    sprite.scaleY=magicHeadSize/sprite.contentSize.height;
    
    [self addChild:sprite z:5];
    NSString* cost=@"0";
    costLabel=[CCLabelTTF labelWithString:cost fontName:@"Arial" fontSize:28];
    [costLabel setHorizontalAlignment:kCCTextAlignmentRight];
    costLabel.anchorPoint=ccp(0,0);
    costLabel.scaleX=magicCostLabelSize/costLabel.contentSize.width;
    costLabel.scaleY=magicCostLabelSize/costLabel.contentSize.height;
    if(costLabel.contentSize.width>costLabel.contentSize.height){
        costLabel.scaleY=costLabel.scaleX;
    }else{costLabel.scaleX=costLabel.scaleY;}
    
    costLabel.position=ccp(self.contentSize.width/2+magicHeadSize/2,magicIconBottom+magicIconSize+magicIconBottom);
    [self addChild:costLabel];
    
    [self.manaArray addObject:@"0"];
    [self.manaLabelArray addObject:costLabel];
    [self.spriteArray addObject:sprite];
    
    [self schedule:@selector(update:)];
    return self;
}
-(void)setManaArrayAtIndex:(int)index withValue:(int)value{
    self.manaArray[index]=[NSString stringWithFormat:@"%d",value];
}
-(void)addManaArrayAtIndex:(int)index withValue:(int)value{
    self.manaArray[index]=[NSString stringWithFormat:@"%d",value+[self.manaArray[index] intValue]];
}
-(void)update:(ccTime)delta{

    for(int i=0;i<self.manaArray.count;i++){

        [self.manaLabelArray[i] setString:self.manaArray[i]];
        
    }
}
@end
