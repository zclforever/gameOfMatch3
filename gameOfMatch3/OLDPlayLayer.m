//
//  PlayLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "PlayLayer.h"
#import "SimpleAudioEngine.h"
#import "Actions.h"
#import "ActionQueue.h"
#import "Global.h"
#import "SmallEnemy.h"
#import "Hero.h"
@implementation MyPoint
-(id)initWithX:(int)x Y:(int)y{
    self=[super init];
    self.x=x;
    self.y=y;
    return self;
}
@end
@interface PlayLayer()
@property  int whosTurn;
@property bool effectOn;
@property int level;
@property bool isSoundEnabled;
@property (strong,nonatomic) ActionQueue* actionHandler;
@property (strong,nonatomic) CCLabelTTF *testLabel;
@property (strong,nonatomic) CCLabelTTF *stepLabel;
@property (strong,nonatomic) CCLabelTTF *stateLabel;
@property (strong,nonatomic) CCSprite *energyBar;
@property (strong,nonatomic) CCSprite *energyBarBorder;
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (weak,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property (strong,nonatomic) NSMutableArray* magicCastArray;
@property (strong,nonatomic) NSMutableArray* magicSelectedArray;
@property (strong,nonatomic) CCLayerColor* maskLayer;

@property (strong,nonatomic) NSMutableArray* smallEnemyArray;
@property (strong,nonatomic) NSMutableArray* allObjectsArray;

@property int  moneyInBattle;
@property int  scoreInBattle;

@property (weak,nonatomic) Tile *tradeTile1;
@property (weak,nonatomic) Tile *tradeTile2;

@property CGPoint touchBegan;
@property (strong,nonatomic) NSMutableArray* touchesBeganArray;
@property (strong,nonatomic) NSMutableArray* touchesEndArray;

@property (strong,nonatomic) NSMutableDictionary* levelDataDict;
@property (strong,nonatomic) NSMutableArray* troopsOrder;
@property int enemyMountOfThisWave;

@property int swapCount;
@property bool updating;
@property bool lockUpdate;
@property bool lockTouch;
@property int timeCount;
@property int updateCount;
@property bool isStarting;
@property bool moveSuccessReady;

@property bool isGameOver;

@property bool usingMagic;
@property float lastSelectTimeOfMagic;
@property float lastTipTime;
@property float gameTime;

@property int firedTag;
@property int shakeCount;
@property int firedShakeCount;
@property bool shakeStopFire;

-(void)afterTurn: (id) node;
@end

@implementation PlayLayer
@synthesize selectedTile=_selectedTile;

-(id)initWithLevel:(int)level{
	self = [super init];
    self.level=level;
	return self;
}
-(void)onExit{
    [super onExit];
    [self removeAllChildrenWithCleanup:YES];
    
    
    [[[Global sharedManager] setTimeOut] removeFromParent];

    self.player=nil;
    self.enemy=nil;
    self.testLabel=nil;
    self.stepLabel=nil;
    self.turnOfPersons=nil;
    self.selectedTile=nil;
    self.touchStreak=nil;
    self.magicCastArray=nil;
    self.magicSelectedArray=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //self.actionHandler=nil;
    
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        [self shakeEvent];
        
    }
    
    
}
-(void)shakeEvent{
    self.shakeCount++;
    //CCLOG(@"shake:%d",self.shakeCount);
}

-(void)addTipWithString:(NSString*)tipString{  //tipstring.tip.
    
    
    
    CGSize size=[CCDirector sharedDirector].winSize;
    //@"AYummyApology"
    
    CCLabelTTF * ready = [CCLabelTTF labelWithString:tipString fontName:@"Arial" fontSize:22 dimensions:CGSizeMake(280,320) hAlignment:kCCTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
    
    
    //CCLabelTTF * ready = [CCLabelTTF labelWithString:tipString fontName:@"Arial" fontSize:22];
    ready.color = ccc3(255,255,255);
    //label.anchorPoint=ccp(0,0);
    ready.position = ccp(size.width/2,size.height/2-30);
    ready.opacity=0;
    
    
    [self addChild:ready z:101];
    
    
    [ready runAction:[CCSequence actions:
                      [CCFadeIn actionWithDuration:.5f],
                      [CCDelayTime actionWithDuration:3.0f],
                      [CCFadeOut actionWithDuration:1.0f],
                      [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }],
                      nil]];
    
}



-(void)addReadyGo{
    CGSize size=[CCDirector sharedDirector].winSize;
    CCLabelTTF * ready = [CCLabelTTF labelWithString:@"Ready" fontName:@"AYummyApology" fontSize:72];
    ready.color = ccc3(255,255,255);
    //label.anchorPoint=ccp(0,0);
    ready.position = ccp(size.width/2,size.height/2);
    [self addChild:ready z:4];
    
    CCLabelTTF * go = [CCLabelTTF labelWithString:@"Go" fontName:@"AYummyApology" fontSize:72];
    go.color = ccc3(255,255,255);
    //label.anchorPoint=ccp(0,0);
    go.position = ccp(size.width/2,size.height/2);
    [self addChild:go z:4];
    
    
    ready.scale=0;
    go.scale=0;
    
    [ready runAction:[CCSequence actions:
                      [CCDelayTime actionWithDuration:0.0f],
                      [CCScaleTo actionWithDuration:.5f scale:.5f],
                      [CCScaleTo actionWithDuration:3.0f scale:1.5f],
                      [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }],
                      nil]];
    [go runAction:[CCSequence actions:
                   [CCDelayTime actionWithDuration:3.5f],
                   [CCScaleTo actionWithDuration:0.0f scale:1.5f],
                   [CCScaleTo actionWithDuration:0.3f scale:4.0f],
                   [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [node removeFromParentAndCleanup:YES];
    }],
                   nil]];
}

-(void)handleTimeOut{  //.handletimeout.handle.
    
    float timeInterval=0.04f;
   
    int count;

    
    //---------------small Enemy---------------------   small.smallEnemy.
    //--------------判断存活
    count=0;
    while (count<self.smallEnemyArray.count) {   
        SmallEnemy* smallEnemy=self.smallEnemyArray[count];
        if (!smallEnemy.alive) {
            //[smallEnemy dieAction];
            [self.smallEnemyArray removeObject:smallEnemy];
            
        }else{
            count++;
        }
    }

  
    
            //------------生成smallEnemy
    
    NSMutableDictionary* troops;
    if (self.troopsOrder.count>0) {
        troops=self.troopsOrder[0];
    }
    if(!self.enemyMountOfThisWave&&self.troopsOrder.count>0) {
        
        self.enemyMountOfThisWave=[[troops valueForKey:@"mount"] intValue];
        
    }    
    float smallEnemyAppearCD=[[troops valueForKey:@"interval"] floatValue];
    count=smallEnemyAppearCD/timeInterval;
    
    NSString* name=[troops valueForKey:@"name"];
    
    if (self.enemyMountOfThisWave>0&&self.timeCount%count==0) {
     SmallEnemy* smallEnemy=[[SmallEnemy alloc]initWithAllObjectArray:self.allObjectsArray withName:name];
        
        
        [self addChild:smallEnemy z:-10];
        [self.smallEnemyArray addObject:smallEnemy];

        

        [smallEnemy appearAtX:zEnemyMarginLeft Y:480-zPlayerMarginTop];

        [smallEnemy attackTargets:self.heroArray];
        
        //smallEnemy.maxHP=self.enemy.smallEnemyHp;
        //smallEnemy.curHP=smallEnemy.maxHP;
        
        self.enemyMountOfThisWave--;
        if(self.troopsOrder.count>0&&self.enemyMountOfThisWave==0) [self.troopsOrder removeObjectAtIndex:0];
        
        //动画移动测试 test
        [smallEnemy moveAnimation];
        
        smallEnemy.sprite.scaleX=-smallEnemy.sprite.scaleX;
        //[smallEnemy attackAnimation];
    }
    
            //----------------判断攻击
    float smallEnemyAttackCD=1.0f;
    count=smallEnemyAttackCD/timeInterval;
    
    
    self.timeCount++;
    [self setTimeOut:timeInterval];
}

-(void)setTimeOut:(float)timeOut{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:@selector(handleTimeOut)],
      
      nil]];
}
-(void)setTimeOut:(float)timeOut withSelect:(SEL)func{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:func],
      
      nil]];
}
-(void)setTimeOut:(float)timeOut withBlock:(void(^)())block{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallBlock actionWithBlock:block],
      
      nil]];
}

-(void)update:(ccTime)delta{   //.update.
    
    //float updateInterval=0.01;
    float tipCD=2.0f;  //notips....
    
    self.gameTime+=delta;
    [[Global sharedManager] setGameTime:self.gameTime];
    //self.gameTime+=updateInterval;
    
    
    
    if (self.lockUpdate) {
        //[self setTimeOut:updateInterval withSelect:@selector(update:)]; //ccctodo
        return;
    }
    
    
    [self updateStatePanel];
    
    if(self.updating)return;
    if (self.updating||!(self.swapCount<=0)) {
        //[self setTimeOut:updateInterval withSelect:@selector(update:)];
        return;
    }
    if (!box.readyToRemoveTiles) {
        //[self setTimeOut:updateInterval withSelect:@selector(update:)];
        return;
    }
    [self checkGameOver];
    self.updating=YES;
    self.updateCount++;
    
    __block PlayLayer* obj=self;
    
    
    [box.removeResultArray removeAllObjects];
    [box check];
    NSArray* matchedArray;
    //Person* nextPerson=self.turnOfPersons[(self.whosTurn+1) % 2];
    
    if((self.gameTime-self.lastSelectTimeOfMagic>=zMagicCD&&(self.lastSelectTimeOfMagic!=0))||self.magicSelectedArray.count>=3) //在技能球队列里 发射选中技能球
    {
        int count=self.magicSelectedArray.count;
        while(count>3){
            Tile* tile=self.magicSelectedArray[count-1];
            tile.selected=NO;
            tile.tradeTile=NO;
            [self.magicSelectedArray removeObjectAtIndex:count-1]; //万一在这个时候按到球
            
            count--;
        }
        
        //统计技能球个数
        float comboShootInterval=0.3f;
        
        NSMutableArray* magicCountArray=[[NSMutableArray alloc]initWithObjects:@0,@0,@0,@0, nil];
        for(int i=0;i<count;i++){
            Tile* tile=self.magicSelectedArray[0];
            [self.magicSelectedArray removeObjectAtIndex:0];
            int magicId=tile.value;
            magicCountArray[magicId-101]=[NSNumber numberWithInt:[magicCountArray[magicId-101] intValue]+1];
            [box.readyToRemoveTiles addObject:tile];
            
        }
        
        //NSString* name=[Magic getNameByCountArray:magicCountArray];
        NSString* name=[Magic getNameByCountArray:magicCountArray withMagicNameList:[Magic getNameListByPointDict:self.player.pointDict]];
        int j=0;
        while (name) {
            Magic* magic=[[Magic alloc]initWithName:name];
            [self setTimeOut:comboShootInterval*(j+1) withBlock:^{
                [obj magicShootByName:name];
            }];
            //[obj magicShootByName:name];
            for(int i=0;i<3;i++){
                magicCountArray[i]=[NSNumber numberWithInt:[magicCountArray[i] intValue]-[magic.manaCostArray[i] intValue] ];
            }
            name=[Magic getNameByCountArray:magicCountArray withMagicNameList:[Magic getNameListByPointDict:self.player.pointDict]];
            j++;
        }
//        if(name){
//            Magic* magic=[[Magic alloc]initWithName:name];
//            [obj magicShootByName:name];
//            for(int i=0;i<3;i++){
//                magicCountArray[i]=[NSNumber numberWithInt:[magicCountArray[i] intValue]-[magic.manaCostArray[i] intValue] ];
//            }
//        }
        
        
        for(int i=0;i<3;i++){
            continue;
            
            int point=[[self.player.pointDict valueForKey:[NSString stringWithFormat:@"skill%d",i+1]]intValue];
            
            
            int magicId=101+i;
            int mount=[magicCountArray[i] intValue];
            
            
            Magic* magic=[[Magic alloc]initWithID:magicId];
            
            int shootTimes=0;
            if(mount==0) continue;
            if(mount==1) shootTimes=1;
            if(mount==2) shootTimes=2;
            if(mount==3) shootTimes=3;
            
            if (point>=2){
                if(mount==1) shootTimes=2;
                if(mount==2) shootTimes=3;
                if(mount==3) shootTimes=4;
            }
            
            for(int j=0;j<shootTimes;j++){
                [self setTimeOut:comboShootInterval*(j+1) withBlock:^{
                    [obj magicShootByName:magic.name];
                }];
            }
            
            
        }
        
        self.lastSelectTimeOfMagic=0;
    }
    if(box.readyToRemoveTiles.count>0){
        //NSLog(@"in check is value 5");
        if(self.tradeTile1&&![box.readyToRemoveTiles containsObject:self.tradeTile1]){self.tradeTile1.tradeTile=NO;self.tradeTile1=nil;}
        if(self.tradeTile2&&![box.readyToRemoveTiles containsObject:self.tradeTile2]){self.tradeTile2.tradeTile=NO;self.tradeTile2=nil;}
        
        
        for (NSArray* result in box.removeResultArray) {
            int value;
            for (Tile* tile in result) {
                value=tile.value;
                NSLog(@"@x:%d,y:%d",tile.x,tile.y);
            }
            
            int mul=1;
            int mount=result.count;
            if(mount==3){
                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"ding.wav"];
            }
            if(mount>3) {
                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"ding.wav"];
                mul=pow(2, mount-2);
                //self.player.curStep+=mount-3;
            }
            if(mount>6){
                NSLog(@"combo mount:%d",mount);
            }
            self.scoreInBattle+=mount*10*mul;
            
            //if(mount>=3)self.player.curEnergy+=mount;

            if(mount>=3&&(1<=value&&value<=3)){
                Hero* hero=self.heroArray[value-1];
                hero.curEnergy+=mount;
            }
            
        }
        
        NSArray* tmp=[box.readyToRemoveTiles allObjects];
//        for(int i=0;i<3;i++){
//            
//            matchedArray=[box findMatchedArray:tmp forValue:i+1];
//            if (matchedArray) {
//                int value=matchedArray.count;
//                int curValue=[self.player.manaLayer.manaArray[i] intValue];
//                int maxValue=[self.player.maxManaArray[i] intValue];
//                value+=curValue;
//                value=(value>maxValue)?maxValue:value;
//                [self.player.manaLayer setManaArrayAtIndex:i withValue:value];
//            }
//            
//        }
        matchedArray=[box findMatchedArray:tmp forValue:5];  //5 is PlayerAttack
        if (matchedArray) {
            float delayTime=0.5f;
            int reduceHp=matchedArray.count;
            if(self.enemy.curHP<=reduceHp){
                //self.scale=1.5;
                //self.position=ccp(-100,-100);
                delayTime=2.5f;
                CCSprite* sword=[CCSprite spriteWithFile:@"block_5.png"];
                sword.position=ccp(250,300);
                
                [self addChild:sword];
                //[self endingZoom];
                
                [sword runAction:[CCSequence actions:
                                  [CCDelayTime actionWithDuration:1.0],
                                  [CCSpawn actions:
                                   [CCRotateBy actionWithDuration:1.5 angle:720],
                                   [CCMoveTo actionWithDuration:1.5 position:self.enemy.sprite.position],
                                   
                                   nil],
                                  [CCMoveTo actionWithDuration:.5 position:ccp(350,530)],
                                  nil]];
                [Actions shakeSprite:obj.enemy.sprite delay:2.5];
                
            }
            for (Tile* tile in matchedArray) {
                CCSprite* sword=[CCSprite spriteWithFile:@"block_5.png"];
                sword.position=tile.sprite.position;
                sword.scaleX=tile.sprite.scaleX;
                sword.scaleY=tile.sprite.scaleY;
                sword.anchorPoint=tile.sprite.anchorPoint;
                [self addChild:sword];
                
                
                
                CGPoint pos=self.enemy.sprite.position;

                __block CCSprite* obj=sword;
                [sword  runAction:[CCSequence actions:
                                   [CCMoveTo actionWithDuration:.4 position:pos],
                                   [CCCallBlock actionWithBlock:^{
                                        [obj removeFromParentAndCleanup:YES];
                                    }]
                                   , nil] ];

            }
            

            __block AiObject* hurtObj=[[AiObject alloc]initWithAllObjectArray:nil];
            hurtObj.damage=reduceHp;
            [self.actionHandler addActionWithBlock:^{
                [Actions shakeSprite:obj.enemy.sprite delay:delayTime withFinishedBlock:^{
                    [obj.enemy hurtByObject:hurtObj];
                    //obj.enemy.curHP-=reduceHp;
                     }];
            }];
            
        }
        matchedArray=[box findMatchedArray:tmp forValue:4];
        if (matchedArray) {self.moneyInBattle+=matchedArray.count;}
        matchedArray=[box findMatchedArray:tmp forValue:6];
        //if (matchedArray) {self.expInBattle+=matchedArray.count;}
        matchedArray=[box findMatchedArray:tmp forValue:7];
        if (matchedArray) {self.player.curHP+=matchedArray.count;
            self.player.curHP=self.player.curHP<=self.player.maxHP?self.player.curHP:self.player.maxHP;}
        
        tmp=nil;
        
        [box removeAndRepair];

        //NSLog(@"in check is value 5 finished");
        self.lastTipTime=self.gameTime;
    }
    else
    {
        if(self.tradeTile1){self.tradeTile1.tradeTile=NO;self.tradeTile1=nil;}
        if(self.tradeTile2){self.tradeTile2.tradeTile=NO;self.tradeTile2=nil;}
        
        NSMutableArray* ret=[box scanSwapMatch];
        if (ret.count<=0) {
            [self noMoves];
        }else{
            if(self.gameTime-self.lastTipTime>tipCD){  //有东西但是没拿 且过了x秒 提示
                self.lastTipTime+=6;
                Tile* tile1=ret[0][0];
                //NSLog(@"%f",self.gameTime);
                float actionTime=0.5;
                
                [tile1.sprite runAction:[CCSequence actions:
                                         
                                         [CCScaleBy actionWithDuration:actionTime scale:0.5f],
                                         [CCScaleBy actionWithDuration:actionTime scale:2.0f],
                                         [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    if(node)[tile1 scaleToTileSize];
                }],
                                         nil]];
                Tile* tile2=ret[0][1];
                
                [tile2.sprite runAction:[CCSequence actions:
                                         [CCScaleBy actionWithDuration:actionTime scale:0.5f],
                                         [CCScaleBy actionWithDuration:actionTime scale:2.0f],
                                         [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    if(node)[tile2 scaleToTileSize];
                }],
                                         nil]];
                
            }
        }
        
        ret=nil;
        
    }
    
    
    self.updating=NO;
    
    //[self setTimeOut:updateInterval withSelect:@selector(update:)];
    return;
}

-(void)magicShootByName:(NSString*)name{  //.shootbyname.shoot.
    
    float iceStateCD=15.0;
    float iceEffect=0.8;  //影响90%
    float poisonStateCD=20.0;
    float poisonEffect=1+0.005; //减1%的血
    __block PlayLayer* obj=self;
    
    
    if([name isEqualToString:@"1bigFireBall"]){
        if (self.enemy.curHP<=50) {
            //[self endingZoom];
        }
        [[SimpleAudioEngine sharedEngine]playEffect:@"explosion.wav"];
        
        [self.actionHandler addActionWithBlock:^{
            [Actions bigFireBallToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                [obj setTimeOut:0.2f withBlock:^{
                    [[SimpleAudioEngine sharedEngine]playEffect:@"explosion02.mp3"];
                }];
                //[[SimpleAudioEngine sharedEngine]playEffect:@"explosion02.mp3"];
                obj.enemy.curHP-=50;}];
            
        }];
        return;
    }
    
    [self.player magicAttackWithName:name];
    return;
    
    if([name isEqualToString:@"fireBall"]){
        [self.player magicAttackWithName:name];
    }
    return;
    
    

    bool hasSmallEnemy=NO;
    __block SmallEnemy* smallEnemy;
    //---------------判断是攻击随从还是BOSS-----------------
    for (int i=0; i<self.smallEnemyArray.count; i++) {
        smallEnemy=self.smallEnemyArray[i];
        if (!smallEnemy.readyToDie) {
            hasSmallEnemy=YES;
            break;
        }
    }

    
    
   if([name isEqualToString:@"firedClear"]){
        if(self.firedTag)[Actions fireSpriteEndByTag:self.firedTag];
            [self.player.stateDict setValue:@0.0 forKey:@"fired"];
            self.firedTag=nil;
        }

    
    if([name isEqualToString:@"bigFireBall"]){
        if (self.enemy.curHP<=50) {
            [self endingZoom];
        }
        [self.actionHandler addActionWithBlock:^{
            [Actions bigFireBallToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                obj.enemy.curHP-=50;}];
            
        }];
    }
    
    
    
    if([name isEqualToString:@"hammer"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions hammerToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                obj.enemy.curStep=35;
                
            }];
            
        }];        }
    
    
    if([name isEqualToString:@"fireBall"]){
        
        if (hasSmallEnemy) {
            if(smallEnemy.curHP<=6)smallEnemy.readyToDie=YES;  //为了避免两个连续火球 打到同一个小兵
                
            [self.actionHandler addActionWithBlock:^{
                [Actions fireBallToSpriteB:smallEnemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                    smallEnemy.curHP-=6;}];
                
            }];
        }else{
            if (self.enemy.curHP<=6) {
                [self endingZoom];
            }
            
            [self.actionHandler addActionWithBlock:^{
                [Actions fireBallToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                    obj.enemy.curHP-=6;}];
                
            }];
        }
        

    }
    
    if([name isEqualToString:@"iceBall"]){
        if (self.enemy.curHP<=1) {
            [self endingZoom];
        }
        
        [self.actionHandler addActionWithBlock:^{
            [Actions iceBallToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                obj.enemy.curHP-=1;
                
                float value=[[obj.enemy.stateDict valueForKey:@"slow"] floatValue]*iceEffect;
                [obj.enemy.stateDict setObject:[NSNumber numberWithFloat:value] forKey:@"slow"];
                
                
                __block PlayLayer* obj2=obj;
                [obj setTimeOut:iceStateCD withBlock:^{
                    
                    float value=[[obj2.enemy.stateDict valueForKey:@"slow"] floatValue]/iceEffect;
                    if (value>1)value=1;
                    [obj2.enemy.stateDict setObject:[NSNumber numberWithFloat:value] forKey:@"slow"];
                    
                }];
                
            }];
            
        }];
    }
    
    if([name isEqualToString:@"poison"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions poisonToSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                //obj.enemy.curHP-=5;
                float value=[[obj.enemy.stateDict valueForKey:@"poison"] floatValue];
                value*=poisonEffect;
                [obj.enemy.stateDict setObject:[NSNumber numberWithFloat:value] forKey:@"poison"];
                
                
                __block PlayLayer* obj2=obj;
                [obj setTimeOut:poisonStateCD withBlock:^{
                    
                    float value=[[obj2.enemy.stateDict valueForKey:@"poison"] floatValue]/poisonEffect;
                    if (value<1)value=1;
                    [obj2.enemy.stateDict setObject:[NSNumber numberWithFloat:value] forKey:@"poison"];
                    
                }];
                
            }];
            
        }];
    }
    
    if([name isEqualToString:@"bloodAbsorb"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions bloodAbsorbSpriteB:obj.enemy.sprite fromSpriteA:obj.player.sprite withFinishedBlock:^{
                obj.enemy.curHP-=1;
                obj.player.curHP+=4;
            }];
            
        }];
    }
}
-(void)updateStatePanel{  //.state.updatestate.
    if (self.player.curHP>self.player.maxHP) {
        self.player.curHP=self.player.maxHP;
    }

    if(self.player.curEnergy>self.player.maxEnergy){
        self.player.curEnergy=self.player.maxEnergy;
    }
    if(self.energyBar){self.energyBar.scaleX=zStatePanel_EnegryBarWidth*self.player.curEnergy/self.player.maxEnergy/self.energyBar.contentSize.width;}
    //self.enegyBar.scaleX=1;
    [self.stepLabel setString:[NSString stringWithFormat:@"AP %f/%f",self.enemy.curStep,self.enemy.maxStep]];
    NSString* key=@"poison";
    float value=[[self.enemy.stateDict valueForKey:key] floatValue];
    [self.stateLabel setString:[NSString stringWithFormat:@"%@:%f",key,value]];
    
}

-(void)computerAIgo{
    //NSLog(@"computerAIgo");
    NSArray* ret=[ai thinkAndFindTile];
    self.selectedTile=ret[0];
    Tile* tile=ret[1];
    if(ret){
		[box setLock:YES];
        
		[self changeWithTileA: self.selectedTile TileB: tile];
		self.selectedTile = nil;
        //self.player.curHP-=10;
        
    }
}

-(void) onEnterTransitionDidFinish{
    [self runAction:[[CCFadeOutTRTiles actionWithDuration:1 size:CGSizeMake(16, 16)] reverse]];
    CCLayerColor* layer=[[CCLayerColor alloc]initWithColor:ccc4(0, 0, 0, 200)];
    [self addChild:layer z:100];
    self.maskLayer=layer;
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(shakeEvent)
    //                                                 name:@"MyiPhoneShakeEvent" object:nil];
    
    self.accelerometerEnabled = YES;
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    [self addChild:[[Global sharedManager] setTimeOut]];
    //添加手势  跟cocos2d冲突
    //    UITapGestureRecognizer* tapRecognizer =
    //    [[UITapGestureRecognizer alloc]
    //      initWithTarget:self action:@selector(handleTaped:)];
    //
    //    [[[CCDirector sharedDirector] view]
    //     addGestureRecognizer:tapRecognizer];
    //
    //    UISwipeGestureRecognizer* swipeRecognizer =
    //    [[UISwipeGestureRecognizer alloc]
    //     initWithTarget:self action:@selector(handleSwiped:)];
    //
    //    [[[CCDirector sharedDirector] view]
    //     addGestureRecognizer:swipeRecognizer];
    
    
    self.levelDataDict=[NSMutableDictionary dictionaryWithDictionary:[[[Global sharedManager] levelDataDict] valueForKey:[NSString stringWithFormat:@"%d",self.level]]];
    self.troopsOrder=[NSMutableArray arrayWithArray:[self.levelDataDict valueForKey:@"troopsOrder"]];
    
    self.actionHandler=[[ActionQueue alloc]init];
    [self addChild:self.actionHandler]; //为了runaction update
    
    self.effectOn=NO;
    self.effectOn=YES;
    
    self.isSoundEnabled=NO;
    //init BG
	CCSprite *bg = [CCSprite spriteWithFile: @"map01.jpg"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [bg setScaleX: 400/bg.contentSize.width];
    //    [bg setScaleY: bg.scaleX];
	bg.position = ccp(winSize.width/2+10,winSize.height/2+200);
	[self addChild: bg z:-20];
    
    
    CCSprite *bgBox = [CCSprite spriteWithFile: @"tilesColored.png"];
    
    [bgBox setScaleX: 300/bgBox.contentSize.width];
    [bgBox setScaleY: bgBox.scaleX];
    bgBox.anchorPoint=ccp(0.5,0);
    bgBox.opacity=150;
	bgBox.position = ccp(winSize.width/2,0);
	[self addChild: bgBox z:-22];
    
    
    
    //init Box
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) factor:6];
	//box.layer = self;
	box.lock = YES;
    [self addChild:box z:-21];
    
    ai=[[AI alloc]initWithBox:box];
    self.player=nil;
    self.enemy=nil;
    
    
    
    [self updateStatePanel];
    //self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];
    
    //    self.whosTurn=Turn_Enemy;
    self.lockTouch=YES;
    self.whosTurn=Turn_Player;
    self.lockTouch=YES;
    self.isStarting=NO;
    self.updating=NO;
    self.updateCount=0;
    self.magicCastArray=[[NSMutableArray alloc]init];
    self.magicSelectedArray=[[NSMutableArray alloc]init];
    self.touchesBeganArray=[[NSMutableArray alloc]init];
    self.touchesEndArray=[[NSMutableArray alloc]init];
    self.smallEnemyArray=[[NSMutableArray alloc]init];
    self.allObjectsArray=[[NSMutableArray alloc]init];
    
	self.touchEnabled = YES;
    //[CCDirector sharedDirector] ism
    
	//[self schedule:@selector(changeTurn:) interval:.3];
    self.updating=NO;
    self.swapCount=0;
    self.lockUpdate=NO;
    self.moveSuccessReady=NO;
    [self schedule:@selector(update:) interval:0 repeat:kCCRepeatForever delay:3];
    
    //system=[CCParticleRain node];
    
    
    if (self.effectOn) {
        //[self addChild:[CCParticleGalaxy node]];
        [self addChild:[CCParticleRain node]];
        self.touchStreak=[[CCMotionStreak alloc]initWithFade:.99f minSeg:16 width:96 color:ccc3(255,0,255) textureFilename:@"fire.png"];
        //[self addChild:self.touchStreak];
    }
    
    
    
    
    
    
    //[self setTimeOut:0.0f];
    
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:64];
    label.opacity=75;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(10,150);
    //[self addChild:label z:4];
    
    self.testLabel=label;
    
    label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];     //stepLabel
    
    label.opacity=250;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(250,415);
    //[self addChild:label z:4];
    self.stepLabel=label;
    
    
    label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];     //stateLabel
    
    label.opacity=250;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(200,435);
    //[self addChild:label z:4];
    self.stateLabel=label;
    
    
    //add enegry bar
    self.energyBar=[CCSprite spriteWithFile:@"bar_yellow.png" ];
    self.energyBar.anchorPoint=ccp(0,0);
    self.energyBar.scaleY=(zStatePanel_EnegryBarHeight)/self.energyBar.contentSize.height;
    self.energyBar.scaleX=0/self.energyBar.contentSize.width;
    self.energyBar.position=ccp(zStatePanel_EnegryBarMarginLeft,480-zStatePanel_EnegryBarMarginTop);
    [self addChild:self.energyBar z:10];
    
    self.energyBarBorder=[CCSprite spriteWithFile:@"border_yellow_gray.png"];
    self.energyBarBorder.anchorPoint=ccp(0,0);
    self.energyBarBorder.scaleY=zStatePanel_EnegryBarHeight/self.energyBarBorder.contentSize.height;
    self.energyBarBorder.scaleX=zStatePanel_EnegryBarWidth/self.energyBarBorder.contentSize.width;
    self.energyBarBorder.position=ccp(zStatePanel_EnegryBarMarginLeft,480-zStatePanel_EnegryBarMarginTop);
    [self addChild:self.energyBarBorder z:9];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    [self addFlag2];
    [self addWindmill];
    
    if (!self.player) {
        [[Person sharedPlayer] setStateDict:[[NSMutableDictionary alloc ]initWithObjectsAndKeys:@0.0,@"fired",@0.0,@"poisoned", nil]];//清空状态
        
        self.player=[[Player alloc]initWithAllObjectArray:self.allObjectsArray];
        
        self.heroArray=[[NSMutableArray alloc]init];
        
        Hero* hero;
        
        hero=[[Hero alloc] initWithAllObjectArray:self.allObjectsArray withName:@"hero_mage"];
        [self.heroArray addObject:hero];
         [self addChild:hero z:-1];
        
        hero=[[Hero alloc] initWithAllObjectArray:self.allObjectsArray withName:@"hero_mage"];
        [self.heroArray addObject:hero];
        [self addChild:hero z:-1];
        
        hero=[[Hero alloc] initWithAllObjectArray:self.allObjectsArray withName:@"hero_mage"];
        [self.heroArray addObject:hero];
        [self addChild:hero z:-1];
        
        
        [self addChild:self.player z:-1];
    }
    if (!self.enemy) {
        self.enemy=[[BossEnemy alloc]initWithAllObjectArray:self.allObjectsArray withLevel:self.level];
        [self addChild:self.enemy z:-1];
    }
    
    Player* player=self.player;
    int point1=[[player.pointDict valueForKey:@"skill1"] intValue];
    int point2=[[player.pointDict valueForKey:@"skill2"] intValue];
    int point3=[[player.pointDict valueForKey:@"skill3"] intValue];
    
    
    [self updateStatePanel];
    self.lockTouch=YES;
	[self lock];
    [box check];
    [box removeAndRepair];
    //    while(box.readyToRemoveTiles.count>0){
    //
    //        [box removeAndRepair];
    //        [box check];
    //    }
    
    
    //CGSize winSize=[[CCDirector sharedDirector] winSize];
    

    


    
    int value=[[self.player.moneyBuyDict objectForKey:@"hpPlus"] intValue];
    self.player.maxHP+=value;
    self.player.curHP=self.player.maxHP;
    value=[[self.player.moneyBuyDict objectForKey:@"shakeStopFire"] intValue];
    if (value)self.shakeStopFire=YES;
    
    
    
    
    [self.player addPersonSpriteAtPosition:ccp(zPlayerMarginLeft,winSize.height-zPlayerMarginTop)];
    //box.lockedPlayer=self.player.sprite;
    
    float space=0;
    for (Hero* hero in self.heroArray) {
        
        
        [hero addPersonSpriteAtPosition:ccp(zPlayerMarginLeft+space,winSize.height-zPlayerMarginTop)];
        space+=20.0f;
        
    }


    
    
    
    [self.enemy addPersonSpriteAtPosition:ccp(zEnemyMarginLeft,winSize.height-zPlayerMarginTop)];
    [self.enemy addApBar];
    box.lockedEnemy=self.enemy.sprite;
    self.enemy.curStep=20;  //配合返回

    
    
    self.isSoundEnabled=YES;  //soundEnable
    

    
    if(self.level==1){
        if (point1+point2+point3<=0) {
            [self addTipWithString:@"试试消除剑来干她^_^"];
        }else{
            [self addTipWithString:@"本关推荐技能球:火，冰"];
        }
        
    }
    
    if(self.level==2){
        if (point1+point2+point3<=0) {
            [self addTipWithString:@"打不过？试试加点"];
        }else{
            [self addTipWithString:@"怪很矮，单冰打不到的哟。本关推荐技能球:火，冰冰冰"];
        }
        
    }
    if(self.level==3)[self addTipWithString:@"怪很硬，试试秒BOSS。本关推荐技能球:火火火"];

    
    //add back layer
    __block PlayLayer* obj=self;
    
    
    [self setTimeOut:3.5 withBlock:^{
        [obj unlock];
        obj.lockTouch=NO;
        [obj setTimeOut:0.0f];
        [obj.maskLayer setOpacity:0];
        
    }];
    
    [self setTimeOut:0.0f withSelect:@selector(addBackLayer)];
    
    
    
    
    
}

-(void)addWindmill{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"windmill.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"windmill.png"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"image1771.png"];
    sprite.position=ccp(100,400);
    [batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=1771; i<=1785; i+=2) {
        NSString* name=[NSString stringWithFormat:@"image%d.png",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    [sprite runAction:action ];
}
-(void)addFlag2{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flag2.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flag2.png"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"image2099.png"];
    sprite.position=ccp(150,440);
    [batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=2099; i<=2107; i+=2) {
        NSString* name=[NSString stringWithFormat:@"image%d.png",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    
    [sprite runAction:action ];
}
-(void)addFlag{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flag.plist"];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:@"flag.png"];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"image1845.png"];
    sprite.position=ccp(160,430);
    [batchNode addChild:sprite];
    [self addChild:batchNode];
    
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (int i=1845; i<=1861; i+=2) {
        NSString* name=[NSString stringWithFormat:@"image%d.png",i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];

    [sprite runAction:action ];
}
-(void)addBackLayer{
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:18];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
    }];
    
    CCMenu* backMenu=[CCMenu menuWithItems:menuLabel, nil];
    backMenu.anchorPoint=ccp(0,0);
    backMenu.position = ccp(20,460);
    [self addChild:backMenu z:4];
}


-(bool) changeWithTileArray:(NSArray*)tiles{
    Tile* a=tiles[0];
    Tile* b=tiles[1];
    return [self changeWithTileA:a TileB:b];
}
-(bool) changeWithTileA: (Tile *) a TileB: (Tile *) b{
    
    float moveTime=kMoveTileTime;
    if (self.whosTurn==Turn_Enemy) {
        //moveTime=moveTime*4;
    }
    CCAction *actionA;
    CCAction *actionB;
    NSMutableArray* matched=[box findMatchWithSwap:a B:b];
    
    if(matched){
        Tile* unRemoveTile;
        CCAction* unRemoveAction;
        
        //NSLog(@"in changeWithTile ready to swap a b ");
        self.swapCount=0;
        CCAction* actionEnd=[CCCallBlock actionWithBlock:^{
            self.swapCount--;
            
        }];
        CCAction* actionEnd2=[CCCallBlock actionWithBlock:^{
            self.swapCount--;
            
        }];
        actionA = [CCSequence actions:[CCMoveTo actionWithDuration:moveTime position:[b pixPosition]],actionEnd,
                   nil];
        
        actionB = [CCSequence actions:[CCMoveTo actionWithDuration:moveTime position:[a pixPosition]],actionEnd2,
                   nil];
        NSArray* ret=[box findMatchedArray:matched forValue:a.value];
        if(!ret){unRemoveTile=a;unRemoveAction=actionA;}else{unRemoveTile=b;unRemoveAction=actionB;}
        if (![box.readyToRemoveTiles containsObject:unRemoveTile]) {
            [unRemoveTile.actionSequence addObject:unRemoveAction];
        }
        
        //[unRemoveTile.sprite runAction:unRemoveAction];
        //        [a.actionSequence addObject:actionA];
        //        [b.actionSequence addObject:actionB];
        //[a.sprite runAction:actionA];
        //[b.sprite runAction:actionB];
        //[self lock];
        [box swapWithTile:a B:b];
        //[self unlock];
        //NSLog(@"in changeWithTile finished");
        return YES;
    }else{
        actionA = [CCSequence actions:
                   [CCMoveTo actionWithDuration:moveTime position:[b pixPosition]],
                   [CCMoveTo actionWithDuration:moveTime position:[a pixPosition]],
                   nil
                   ];
        
        actionB = [CCSequence actions:
                   [CCMoveTo actionWithDuration:moveTime position:[a pixPosition]],
                   [CCMoveTo actionWithDuration:moveTime position:[b pixPosition]],
                   nil
                   ];
        [a.actionSequence addObject:actionA];
        [b.actionSequence addObject:actionB];
        //[a.sprite runAction:actionA];
        //[b.sprite runAction:actionB];
        return NO;
    }
    
}
-(void)lock{
    while(self.updating){};
    self.lockUpdate=YES;
}
-(void)unlock{
    while(self.updating){};
    self.lockUpdate=NO;
}
-(void)setSelectedTile:(Tile *)selectedTile{
    Tile* lastTile=_selectedTile;
    if(lastTile==selectedTile)return;
    //[lastTile scaleToTileSize];
    if (lastTile.readyToEnd) {
        [lastTile scaleToNone];
    }
    _selectedTile=selectedTile;
}
-(void)afterTurn: (id) node{
    CCSprite *sprite = (CCSprite *)node;
	if (self.selectedTile && node == self.selectedTile.sprite) {
        if (self.selectedTile.readyToEnd) {
            return;
        }
        
        if([box readyToRemoveTiles].count>0||sprite.numberOfRunningActions>1){
            //[self.selectedTile scaleToTileSize];
            return;
        }
		CCAction* runningAction=[sprite getActionByTag:1];
        if((!runningAction.isDone)&&sprite.numberOfRunningActions>0){return;}
		CCSequence *someAction = [CCSequence actions:
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:0.5f],
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:2.0f],
								  [CCCallFuncN actionWithTarget:self selector:@selector(afterTurn:)],
								  nil];
        someAction.tag=1;
		//self.selectedTile.ccSequnce2=someAction;
		[sprite runAction:someAction];
	}
}
-(void)noMoves{
    self.selectedTile=nil; //touches 会bug..
    self.touchBegan=ccp(-100,-100);
    
    //self.player.curHP-=5;
    [box pushTilesToRemoveForValue:1];
    [box pushTilesToRemoveForValue:2];
    [box pushTilesToRemoveForValue:3];
    [box pushTilesToRemoveForValue:4];
    [box pushTilesToRemoveForValue:5];
    [box pushTilesToRemoveForValue:6];

}

-(void)moveFailed{
    [[SimpleAudioEngine sharedEngine] playEffect:@"deny.wav"];
    return;
    self.player.curHP-=5;

}

-(void)endingZoom{
    self.lockTouch=YES;
    CGPoint pos=self.enemy.sprite.position;
    [self runAction:[CCSpawn actions:
                     [CCScaleTo actionWithDuration:3.0 scale:1.5],
                     [CCMoveTo actionWithDuration:2.0 position:ccp(-100,-120)],
                     nil]];

    for (int i=0; i<18; i++) {
        int randomX=-25+arc4random()%50;
        int randomY=-25+arc4random()%50;
        [Actions shakeSprite:self.enemy.sprite delay:i*0.5];
        [Actions explosionAtPosition:ccp(pos.x+zPersonWidth/2+randomX,pos.y+zPersonHeight/2+randomY) withDelay:i*0.2 withFinishedBlock:^{

            
        }];
        
    }

    



}

-(void)checkGameOver{
    if(self.isGameOver)return;
    if (self.enemy.curHP<=0) {
        self.isGameOver=YES;
        
        if(self.isSoundEnabled){
            [self setTimeOut:1.0f withBlock:^{
                [[SimpleAudioEngine sharedEngine]playEffect:@"girl_no.wav"];
            }];
        }
        
        [self endingZoom];
        [self setTimeOut:3.0 withSelect:@selector(win)];

    }
    else {
        for (Hero* hero in self.heroArray) {
            if(hero.curHP>0) return;
        }
        
        self.isGameOver=YES;
        [self pauseSchedulerAndActions];
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
        
    }
}
-(void)lose{
    
}
-(void)win{
    
        [self pauseSchedulerAndActions];
        int moneyWin=15+self.level*10;
        
        Person* person=[Person sharedPlayer];
        person.money+=self.moneyInBattle;
        //person.experience+=self..expInBattle;
        person.experience+=self.level*25;
        person.money+=moneyWin;
        
        int star=1;
        float needTime=180.0f;
        
        //if(self.player.curHP>=self.player.maxHP/2) star++;   //半血加星
        if(self.gameTime<=needTime) star++;   //小于needTime加星
        
        if(star>[person.starsOfLevelArray[self.enemy.level-1] intValue]){
            person.starsOfLevelArray[self.enemy.level-1]=[NSNumber numberWithInt:star]; //更新得星数
            
        }
        
        
        NSMutableDictionary* gameInfo=[[NSMutableDictionary alloc]init];
        int money=self.moneyInBattle;
        int score=self.scoreInBattle;
        [gameInfo setValue:[NSNumber numberWithInt:star] forKey:@"star"];
        [gameInfo setValue:[NSNumber numberWithInt:money] forKey:@"moneyInBattle"];
        [gameInfo setValue:[NSNumber numberWithInt:moneyWin] forKey:@"moneyWin"];
        [gameInfo setValue:[NSNumber numberWithInt:score] forKey:@"score"];
        
        
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:YES withGameInfo:gameInfo]];
    

}
-(void)battleFinish{
    [self checkGameOver];
    
    
    self.enemy.curStep=0;
    self.lockTouch=NO;

}

//-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch* touch = [touches anyObject];
//	CGPoint location = [touch locationInView: touch.view];
//    CGPoint lastLocation =[touch previousLocationInView:touch.view];
//	location = [[CCDirector sharedDirector] convertToGL: location];
//    if(self.effectOn) self.touchStreak.position=location;
//
//    //[self ccTouchesBegan:touches withEvent:event];
//
//
//}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  	if (self.lockTouch) {
        return;
    }
    //NSSet *allTouches = [event allTouches];
    //NSLog(@"touches Began %d",touches.count);
    
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    self.touchBegan=location;
    MyPoint* point=[[MyPoint alloc]initWithX:location.x Y:location.y];
    if(self.touchesBeganArray.count<10){
        [self.touchesBeganArray addObject:point];
    }
    
}

- (void)ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
    
    //test.
    //[self.player magicAttackByName:@"snowBall"];
    //    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
    //
    //    [self addChild:particle_system];
    
 	if (self.lockTouch) {
        return;
    }
    
    //NSLog(@"touches End %d",touches.count);
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    MyPoint* beganLocation;
    
    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	int x = (location.x -kStartX) / kTileSize;
	int y = (location.y -kStartY) / kTileSize;
    int beganX;
    int beganY;
    BOOL singleTile=NO;
    bool hasMatchedBegan=NO;
    int vogue=3; //手势模糊值，，偏一格也算对 0为最精确
    int minDistance=5; //防抖动 5p内算是没动
    //判断是否 同一格(tap)
    for(MyPoint* touchBegan in self.touchesBeganArray){
        beganLocation =touchBegan;
        beganX=(beganLocation.x -kStartX) / kTileSize;
        beganY=(beganLocation.y -kStartY) / kTileSize;
        int distanceX=abs(beganLocation.x-location.x);
        int distanceY=abs(beganLocation.y-location.y);
        if(distanceX<minDistance&&distanceY<minDistance){x=beganX;y=beganY;}  //防抖动处理
        
        if(x==beganX&&y==beganY){
            singleTile=YES;
            hasMatchedBegan=YES;
            [self.touchesBeganArray removeObject:touchBegan];
            break;
        }
        
    }
    
    if (!singleTile) {
        
        
        for(int i=0;i<=vogue;i++){
            for(MyPoint* touchBegan in self.touchesBeganArray){
                beganLocation = touchBegan;
                int distanceX=abs(beganLocation.x-location.x);
                int distanceY=abs(beganLocation.y-location.y);
                beganX=(beganLocation.x -kStartX) / kTileSize;
                beganY=(beganLocation.y -kStartY) / kTileSize;
                
                
                
                
                int vogueDistance=i*kTileSize;
                if (distanceX<distanceY&&distanceX<=vogueDistance) {
                    x=beganX;
                    y=beganY+(y>beganY?1:-1);
                    
                    hasMatchedBegan=YES;
                    [self.touchesBeganArray removeObject:touchBegan];
                    break;
                }
                if (distanceX>distanceY&&distanceY<=vogueDistance) {
                    x=beganX+(x>beganX?1:-1);
                    y=beganY;
                    hasMatchedBegan=YES;
                    [self.touchesBeganArray removeObject:touchBegan];
                    break;
                    
                }
                
            }
            if(hasMatchedBegan)break;
            
            
        }
        if (!hasMatchedBegan) {
            if(self.touchesEndArray.count>0&&self.touchesEndArray.count==self.touchesBeganArray.count){
                [self ccTouchesEnded:touches withEvent:event];
                [self.touchesBeganArray removeObjectAtIndex:0];
                [self.touchesEndArray removeObjectAtIndex:0];
            }else{
                [self.touchesEndArray addObject:touch];
                
            }
            return;
            
        }
    }
    
    //NSLog(@"touchesEnded XY:%d,%d",x,y);
    
    
    
    if (!singleTile) {
        self.selectedTile=nil;
        [self touchedOnPointX:beganX Y:beganY];
        [self touchedOnPointX:x Y:y];
    }else{
        [self touchedSingleTileOnPointX:beganX Y:beganY];
    }

    
    if(self.touchesEndArray.count>0&&self.touchesBeganArray.count==1){
        [self ccTouchesEnded:touches withEvent:event];
    }
}

-(void)handleTaped:(UITapGestureRecognizer*) recognizer{
    NSLog(@"%d",recognizer.state);
}
-(void)handleSwipe:(UISwipeGestureRecognizer*) recognizer{
    NSLog(@"%d",recognizer.state);
}

-(void)touchedSingleTileOnPointX:(int)x Y:(int)y{
    Tile *tile = [box objectAtX:x Y:y];
   
    self.lastTipTime=self.gameTime;

    if(tile.value==0){
        self.selectedTile=nil; //test??
        return;
    }
    
    
    if(!self.selectedTile&&tile.value>100&&(!tile.selected)){
        if (self.magicSelectedArray.count>=2) {
            self.selectedTile=nil;
            return;
        }
        tile.selected=YES;
        [self.magicSelectedArray addObject:tile];
        
        //skillBall sound
        [[SimpleAudioEngine sharedEngine] playEffect:@"heavyDing.wav"];
        
        self.lastSelectTimeOfMagic=self.gameTime;
        self.selectedTile=nil;
        return;
        
    }else{
        [self touchedOnPointX:x Y:y];
    }

}
-(void)touchedOnPointX:(int)x Y:(int)y{
    
	
	Tile *tile = [box objectAtX:x Y:y];
    //tile=[box objectAtX:3 Y:3];
    //self.selectedTile=[box objectAtX:3 Y:4];
    
    self.lastTipTime=self.gameTime;
	
    //if(!tile.isActionDone)return;
    if(tile.value==0){
        self.selectedTile=nil; //test??
        return;
    }
    
    
    if(!self.selectedTile){   //未按下
        self.selectedTile=tile;
        return;
        
    }
    
  	if (self.selectedTile.x ==x && self.selectedTile.y == y) {  //提上且同一个
        
        
		return;
	}
    else{   //提上且不同一个
        if ([self.selectedTile nearTile:tile]&&self.selectedTile.value!=0) {  //相邻
            //[box setLock:YES];
            
            bool ret=[self changeWithTileA: self.selectedTile TileB: tile];  //这里是否插到update里面去
            //[self.selectedTile scaleToTileSize];
            if(ret)
            {
                NSLog(@"im traded");
                self.moveSuccessReady=YES;
                tile.tradeTile=YES;
                self.selectedTile.tradeTile=YES;
                self.tradeTile1=tile;
                self.tradeTile2=self.selectedTile;
                self.selectedTile = nil;
            }
            else{
                self.selectedTile = nil;
                [self moveFailed];
            }
            return;

        }
        
        self.selectedTile=nil; //不相邻时 清空selected
        
    }
    
}

@end
