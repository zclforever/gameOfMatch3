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
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (weak,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property (strong,nonatomic) NSMutableArray* magicCastArray;
@property (strong,nonatomic) NSMutableArray* magicSelectedArray;
@property (strong,nonatomic) CCLayerColor* maskLayer;

@property int  moneyInBattle;
@property int  scoreInBattle;

@property CGPoint touchBegan;
@property (strong,nonatomic) NSMutableArray* touchesBeganArray;
@property (strong,nonatomic) NSMutableArray* touchesEndArray;

@property int swapCount;
@property bool updating;
@property bool lockUpdate;
@property bool lockTouch;
@property int timeCount;
@property int updateCount;
@property bool isStarting;
@property bool moveSuccessReady;

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

-(id)initWithPlayer:(Person*)player withEnemy:(Person*)enemy{
	self = [super init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(shakeEvent)
//                                                 name:@"MyiPhoneShakeEvent" object:nil];
    
    self.isAccelerometerEnabled = YES;
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    
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
    
    
    self.actionHandler=[[ActionQueue alloc]init];
    [self addChild:self.actionHandler]; //为了runaction update
    
    self.effectOn=NO;
    self.effectOn=YES;
    
    self.isSoundEnabled=NO;
    //init BG
	CCSprite *bg = [CCSprite spriteWithFile: @"playLayer.jpg"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [bg setScaleX: winSize.width/bg.contentSize.width];
    [bg setScaleY: winSize.height/bg.contentSize.height];
	bg.position = ccp(winSize.width/2,winSize.height/2);
	//[self addChild: bg z:-2];
    
    //init StateLayer
    //float kStartX=[[consts sharedManager] kStartX];
    
    StatePanelLayerInBattle *statePanelLayer=[[StatePanelLayerInBattle alloc]initWithPositon:ccp(0,0)];
    
    [self addChild:statePanelLayer z:-1];
    
    //StatePanelLayer *statePanelLayerEnemy=[[StatePanelLayer alloc]initWithPositon:ccp(kStartX+kBoxWidth*kTileSize,0)];
    StatePanelLayerInBattle *statePanelLayerEnemy=[[StatePanelLayerInBattle alloc]initWithPositon:ccp(0,0)];
    [self addChild:statePanelLayerEnemy z:-1];
    
    self.statePanelLayerPlayer=statePanelLayer;
    self.statePanelLayerEnemy=statePanelLayerEnemy;
    
    //init Box
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) factor:6];
	//box.layer = self;
	box.lock = YES;
    [self addChild:box];
    
    ai=[[AI alloc]initWithBox:box];
    self.player=player;
    self.enemy=enemy;
    
    if (!player) {
        self.player=[Person defaultPlayer];
    }
    
    if(!enemy){
        self.enemy=[Person defaultEnemy];
    }
    
    
    self.level=self.enemy.level;
    
    [self updateStatePanel];
    self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];

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
    
	self.isTouchEnabled = YES;
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
    [self addChild:label z:4];
    self.stepLabel=label;
 
    
    label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];     //stateLabel
    
    label.opacity=250;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(200,435);
    [self addChild:label z:4];
    self.stateLabel=label;
    
    
    CCLayerColor* layer=[[CCLayerColor alloc]initWithColor:ccc4(0, 0, 0, 200)];
    [self addChild:layer z:100];
    self.maskLayer=layer;
    
	return self;
}
-(void)onExit{
    [super onExit];
    [self removeAllChildrenWithCleanup:YES];
    

    
    self.statePanelLayerPlayer=nil;
    self.statePanelLayerEnemy=nil;
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
    //enemy state;
    float value;
    
    value=[[self.enemy.stateDict objectForKey:@"slow"] floatValue];
    float apSpeed=self.enemy.apSpeed*value;
    
    value=[[self.enemy.stateDict objectForKey:@"poison"] floatValue];
    float hpReduceByPoison=self.enemy.curHP*(value-1)*timeInterval;
    
    //player state
    value=[[self.player.stateDict objectForKey:@"fired"] floatValue];
    float hpReduceByFired=value*2*timeInterval;
    

    
    //NSLog(@"%f",hpReduceByFired);
    
    if (self.shakeStopFire&&self.shakeCount-self.firedShakeCount>=5&&self.firedTag&&self.shakeCount!=0) {
        [self magicShootByName:@"firedClear"];
        self.shakeCount=0;
    }

    if (hpReduceByFired>0) {
        self.player.curHP-=hpReduceByFired;

    }
    
    self.enemy.curStep+=apSpeed*timeInterval;
    self.enemy.curHP-=hpReduceByPoison;
    
    
    if (self.enemy.curStep>=self.enemy.maxStep) {  //attack success.
        [Actions shakeSprite:self.statePanelLayerPlayer.personSprite delay:0];
        self.player.curHP-=self.enemy.damage;
        
        self.enemy.curStep=0;
        
        if(self.enemy.attackType==2&&!self.firedTag){
        
            [self.player.stateDict setValue:[NSNumber numberWithInt:self.enemy.level] forKey:@"fired"];
            self.firedShakeCount=self.shakeCount;
            self.firedTag=[Actions fireSpriteStart:self.statePanelLayerPlayer.personSprite  withFinishedBlock:^{}];


        }
        self.enemy.attackType=2;
    }
    //NSLog(@"distance:%f",(zEnemyMarginLeft-zPlayerMarginLeft-20)*(1-self.enemy.curStep/self.enemy.maxStep));
    

    //控制位置
   
    //if ([Actions getActionCount]==0) {
    if (YES) {
        float minDistance=60;
        CGPoint position;
        
//        if(self.enemy.curStep<20&&[Actions getActionCount]==0){
//             NSLog(@"ActionCount:%d",[Actions getActionCount]);
//            //position=ccp(self.statePanelLayerPlayer.personSprite.position.x+minDistance+(zEnemyMarginLeft-zPlayerMarginLeft-minDistance)*(self.enemy.curStep/20),self.statePanelLayerEnemy.personSprite.position.y);
//            
//            position=ccp(zEnemyMarginLeft,self.statePanelLayerEnemy.personSprite.position.y);
//            //self.statePanelLayerEnemy.personSprite.position=position;
//            float duration=(20-self.enemy.curStep)/apSpeed;
//            NSLog(@"duration %f",duration);
//            __block PlayLayer* obj=self;
//            [Actions moveSprite:obj.statePanelLayerEnemy.personSprite toPosition:position withDuration:duration withFinishedBlock:^{}];
//            [self.actionHandler addActionWithBlock:^{
//
//                [Actions moveSprite:obj.statePanelLayerEnemy.personSprite toPosition:position withDuration:duration withFinishedBlock:^{}];
//
//
//            }];
            

        if(self.enemy.curStep<20){
            position=ccp(self.statePanelLayerPlayer.personSprite.position.x+minDistance+(zEnemyMarginLeft-zPlayerMarginLeft-minDistance)*(self.enemy.curStep/20),self.statePanelLayerEnemy.personSprite.position.y);

            self.statePanelLayerEnemy.personSprite.position=position;
        }
        if(self.enemy.curStep>=20){
            position=ccp(self.statePanelLayerPlayer.personSprite.position.x+minDistance+(zEnemyMarginLeft-zPlayerMarginLeft-minDistance)*(1-(self.enemy.curStep-20)/(self.enemy.maxStep-20)),self.statePanelLayerEnemy.personSprite.position.y);
            
            self.statePanelLayerEnemy.personSprite.position=position;
        }
        
    }

    
    
    
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
    //self.gameTime+=updateInterval;
    

    
    if (self.lockUpdate) {
        //[self setTimeOut:updateInterval withSelect:@selector(update:)]; //ccctodo
        return;
    }
    
    
    [self updateStatePanel];
    
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
    
    if((self.gameTime-self.lastSelectTimeOfMagic>=zMagicCD&&(self.lastSelectTimeOfMagic!=0))||self.magicSelectedArray.count>=2)
    {
        int count=self.magicSelectedArray.count;
        while(count>2){
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

        NSString* name=[Magic getNameByCountArray:magicCountArray];

        if(name){
            Magic* magic=[[Magic alloc]initWithName:name];
            [obj magicShootByName:name];
            for(int i=0;i<3;i++){
                magicCountArray[i]=[NSNumber numberWithInt:[magicCountArray[i] intValue]-[magic.manaCostArray[i] intValue] ];
            }
        }
        
        
        for(int i=0;i<3;i++){

            int magicId=101+i;
            int mount=[magicCountArray[i] intValue];
            
            
            Magic* magic=[[Magic alloc]initWithID:magicId];
            
            int shootTimes=0;
            if(mount==0) continue;
            if(mount==1) shootTimes=1;
            if(mount==2) shootTimes=3;
            if(mount==3) shootTimes=6;
            for(int j=0;j<shootTimes;j++){
                [self setTimeOut:comboShootInterval*j withBlock:^{
                    [obj magicShootByName:magic.name];
                }];
            }

            
        }
        
        self.lastSelectTimeOfMagic=0;
    }
    if(box.readyToRemoveTiles.count>0){
        //NSLog(@"in check is value 5");
        
        
        
        for (NSArray* result in box.removeResultArray) {
            int mul=1;
            int mount=result.count;
            if(mount==3){
                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"coinDing.wav"];
            }
            if(mount>3) {
                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"thunderDone.wav"];
                mul=pow(2, mount-2);
                self.player.curStep+=mount-3;
                //额外一步
//                CCLabelTTF* showLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"额外%d步",mount-3] fontName:@"Arial" fontSize:48];
//                showLabel.anchorPoint=ccp(0,0);
//                showLabel.position=ccp(260,160);
//                [self addChild:showLabel];
//                [showLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3.0f],[CCCallBlockN actionWithBlock:^(CCNode *node) {
//                    [node removeFromParentAndCleanup:YES];
//                }], nil]];
            }
            self.scoreInBattle+=mount*100*mul;
        }
        
        NSArray* tmp=[box.readyToRemoveTiles allObjects];
        for(int i=0;i<3;i++){
            
            matchedArray=[box findMatchedArray:tmp forValue:i+1];
            if (matchedArray) {
                int value=matchedArray.count;
                int curValue=[self.statePanelLayerPlayer.manaLayer.manaArray[i] intValue];
                int maxValue=[self.player.maxManaArray[i] intValue];
                value+=curValue;
                value=(value>maxValue)?maxValue:value;
                [self.statePanelLayerPlayer.manaLayer setManaArrayAtIndex:i withValue:value];
            }
            
        }
        matchedArray=[box findMatchedArray:tmp forValue:5];  //5 is PlayerAttack
        if (matchedArray) {
            
            
            [self.actionHandler addActionWithBlock:^{
                [Actions shakeSprite:obj.statePanelLayerEnemy.personSprite delay:0.5f withFinishedBlock:^{
                    obj.enemy.curHP-=matchedArray.count;}];
                
//                [Actions attackSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
//                    obj.enemy.curHP-=matchedArray.count;}];
                
            }];
            
        }
        matchedArray=[box findMatchedArray:tmp forValue:4];
        if (matchedArray) {self.moneyInBattle+=matchedArray.count;}
        matchedArray=[box findMatchedArray:tmp forValue:6];
        //if (matchedArray) {self.expInBattle+=matchedArray.count;}
        matchedArray=[box findMatchedArray:tmp forValue:7];
        if (matchedArray) {self.player.curHP+=matchedArray.count;
            self.player.curHP=self.player.curHP<=self.player.maxHP?self.player.curHP:self.player.maxHP;}
        
        [box removeAndRepair];
//        if(self.moveSuccessReady){
//            [self setTimeOut:0.1 withSelect:@selector(moveSuccess)];
//            self.moveSuccessReady=NO;
//        }
        //NSLog(@"in check is value 5 finished");
        self.lastTipTime=self.gameTime;
    }else{
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
    
    
     
    if([name isEqualToString:@"firedClear"]){
        if(self.firedTag)[Actions fireSpriteEndByTag:self.firedTag];
        [self.player.stateDict setValue:@0.0 forKey:@"fired"];
        self.firedTag=nil;
    }
    
    if([name isEqualToString:@"fired"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions hammerToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curStep=20;
                
            }];
            
        }];     
    }
    
    
    if([name isEqualToString:@"hammer"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions hammerToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curStep=20;
            
                }];
            
        }];        }
    
    
    if([name isEqualToString:@"fireBall"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions fireBallToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=7;}];
            
        }];
    }
    
    if([name isEqualToString:@"iceBall"]){

        [self.actionHandler addActionWithBlock:^{
            [Actions iceBallToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
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
            [Actions poisonToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
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
            [Actions bloodAbsorbSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=2;
                obj.player.curHP+=4;
            }];
            
        }];
    }
}
-(void)updateStatePanel{  //.state.updatestate.
    if (self.player.curHP>self.player.maxHP) {
        self.player.curHP=self.player.maxHP;
    }
    self.statePanelLayerPlayer.curHP=[NSString stringWithFormat:@"%d",(int)self.player.curHP];
    self.statePanelLayerPlayer.maxHP=[NSString stringWithFormat:@"%d",(int)self.player.maxHP];
    self.statePanelLayerEnemy.curHP=[NSString stringWithFormat:@"%d",(int)self.enemy.curHP];
    self.statePanelLayerEnemy.maxHP=[NSString stringWithFormat:@"%d",(int)self.enemy.maxHP];
    
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
    Person* person=self.player;
    int point1=[[person.pointDict valueForKey:@"skill1"] intValue];
    int point2=[[person.pointDict valueForKey:@"skill2"] intValue];
    int point3=[[person.pointDict valueForKey:@"skill3"] intValue];


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
   
    
    CGSize winSize=[[CCDirector sharedDirector] winSize];
    
    //[self.statePanelLayerPlayer addMagicLayerWithMagicName:@"fireBall"];
    
    //self.player=[Person defaultPlayer]; // 测试版清空player数据,state自动重置
    //初始化player数据
    self.statePanelLayerPlayer.person=self.player;
    
    int value=[[self.player.moneyBuyDict objectForKey:@"hpPlus"] intValue];
    self.player.maxHP+=value;
    self.player.curHP=self.player.maxHP;
    value=[[self.player.moneyBuyDict objectForKey:@"shakeStopFire"] intValue];
    if (value)self.shakeStopFire=YES;
    
    self.player.stateDict=[[NSMutableDictionary alloc ]initWithObjectsAndKeys:@0.0,@"fired",@0.0,@"poisoned", nil];
    
    
    [self.statePanelLayerPlayer addPersonSpriteAtPosition:ccp(zPlayerMarginLeft,winSize.height-zPlayerMarginTop)];
    box.lockedPlayer=self.statePanelLayerPlayer.personSprite;
    
    //[self.statePanelLayerPlayer addBorderOfMagic];
    [self.statePanelLayerPlayer addMoneyExpLabel];
    [self.statePanelLayerPlayer addScoreLayer];
    //[self.statePanelLayerPlayer addManaLayer];
    
    
    self.statePanelLayerEnemy.person=self.enemy;
    [self.statePanelLayerEnemy addPersonSpriteAtPosition:ccp(zEnemyMarginLeft,winSize.height-zPlayerMarginTop)];
    [self.statePanelLayerEnemy addApBar];
    box.lockedEnemy=self.statePanelLayerEnemy.personSprite;
    self.enemy.curStep=20;  //配合返回
    self.enemy.attackType=2;
    
    self.isSoundEnabled=YES;  //soundEnable
    
    if(self.level==1){
        if (point1+point2+point3<=0) {
            [self addTipWithString:@"试试消除剑来干她^_^"];
        }else{
            [self addTipWithString:@"刷钱来的吧..."];
        }
    
    }

    if(self.level==2){
        if (point1+point2+point3<=0) {
            [self addTipWithString:@"打不过？试试加点"];
        }else{
            [self addTipWithString:@"圆圆的技能球,要摸哦~~"];
        }
        
    }
    if(self.level==3)[self addTipWithString:@"星星不够？过关保存血量50%以上可得一星！"];

    
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
    
    self.player.curHP-=5;
    [box pushTilesToRemoveForValue:1];
    [box pushTilesToRemoveForValue:2];
    [box pushTilesToRemoveForValue:3];
    [box pushTilesToRemoveForValue:4];
    [box pushTilesToRemoveForValue:5];
    [box pushTilesToRemoveForValue:6];
    for(int i=0;i<4;i++){
        [self.statePanelLayerPlayer.manaLayer setManaArrayAtIndex:i withValue:0];
    }
}

-(void)playerAttack{
    
}
-(void)moveFailed{
    [[SimpleAudioEngine sharedEngine] playEffect:@"deny.wav"];
    return;
    self.player.curHP-=5;
    [self moveSuccess];
}
-(void)moveSuccess{
    
    int finalDam=0;
    int enemy_dam=self.enemy.damage;
    
    self.enemy.curStep++;
    if(self.enemy.curStep>=self.enemy.maxStep){   //turnFinished
        
        self.lockTouch=YES;
        bool magicAttack=YES;
        
        int minTimes=0;
        
        finalDam=self.player.damage;
        if(magicAttack){
            finalDam+=self.player.magicDamage*minTimes;
        }
        
        [Actions shakeSprite:self.statePanelLayerPlayer.personSprite delay:0];

        self.enemy.curHP-=finalDam;
        self.player.curHP-=enemy_dam;
        [self setTimeOut:1.0 withSelect:@selector(battleFinish)];
        return;
    }else{
        [self checkGameOver];
    }
}
-(void)checkGameOver{
    if (self.enemy.curHP<=0) {
        [self pauseSchedulerAndActions];
        int moneyWin=15+self.level*10;
        
        Person* person=[Person sharedPlayer];
        person.money+=self.moneyInBattle;
        //person.experience+=self..expInBattle;
        person.experience+=self.level*25;
        person.money+=moneyWin;

        int star=1;
        float needTime=180.0f;
        
        if(self.player.curHP>=self.player.maxHP/2) star++;   //半血加星
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
    else if (self.player.curHP<=0){
        [self pauseSchedulerAndActions];
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
        
    }
}
-(void)battleFinish{
    [self checkGameOver];
    
    
    self.enemy.curStep=0;
    self.lockTouch=NO;
    for(int i=0;i<4;i++){
        //[self.statePanelLayerPlayer.manaLayer setManaArrayAtIndex:i withValue:0];
    }
}
-(int)getManaWithNumberInPicName:(int)num{
    return [self.statePanelLayerPlayer.manaArray[num-1] intValue];
}
-(void)converManaAtIndex:(int)index{
    int convertRate=5;
    int skull=[self getManaWithNumberInPicName:5];
    if (skull<5) {
        return;
    }
    if(0<=index && index<4){  //按下的是四色
        [self.statePanelLayerPlayer.manaLayer addManaArrayAtIndex:index withValue:1];
        [self.statePanelLayerPlayer.manaLayer addManaArrayAtIndex:4 withValue:-convertRate];
        return;
    }
    if(index==4){  //按下的是骷髅
        //        [self.statePanelLayerPlayer.manaLayer addManaArrayAtIndex:index withValue:1];
        //        [self.statePanelLayerPlayer.manaLayer addManaArrayAtIndex:4 withValue:-5];
        //        return;
    }
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
//-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch* touch = [touches anyObject];
//	CGPoint location = [touch locationInView: touch.view];
//	location = [[CCDirector sharedDirector] convertToGL: location];
//    if(self.effectOn) self.touchStreak.position=location;
//    
//    [self ccTouchesBegan:touches withEvent:event];
//    
//    
//}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  	if (self.lockTouch) {
        return;
    }
    //NSSet *allTouches = [event allTouches];
    NSLog(@"touches Began %d",touches.count);
    
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
    //[self magicShootByName:@"bloodAbsorb"];
//    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"];
//
//    [self addChild:particle_system];
    
 	if (self.lockTouch) {
        return;
    }
     
    NSLog(@"touches End %d",touches.count);
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

    //判断是否 同一格(tap)
    for(MyPoint* touchBegan in self.touchesBeganArray){
        beganLocation =touchBegan;
        beganX=(beganLocation.x -kStartX) / kTileSize;
        beganY=(beganLocation.y -kStartY) / kTileSize;
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

    }
    [self touchedOnPointX:beganX Y:beganY];
    [self touchedOnPointX:x Y:y];
    
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
        
        if(tile.value>100&&(!tile.selected)){
            if (self.magicSelectedArray.count>=2) {
                self.selectedTile=nil;
                return;
            }
            tile.selected=YES;
            [self.magicSelectedArray addObject:tile];
            self.lastSelectTimeOfMagic=self.gameTime;
            self.selectedTile=nil;
            return;
            
        }
        
		return;
	}
    else{   //提上且不同一个
        if ([self.selectedTile nearTile:tile]&&self.selectedTile.value!=0) {  //相邻
            //[box setLock:YES];
            
            bool ret=[self changeWithTileA: self.selectedTile TileB: tile];
            //[self.selectedTile scaleToTileSize];
            self.selectedTile = nil;
            if(ret)
            {
                self.moveSuccessReady=YES;
                tile.tradeTile=YES;
                self.selectedTile.tradeTile=YES;
            }
            else{
                [self moveFailed];
            }
            return;
        }
        
        self.selectedTile=nil; //不相邻时 清空selected
        
    }

}

@end
