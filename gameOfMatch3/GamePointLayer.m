//
//  GamePointLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-11-29.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GamePointLayer.h"
#import "GameMainLayer.h"
#import "GameLevelLayer.h"
#import "Person.h"
#import "Global.h"
@interface GamePointLayer()
@property (weak,nonatomic) Person* person;
@property (weak,nonatomic) NSString* selectedString;
@property (strong,nonatomic) CCLabelTTF* introLabel;
@property (strong,nonatomic) CCLabelTTF* needStarLabel;
@property  (strong,nonatomic)  NSDictionary* skillDict;
@property int needStar;
@property int leftStar;
@end
@implementation GamePointLayer
+(CCScene *) scene
{
    
	CCScene *scene = [CCScene node];
	
	GamePointLayer *layer = [GamePointLayer node];
    
	[scene addChild: layer];
    
	
	return scene;
}

-(NSString*)getLabelStringByKeyOfPersonPoint:(NSString*) key{
    int point=[[self.person.pointDict valueForKey:key] intValue];
    return [self.skillDict valueForKey:key][1][point];
    
}
-(NSString*)getKeyByLabelString:(NSString*)string{
    for (NSString* key in self.skillDict) {
        NSArray* valueArray=[self.skillDict valueForKey:key];
        NSArray* labelStringArray=valueArray[1];
        for (NSString* value in labelStringArray) {
            if ([value isEqualToString:string]) {
                return key;
            }
        }
        
    }
    return nil;
    
}

-(void)setIntroPannel{
    __block Person* person=[Person sharedPlayer];
    
    NSString* key=[self getKeyByLabelString:self.selectedString];
    if(!key)return;
    
    int point=[[person.pointDict valueForKey:key] intValue];
    NSArray* skillArray=[self.skillDict valueForKey:key];
    if (!skillArray) {
        self.introLabel.string=@"无";
        self.needStar=0;
    }else{
        self.needStar=[skillArray[0][point] intValue];
        self.introLabel.string=skillArray[2][point];
    }
    
    
    self.needStarLabel.string=[NSString stringWithFormat:@"★ x %d",self.needStar];
    if (self.needStar==0) self.needStarLabel.string=[NSString stringWithFormat:@"★ x -"];
    
}

-(void)buy{ //buy.
    NSString* skillKey=[self getKeyByLabelString:self.selectedString];
    if(!skillKey)return;
    
    NSArray* skillArray=[self.skillDict valueForKey:skillKey];
    if(!skillArray) return;
    
    if (self.needStar<1)return;
    
    Person* person=self.person;
    
    int point=[[person.pointDict valueForKey:skillKey] intValue];
    
    //-------------主系技能是否加够
    if(skillArray.count>3){
        NSArray* needArray= skillArray[3];
        for (int i=0; i<3; i++) {
            int point=[[person.pointDict valueForKey:[NSString stringWithFormat:@"skill%d",i+1]] intValue];
            if (point<[needArray[i] intValue]) {
                self.introLabel.string=@"主系点数不够";
                return;
            }
        }
    }
    
    if(self.leftStar>=self.needStar){
        [person.pointDict setValue:[NSNumber numberWithInt:point+1] forKey:skillKey];
        if ([skillArray[1] count]>point) {
            [[Global sharedManager] setLastSelectedString:skillArray[1][point+1]];
        }
        [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
    }
    
    
}
-(CCMenu*)makeMenuWithStringArray:(NSArray*)stringArray{
    return [self makeMenuWithStringArray:stringArray withFontSize:28];
    
}
-(CCMenu*)makeMenuWithStringArray:(NSArray*)stringArray  withFontSize:(int)fontSize{
    if (!fontSize) {
        fontSize=28;
    }
    CCMenu* menu;
    NSMutableArray* menuItemsArray=[[NSMutableArray alloc]init];
    
    
    
    for (NSString* labelString in stringArray) {
        CCLabelTTF* label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@",labelString] fontName:@"Arial" fontSize:fontSize];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            self.selectedString=labelString;
            [self setIntroPannel];
        }];
        [menuItemsArray addObject:menuLabel];
        
    }
    menu=[CCMenu menuWithArray:menuItemsArray];
    return menu;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.person=[Person sharedPlayer];
        
        self.skillDict=[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@2,@4,@0,nil],
                         [NSArray arrayWithObjects:@"寒冰",@"寒冰1",@"寒冰2",@"寒冰3",nil],
                         [NSArray arrayWithObjects: @"冰系精通 不加的话很多技能用不了的哟!",@"2级可解锁魔法A",@"我爱3级！",@"满级",nil],
                         nil],@"skill1",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@2,@4,@0,nil],
                         [NSArray arrayWithObjects:@"火神",@"火神1",@"火神2",@"火神3",nil],
                         [NSArray arrayWithObjects:@"火系精通 不加的话很多技能用不了的哟!",@"2级可解锁魔法A",@"我爱3级！",@"满级",nil],
                         nil],@"skill2",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@2,@4,@0,nil],
                         [NSArray arrayWithObjects:@"南瓜",@"南瓜1",@"南瓜2",@"南瓜3",nil],
                         [NSArray arrayWithObjects: @"南瓜精通 不加的话很多技能用不了的哟!",@"2级可解锁魔法A",@"我爱3级！",@"满级",nil],
                         nil],@"skill3",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@0,nil],
                         [NSArray arrayWithObjects:@"火球",@"火球√",nil],
                         [NSArray arrayWithObjects: @"需要火神1.高伤害！",@"高伤害！满级",nil],
                         [NSArray arrayWithObjects:@0,@1,@0,@0,nil],
                         nil],@"fireBall",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@0,nil],
                         [NSArray arrayWithObjects:@"冰球",@"冰球√",nil],
                         [NSArray arrayWithObjects: @"需要寒冰1.减速敌人！并造成伤害(少是少了点)。",@"减速敌人！并造成伤害(少是少了点)。满级",nil],
                         [NSArray arrayWithObjects:@1,@0,@0,@0,nil],
                         nil],@"iceBall",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@0,nil],
                         [NSArray arrayWithObjects:@"雪崩",@"雪崩√",nil],
                         [NSArray arrayWithObjects: @"需要寒冰1.范围减速敌人！并造成伤害(少是少了点)。",@"范围减速敌人！并造成伤害(少是少了点)。满级",nil],
                         [NSArray arrayWithObjects:@1,@0,@0,@0,nil],
                         nil],@"snowBall",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@1,@0,nil],
                         [NSArray arrayWithObjects:@"南瓜吸吸",@"南瓜吸吸√",nil],
                         [NSArray arrayWithObjects: @"需要南瓜1.吸血！并造成伤害。",@"吸血！并造成伤害。吸血！并造成伤害。满级",nil],
                         [NSArray arrayWithObjects:@0,@0,@1,@0,nil],
                         nil],@"bloodAbsorb",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@10,@0,nil],
                         [NSArray arrayWithObjects:@"流星火",@"流星火√",nil],
                         [NSArray arrayWithObjects: @"需要火神3.施放方式:火火火!爆他大爷。巨量伤害！",@"施放方式:火火火!爆他大爷。满级",nil],
                         [NSArray arrayWithObjects:@0,@3,@0,@0,nil],
                         nil],@"bigFireBall",
                        
                        [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@10,@0,nil],
                         [NSArray arrayWithObjects:@"光明之锤",@"光明之锤√",nil],
                         [NSArray arrayWithObjects: @"需要火神1,南瓜3.施放方式:火瓜瓜!一锤回到解放前。",@"施放方式:火瓜瓜!一锤回到解放前。满级",nil],
                         [NSArray arrayWithObjects:@0,@1,@3,@0,nil],
                         nil],@"hammer",
                        
                        
                        
                        
                        nil];
        
        
        NSMutableArray* menuItemArray=[[NSMutableArray alloc]init];
        CCLabelTTF* label;
        CCMenuItemLabel* menuLabel;
        label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            [[CCDirector sharedDirector]replaceScene:[GameLevelLayer scene]];
        }];
        
        [menuItemArray addObject:menuLabel];
        
        
        
        //--------------reset-------------
        label = [CCLabelTTF labelWithString:@"重置" fontName:@"Arial" fontSize:28];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
            for (NSString* key in [self.person.pointDict allKeys]) {
                [self.person.pointDict setValue:@0 forKey:[NSString stringWithFormat:@"%@",key]];
                
            }
            
            [[CCDirector sharedDirector]replaceScene:[GamePointLayer scene]];
        }];
        
        [menuItemArray addObject:menuLabel];
        
        
        
        CCMenu* backMenu=[CCMenu menuWithArray:menuItemArray];
        //CCMenu* backMenu=[CCMenu menuWithItems:menuItemArray[0],menuItemArray[1],nil];
        backMenu.anchorPoint=ccp(0,0);
        backMenu.position = ccp(160,450);
        [backMenu alignItemsHorizontallyWithPadding:200.0f];
        [self addChild:backMenu z:4];
        
        
        //-----------------skills--------------------------//
        __block Person* person=[Person sharedPlayer];
        
        int point1=[[person.pointDict valueForKey:@"skill1"] intValue];
        int point2=[[person.pointDict valueForKey:@"skill2"] intValue];
        int point3=[[person.pointDict valueForKey:@"skill3"] intValue];
        int totalStar=0;
        totalStar=20; //test;
        for (int i=0; i<100; i++) {
            totalStar+=[person.starsOfLevelArray[i] intValue];
        }
        
        //-------------left Point------------------
        int leftPoint=totalStar;
        
        for (NSString* key in person.pointDict) {
            int personSkillPoint=[[person.pointDict valueForKey:key] intValue];
            if (personSkillPoint>0) {
                NSArray* valueArray=[self.skillDict valueForKey:key];
                for (int i=0; i<personSkillPoint; i++) {
                    int costOfPoint=[valueArray[0][i] intValue];
                    leftPoint-=costOfPoint;
                }
                
                
            }
            
            
        }
        self.leftStar=leftPoint;
        
        //----------------------三系大标签
        float labelTop=260.0f;
        float labelLeft=60.0f;
        float labelSpace=60.0f;
        NSString* s1= [self.skillDict valueForKey:@"skill1"][1][point1];
        NSString* s2= [self.skillDict valueForKey:@"skill2"][1][point2];
        NSString* s3= [self.skillDict valueForKey:@"skill3"][1][point3];
        
        CCMenu* menu=[self makeMenuWithStringArray:[NSArray arrayWithObjects:s1,s2,s3, nil]];
        menu.position=ccp(labelLeft,labelTop);
        [menu alignItemsVerticallyWithPadding:labelSpace];
        [self addChild:menu];
        
        //-----------------------三系小标签
        float smallSkillSpace=30.0f;
        float smallSkillTop=355.0f;
        float marginLabelLeft=130.0f;
        float verticalSpace=95.0f;
        float fontSize=18;
        
        NSMutableArray* smallSkillLabelArray=[[NSMutableArray alloc]init];
        NSArray* smallSkillArray=[NSArray arrayWithObjects:
                                  [NSArray arrayWithObjects:@"iceBall",@"snowBall", nil],
                                  [NSArray arrayWithObjects:@"fireBall",@"bigFireBall", nil],
                                  [NSArray arrayWithObjects:@"bloodAbsorb",@"hammer", nil],
                                  nil];
        
        for (int i=0;i<smallSkillArray.count;i++) {
            
            NSArray* tmpArray=smallSkillArray[i];
            [smallSkillLabelArray removeAllObjects];
            for (NSString* name in tmpArray) {
                NSString* labelString=[self getLabelStringByKeyOfPersonPoint:name];
                if(labelString)[smallSkillLabelArray addObject:labelString];
            }
            
            menu=[self makeMenuWithStringArray:smallSkillLabelArray withFontSize:fontSize];
            menu.anchorPoint=ccp(0,0);
            menu.position=ccp(labelLeft+marginLabelLeft,smallSkillTop-verticalSpace*i);
            [menu alignItemsHorizontallyWithPadding:smallSkillSpace];
            [self addChild:menu];
            
        }
        
        
        //--------------------Star Left-----------------
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"★ = %d",leftPoint] fontName:@"Arial" fontSize:42];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(150,450);
        [self addChild:label];
        
        //-------------------need Star Label--------------------
        label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"★ x %d",0] fontName:@"Arial" fontSize:18];
        label.opacity=250;
        label.color = ccc3(255,255,230);
        label.position=ccp(260,90);
        [self addChild:label];
        self.needStarLabel=label;
        
        
        //-------------------buy-----------------
        CCMenuItemLabel* buy=[CCMenuItemLabel itemWithLabel:[CCLabelTTF labelWithString:@"购买" fontName:@"Arial" fontSize:28] block:^(id sender) {
            [self buy];
        }];
        menu=[CCMenu menuWithItems:buy, nil];
        menu.position=ccp(260,60);
        [self addChild:menu];
        
        //-----------------introLabel------------
        
        
        label = [CCLabelTTF labelWithString:@"选择技能并购买吧哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈" fontName:@"Arial" fontSize:18 dimensions:CGSizeMake(200,100) hAlignment:kCCTextAlignmentLeft vAlignment:kCCVerticalTextAlignmentTop lineBreakMode:kCCLineBreakModeWordWrap];
        label.opacity=250;
        label.anchorPoint=ccp(0,0);
        label.color = ccc3(255,255,230);
        label.position=ccp(10,10);
        [self addChild:label];
        self.introLabel=label;
        
    }
    self.selectedString=[[Global sharedManager] lastSelectedString];
    
    if (self.selectedString) {
        [self setIntroPannel];
    }
    
    return self;
}
@end
