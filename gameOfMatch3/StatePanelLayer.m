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
@property (strong,nonatomic) CCLabelTTF* curHPLabel;
@property (strong,nonatomic) CCLabelTTF* maxHPLabel;
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
    
    
    //init "/"
    
    int fontSize=10;
    int fontWidth=20;
    
    float lifeBarFixY=self.lifeBar.position.y;//缩放修正过
    //float lifeBarFixY=self.lifeBar.position.y;//缩放修正过
    
    
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"/" fontName:@"Arial" fontSize:fontSize];
    label.color = ccc3(255,255,255);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(self.lifeBar.position.x+zStatePanel_LifeBarWidth/2,lifeBarFixY);
    [self addChild:label];
    
    
    //init curHPLabel
    self.curHPLabel=[CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:fontSize];
    self.curHPLabel.color = ccc3(255,255,255);
    self.curHPLabel.position = ccp(label.position.x-fontWidth, lifeBarFixY);
    self.curHPLabel.anchorPoint=ccp(0,0);
    [self addChild:self.curHPLabel];
    
    //init maxHPLabel
    self.maxHPLabel=[CCLabelTTF labelWithString:@"0" fontName:@"Arial" fontSize:fontSize];
    self.maxHPLabel.color = ccc3(255,255,255);
    self.maxHPLabel.anchorPoint=ccp(0,0);
    self.maxHPLabel.position = ccp(label.position.x+fontWidth/2, lifeBarFixY);
    [self addChild:self.maxHPLabel];
    
    
    //    [self setLabelString:self.curHPLabelOfPlayer withInt:self.player.curHPLabel];
    //    [self setLabelString:self.maxHPLabelOfPlayer withInt:self.player.maxHPLabel];
    
    
    
    [self schedule:@selector(update:)];
    
    return self;
}
-(void)update:(ccTime)delta{
    if(self.curHP&&self.maxHP){
        [self.curHPLabel setString:self.curHP];
        [self.maxHPLabel setString:self.maxHP];
        self.lifeBar.scaleX=[self.curHP floatValue]/[self.maxHP floatValue]*zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    }
}
@end
