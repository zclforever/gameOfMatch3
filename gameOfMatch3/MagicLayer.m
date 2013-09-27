//
//  MagicLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-3.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "MagicLayer.h"
#import "Magic.h"
#import "Global.h"
@interface MagicLayer()
@property (strong,nonatomic) NSMutableArray* costSpriteArray;
@property (strong,nonatomic) CCSprite* checkMarkSprite;
@end
@implementation MagicLayer
-(id)initWithMagicName:(NSString *)name withWidth:(float)width withHeight:(float)height{
    self=[super initWithColor:ccc4(255,0,0,100) fadingTo:ccc4 ( 255 , 10 , 10 , 10 ) alongVector:ccp(1,-1)];
    
    self.isSelected=NO;
    self.magicEnabled=NO;
    
    
    self.magic=[[Magic alloc] initWithName:name];
    Magic* magic=self.magic;
    width=zStatePanel_MagicLayerWidth;
    height=zStatePanel_MagicLayerHeight;
    self.contentSize=CGSizeMake(width, height);
    
    
    //add layer for change color
    self.colorOfMagicEnabled= ccc4(0,255,150, 70);
    self.colorOfMagicDisabled=ccc4(0,0,0,0);
    CCLayerColor* layer=[[CCLayerColor alloc]initWithColor:self.colorOfMagicEnabled width:width height:height ];
    
    
    [self addChild:layer z:0 tag:1];
    
    
    CCSprite* sprite;
    self.costSpriteArray=[[NSMutableArray alloc]init];
    
    float costWidth=(width-zMagicLayer_SpriteSize)/2;
    float spriteSize=zMagicLayer_SpriteSize;
    
    //addMagicSprite
    
    magic.sprite.anchorPoint=ccp(0,0);
    magic.sprite.position=ccp(costWidth,costWidth);
    magic.sprite.scaleX=spriteSize/magic.sprite.contentSize.width;
    magic.sprite.scaleY=spriteSize/magic.sprite.contentSize.height;
    [self addChild:magic.sprite];
    
    //addMagicName
    
    
    CCLabelTTF* nameLabel=[CCLabelTTF labelWithString:magic.showName fontName:@"Arial" fontSize:14];
    //nameLabel.anchorPoint=ccp(0,0);
    nameLabel.position=ccp(magic.sprite.position.x+spriteSize/2,magic.sprite.position.y+spriteSize/2);
    
    [self addChild:nameLabel];
    
    //add manaCostSprite
    //left
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"greenColumn.png"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(0,costWidth);
    sprite.scaleX=costWidth/sprite.contentSize.width;
    sprite.scaleY=spriteSize/sprite.contentSize.height;
    
    [self addChild:sprite];
    [self.costSpriteArray addObject:sprite];
    
    //right
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"yellowColumn.png"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(costWidth+spriteSize,costWidth);
    sprite.scaleX=costWidth/sprite.contentSize.width;
    sprite.scaleY=spriteSize/sprite.contentSize.height;
    
    [self addChild:sprite];
    [self.costSpriteArray addObject:sprite];
    
    //bottom
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"redColumn.png-mine.png"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(costWidth,0);
    sprite.scaleX=spriteSize/sprite.contentSize.width;
    sprite.scaleY=costWidth/sprite.contentSize.height;
    
    [self addChild:sprite];
    [self.costSpriteArray addObject:sprite];
    
    //top
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"lifeBar-mine.png"]];
    sprite.anchorPoint=ccp(0,0);
    sprite.position=ccp(costWidth,costWidth+spriteSize);
    sprite.scaleX=spriteSize/sprite.contentSize.width;
    sprite.scaleY=costWidth/sprite.contentSize.height;
    
    [self addChild:sprite];
    [self.costSpriteArray addObject:sprite];
    
    
    
    //addCheckMarkSprite
    sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"checkMark.png"]];
    sprite.position=ccp(magic.sprite.position.x+spriteSize/2,magic.sprite.position.y+spriteSize/2);
    sprite.scaleX=spriteSize/sprite.contentSize.width;
    sprite.scaleY=spriteSize/sprite.contentSize.height;
    self.checkMarkSprite=sprite;
    [self addChild:sprite];
    
    
    [self schedule:@selector(update:)];
    return self;
    
}

-(void)update:(ccTime)delta{
    if(self.manaArray){
        CCSprite* sprite;
        NSString* stringValue;
        float curHeight;
        bool magicReady=YES;
        int i=0;
        
        sprite=self.costSpriteArray[i];
        stringValue=self.manaArray[i];
        curHeight=[stringValue floatValue]/[self.magic.manaCostArray[i] intValue]*zMagicLayer_SpriteSize;
        curHeight=(curHeight>zMagicLayer_SpriteSize)?zMagicLayer_SpriteSize:curHeight;
        [sprite setScaleY:curHeight/sprite.contentSize.height];
        
        i++;
        sprite=self.costSpriteArray[i];
        stringValue=self.manaArray[i];
        curHeight=[stringValue floatValue]/[self.magic.manaCostArray[i] intValue]*zMagicLayer_SpriteSize;
        curHeight=(curHeight>zMagicLayer_SpriteSize)?zMagicLayer_SpriteSize:curHeight;
        [sprite setScaleY:curHeight/sprite.contentSize.height];
        
        i++;
        sprite=self.costSpriteArray[i];
        stringValue=self.manaArray[i];
        curHeight=[stringValue floatValue]/[self.magic.manaCostArray[i] intValue]*zMagicLayer_SpriteSize;
        curHeight=(curHeight>zMagicLayer_SpriteSize)?zMagicLayer_SpriteSize:curHeight;
        [sprite setScaleX:curHeight/sprite.contentSize.width];
        
        i++;
        sprite=self.costSpriteArray[i];
        stringValue=self.manaArray[i];
        curHeight=[stringValue floatValue]/[self.magic.manaCostArray[i] intValue]*zMagicLayer_SpriteSize;
        curHeight=(curHeight>zMagicLayer_SpriteSize)?zMagicLayer_SpriteSize:curHeight;
        [sprite setScaleX:curHeight/sprite.contentSize.width];
        
        
        for(int i=0;i<4;i++){    //check magic attain
            int value=[self.manaArray[i] intValue];
            int maxValue=[self.magic.manaCostArray[i] intValue];
            if(value<maxValue) {
                magicReady=NO;
                break;
            }
        }
        self.isManaReady=magicReady;
        
        
    }
    if(self.isSelected){
        [self.checkMarkSprite setVisible:YES];
    }else{
        [self.checkMarkSprite setVisible:NO];
    }

}
@end


/*
 //
 //  MagicLayer.m
 //  gameOfMatch3
 //
 //  Created by 张成龙 on 13-9-3.
 //  Copyright 2013年 Wei Ju. All rights reserved.
 //
 
 #import "MagicLayer.h"
 #import "Magic.h"
 #import "Global.h"
 
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
 */