//
//  StatePanelLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "StatePanelLayer.h"
#import "const.h"
#import "Magic.h"

@interface StatePanelLayer()
@property (strong,nonatomic) CCSprite* lifeBar;
@property (strong,nonatomic) CCLabelTTF* HPLabel;


@property (strong,nonatomic) CCSprite* magic;
@property ccColor3B colorOfMagicEnabled;
@property ccColor3B colorOfMagicDisabled;
@property float opacityOfMagicEnabled;
@end


@implementation StatePanelLayer
-(id)initWithPositon:(CGPoint)pos{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    self=[super initWithColor:ccc4(0,0,0,0) width:zStatePanelWidth height:winSize.height];
    self.anchorPoint=ccp(0,0);
    self.position=pos;
    
    //init LifeBar
    self.lifeBar=[CCSprite spriteWithFile:@"lifeBar.png" ];
       self.lifeBar.anchorPoint=ccp(0,0);
    self.lifeBar.scaleY=zStatePanel_LifeBarHeight/self.lifeBar.contentSize.height;
    self.lifeBar.scaleX=zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    self.lifeBar.position=ccp(zStatePanel_LifeBarMarginLeft,self.position.y+self.contentSize.height-zStatePanel_LifeBarMarginTop-zStatePanel_LifeBarHeight);
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
    
    //init manaLayer
    
    self.manaLayer=[[ManaLayer alloc]initWithWidth:self.contentSize.width withHeight:zStatePanel_ManaLayerHeight];
    self.manaLayer.position=ccp(0,self.contentSize.height-zStatePanel_ManaLayerMarginTop);
    [self addChild:self.manaLayer];
    self.manaArray=self.manaLayer.manaArray;
    
    self.magicArray=[[NSMutableArray alloc]init];
    self.magicLayerArray=[[NSMutableArray alloc]init];
    
    self.colorOfMagicEnabled= ccc3(0,255,150);
    self.colorOfMagicDisabled=ccc3(0,0,0);
    self.opacityOfMagicEnabled=70.0f;
    
    [self schedule:@selector(update:)];
    
    return self;
}
-(bool)checkMagicTouched:(CGPoint)pos{
    if ([self findMagicTouchedIndex:pos]>=0) {
        return YES;
    }
    else {return NO;}
    
}
-(int)findMagicTouchedIndex:(CGPoint)pos{
    for(int i=0;i<self.magicLayerArray.count;i++){
        CCLayerColor* layer=self.magicLayerArray[i];
        if(CGRectContainsPoint(layer.boundingBox, pos)){return i;}
    }
    return -1; //not find
    
}
-(int)findManaTouchedIndex:(CGPoint)pos{
    
    for(int i=0;i<self.manaLayer.spriteArray.count;i++){
        CCSprite* sprite=self.manaLayer.spriteArray[i];
        if(CGRectContainsPoint(sprite.boundingBox,  pos)){return i;}
    }
    return -1; //not find
    
}

-(void)setMagicState:(bool)state atIndex:(int)index{
    [self.magicLayerArray[index] setMagicEnabled:state];
}



-(CCLayer*) addMagicLayerWithMagicName:(NSString*)name{
    int index=self.magicLayerArray.count;
    
    MagicLayer* retLayer=[[MagicLayer alloc]initWithMagicName:name withWidth:self.contentSize.width withHeight:zStatePanel_MagicLayerHeight];
    retLayer.position=ccp(0,self.contentSize.height-zStatePanel_MagicLayerMarginTop-(index+1)*(zStatePanel_MagicLayerHeight+zStatePanel_MagicLayerSpace));
    
    // send to MagicArray
    [self.magicArray addObject:retLayer.magic];
    [self.magicLayerArray addObject:retLayer];
    [self addChild:retLayer];
    return retLayer;
    
}

-(void)update:(ccTime)delta{
    if(self.curHP&&self.maxHP){
        [self.HPLabel setString:[NSString stringWithFormat:@"%@/%@",self.curHP,self.maxHP]];
        
        self.lifeBar.scaleX=[self.curHP floatValue]/[self.maxHP floatValue]*zStatePanel_LifeBarWidth/self.lifeBar.contentSize.width;
    }
    for(int i=0;i<self.magicLayerArray.count;i++){
        //magicEnabled
        MagicLayer* magicLayer=self.magicLayerArray[i];
         CCLayerColor* layer=(CCLayerColor*)[magicLayer getChildByTag:1] ;
        if (magicLayer.magicEnabled) {
            layer.color=self.colorOfMagicEnabled;
            layer.opacity=self.opacityOfMagicEnabled;
        }else{

                layer.color=self.colorOfMagicDisabled;
                layer.opacity=0;

        }
       
        

    }
    
        //    CCNode* node=[CCParticleFire node];
        //    node.contentSize=layer.contentSize;
        //    node.position=ccp(layer.contentSize.width/2,layer.contentSize.height/2);
        //    [layer addChild:node z:0 tag:2];
//        [layer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:3.0f], [CCCallBlockN actionWithBlock:^(CCNode *node) {
//            //[layer removeChildByTag:1 cleanup:YES];
//            
//            
//        }],nil]];
        

}
@end























//-(CCLayer*) addMagicLayerWithMagicNameTODO:(NSString*)name{
//    int index=self.magicLayerArray.count;
//
//    Magic* magic=[[Magic alloc] initWithName:name];
//
//    CCLayerGradient* retLayer=[[CCLayerGradient alloc]initWithColor:ccc4(255,0,0,100) fadingTo:ccc4 ( 255 , 10 , 10 , 10 ) alongVector:ccp(1,-1)];
//    retLayer.contentSize=CGSizeMake(self.contentSize.width, zStatePanel_MagicLayerHeight);
//    retLayer.position=ccp(0,self.contentSize.height-zStatePanel_MagicLayerMarginTop-(index+1)*zStatePanel_MagicLayerHeight);
//
//    //add layer for change color
//    CCLayerColor* layer=[[CCLayerColor alloc]initWithColor:self.colorOfMagicEnabled width:retLayer.contentSize.width height:zStatePanel_MagicLayerHeight ];
//
//
//    [retLayer addChild:layer z:0 tag:1];
//
//    //add manaCostIcon&NumOfLabel
//    CCSprite* sprite;
//    CCLabelTTF* costLabel;
//
//    float magicIconSize=zStatePanel_MagicLayerHeight*7/24;  //定义
//    float magicIconBottom=zStatePanel_MagicLayerHeight/12;  //定义 这个也是vertical space
//    float magicNameSpace=retLayer.contentSize.width/8;  //定义
//
//
//    float magicIconSpace=(retLayer.contentSize.width-magicIconSize*2*4)/7;
//    float magicCostLabelSize=(retLayer.contentSize.width-magicIconSpace*5)/4-magicIconSize-magicIconSpace/2;
//    float magicHeadSize=zStatePanel_MagicLayerHeight-magicIconSize-magicIconBottom*3;
//
//    float magicNameMaxWidth=(retLayer.contentSize.width-magicHeadSize-magicNameSpace*2); // 以下都为自动
//    float magicNameMaxHeight=(zStatePanel_MagicLayerHeight- magicIconSize-magicIconBottom*2)-magicIconSpace;
//
//    for(int i=1;i<5;i++){
//        //add manaCostSprite
//        sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",i]];
//
//        sprite.anchorPoint=ccp(0,0);
//        sprite.position=ccp(magicIconSpace+(magicIconSpace+magicIconSize+magicIconSpace/2+magicCostLabelSize)*(i-1),magicIconBottom);
//        sprite.scaleX=magicIconSize/sprite.contentSize.width;
//        sprite.scaleY=magicIconSize/sprite.contentSize.height;
//
//        [retLayer addChild:sprite];
//
//
//        //add manaCostLabel
//        NSString* cost=[magic.manaCostArray[i-1] stringValue];
//        //cost=@"25";
//        costLabel=[CCLabelTTF labelWithString:cost fontName:@"Arial" fontSize:28];
//        [costLabel setHorizontalAlignment:kCCTextAlignmentRight];
//        costLabel.anchorPoint=ccp(0,0);
//        costLabel.scaleX=magicCostLabelSize/costLabel.contentSize.width;
//        costLabel.scaleY=magicCostLabelSize/costLabel.contentSize.height;
//        if(costLabel.contentSize.width>costLabel.contentSize.height){
//            costLabel.scaleY=costLabel.scaleX;
//        }else{costLabel.scaleX=costLabel.scaleY;}
//
//        costLabel.position=ccp(sprite.position.x+magicIconSize+magicIconSpace/2,magicIconBottom);
//
//        [retLayer addChild:costLabel];
//
//    }
//
//    //addMagicSprite
//
//    magic.sprite.anchorPoint=ccp(0,0);
//    magic.sprite.position=ccp(magicIconSpace,magicIconBottom+magicIconSize+magicIconBottom);
//    magic.sprite.scaleX=magicHeadSize/magic.sprite.contentSize.width;
//    magic.sprite.scaleY=magicHeadSize/magic.sprite.contentSize.height;
//    [retLayer addChild:magic.sprite];
//
//    //addMagicName
//
//
//    CCLabelTTF* nameLabel=[CCLabelTTF labelWithString:magic.showName fontName:@"Arial" fontSize:36];
//    nameLabel.anchorPoint=ccp(0,0);
//
//    if(nameLabel.contentSize.width>magicNameMaxWidth){
//        nameLabel.scaleX=magicNameMaxWidth/nameLabel.contentSize.width;
//        nameLabel.scaleY=nameLabel.scaleX;
//    }
//    if(nameLabel.contentSize.height* nameLabel.scaleY>magicNameMaxHeight){
//        nameLabel.scaleY=magicNameMaxHeight/nameLabel.contentSize.height;
//    }
//
//    nameLabel.position=ccp(magic.sprite.position.x+magicHeadSize+magicNameSpace,magicIconSize+magicIconBottom+((zStatePanel_MagicLayerHeight- magicIconSize-magicIconBottom)-nameLabel.contentSize.height*nameLabel.scaleY)/2 );
//
//    [retLayer addChild:nameLabel];
//
//
//
//    // send to MagicArray
//    [self.magicArray addObject:magic];
//    [self.magicLayerArray addObject:retLayer];
//    [self addChild:retLayer];
//    return retLayer;
//
//}
