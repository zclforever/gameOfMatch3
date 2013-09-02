//
//  StatePanelLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "StatePanelLayer.h"
#import "const.h"

@interface StatePanelLayer()
@property (strong,nonatomic) CCSprite* lifeBar;
@property (strong,nonatomic) CCLabelTTF* HPLabel;
@property (strong,nonatomic) CCLabelTTF* maxHPLabel;
@property (strong,nonatomic) CCSprite* magic;
@end


@implementation StatePanelLayer
-(id)initWithPositon:(CGPoint)pos{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    self=[super initWithColor:ccc4(0,0,0,0) width:zStatePanelWidth height:winSize.height];
    self.anchorPoint=ccp(0,0);
    self.position=pos;
    
    //init LifeBar
    self.lifeBar=[CCSprite spriteWithFile:@"lifeBar.png" ];
    
    self.lifeBar.position=ccp(zStatePanel_LifeBarMarginLeft,self.position.y+self.contentSize.height-zStatePanel_LifeBarMarginTop);
    self.lifeBar.anchorPoint=ccp(0,0);
    self.lifeBar.scaleY=zStatePanel_LifeBarHeight/self.lifeBar.contentSize.height;
    self.lifeBar.scaleX=zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    [self addChild:self.lifeBar];
    
    
    //init LifeBarLabel
    
    int fontSize=10;

   
    //float lifeBarFixY=self.lifeBar.position.y;//缩放修正过
    float lifeBarFixY=self.lifeBar.position.y+zStatePanel_LifeBarHeight/2;
    
    
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:fontSize];
    label.color = ccc3(255,255,255);
    //label.anchorPoint=ccp(0,0);
    label.position = ccp(self.lifeBar.position.x+zStatePanel_LifeBarWidth/2,lifeBarFixY);
    [self addChild:label];
    
    self.HPLabel=label;
    
    

    
    [self schedule:@selector(update:)];
    
    return self;
}
-(bool)checkMagicTouched:(CGPoint)pos{
    return CGRectContainsPoint(self.magic.boundingBox, pos);

    
}
-(void)addMagic{
    //magic
    CCSprite* sprite=[CCSprite spriteWithFile:@"block_3.png"];
    sprite.position=ccp(zStatePanel_LifeBarWidth/2,self.contentSize.height/2+50);
    sprite.scaleX=24.0f/sprite.contentSize.width;
    sprite.scaleY=24.0f/sprite.contentSize.height;
    [self addChild:sprite];
    self.magic=sprite;
}
-(void)update:(ccTime)delta{
    if(self.curHP&&self.maxHP){
        [self.HPLabel setString:[NSString stringWithFormat:@"%@/%@",self.curHP,self.maxHP]];

        self.lifeBar.scaleX=[self.curHP floatValue]/[self.maxHP floatValue]*zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    }
}
@end
