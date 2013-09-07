//
//  MagicLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-3.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "MagicLayer.h"
#import "Magic.h"
#import "const.h"

@implementation MagicLayer
-(id)initWithMagicName:(NSString *)name withWidth:(float)width withHeight:(float)height{
    self=[super initWithColor:ccc4(255,0,0,100) fadingTo:ccc4 ( 255 , 10 , 10 , 10 ) alongVector:ccp(1,-1)];


        self.magic=[[Magic alloc] initWithName:name];
        Magic* magic=self.magic;

        self.contentSize=CGSizeMake(width, height);

        
        //add layer for change color
        self.colorOfMagicEnabled= ccc4(0,255,150, 70);
        self.colorOfMagicDisabled=ccc4(0,0,0,0);
        CCLayerColor* layer=[[CCLayerColor alloc]initWithColor:self.colorOfMagicEnabled width:width height:height ];
        
        
        [self addChild:layer z:0 tag:1];
        
        //add manaCostIcon&NumOfLabel
        CCSprite* sprite;
        CCLabelTTF* costLabel;
        
        float magicIconSize=height*7/24;  //定义
        float magicIconBottom=height/16;  //定义 这个也是vertical space
        float magicNameSpace=width/24;  //定义
        
        
        float magicIconSpace=(width-magicIconSize*2*4)/7;
        float magicCostLabelSize=(width-magicIconSpace*5)/4-magicIconSize-magicIconSpace/2;
        float magicHeadSize=height-magicIconSize-magicIconBottom*3;
        
        float magicNameMaxWidth=(width-magicHeadSize-magicNameSpace*2); // 以下都为自动
        float magicNameMaxHeight=(height- magicIconSize-magicIconBottom*2)-magicIconSpace;
//        float magicNameMaxWidth=(width-magicHeadSize-magicNameSpace/2); // 以下都为自动
//        float magicNameMaxHeight=(height- magicIconSize-magicIconBottom*2);
    
        for(int i=1;i<5;i++){
            //add manaCostSprite
            sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",i]];
            
            sprite.anchorPoint=ccp(0,0);
            sprite.position=ccp(magicIconSpace+(magicIconSpace+magicIconSize+magicIconSpace/2+magicCostLabelSize)*(i-1),magicIconBottom);
            sprite.scaleX=magicIconSize/sprite.contentSize.width;
            sprite.scaleY=magicIconSize/sprite.contentSize.height;
            
            [self addChild:sprite];
            
            
            //add manaCostLabel
            NSString* cost=[magic.manaCostArray[i-1] stringValue];
            //cost=@"25";
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
            
        }
        
        //addMagicSprite
        
        magic.sprite.anchorPoint=ccp(0,0);
        magic.sprite.position=ccp(magicIconSpace,magicIconBottom+magicIconSize+magicIconBottom);
        magic.sprite.scaleX=magicHeadSize/magic.sprite.contentSize.width;
        magic.sprite.scaleY=magicHeadSize/magic.sprite.contentSize.height;
        [self addChild:magic.sprite];
        
        //addMagicName
        
        
        CCLabelTTF* nameLabel=[CCLabelTTF labelWithString:magic.showName fontName:@"Arial" fontSize:36];
        nameLabel.anchorPoint=ccp(0,0);
        
        if(nameLabel.contentSize.width>magicNameMaxWidth){
            nameLabel.scaleX=magicNameMaxWidth/nameLabel.contentSize.width;
            nameLabel.scaleY=nameLabel.scaleX;
        }
        if(nameLabel.contentSize.height* nameLabel.scaleY>magicNameMaxHeight){
            nameLabel.scaleY=magicNameMaxHeight/nameLabel.contentSize.height;
        }
        
        nameLabel.position=ccp(magic.sprite.position.x+magicHeadSize+magicNameSpace,magicIconSize+magicIconBottom+((height- magicIconSize-magicIconBottom)-nameLabel.contentSize.height*nameLabel.scaleY)/2 );
        
        [self addChild:nameLabel];
        

    self.magicEnabled=YES;
        
    return self;

}
@end
