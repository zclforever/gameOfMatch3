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
@interface PlayLayer()
@property  int whosTurn;
@property bool effectOn;
@property int level;
@property bool isSoundEnabled;
@property (strong,nonatomic) ActionQueue* actionHandler;
@property (strong,nonatomic) CCLabelTTF *testLabel;
@property (strong,nonatomic) CCLabelTTF *stepLabel;
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (weak,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property (strong,nonatomic) NSMutableArray* magicCastArray;
@property (strong,nonatomic) NSMutableArray* magicSelectedArray;

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
-(void)afterTurn: (id) node;
@end

@implementation PlayLayer
@synthesize selectedTile=_selectedTile;

-(id)initWithPlayer:(Person*)player withEnemy:(Person*)enemy{
	self = [super init];
    
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
    
    [self addChild:statePanelLayer z:2];
    
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
    
    
    
    
    [self updateStatePanel];
    self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];

    //    self.whosTurn=Turn_Enemy;
    //    self.lockTouch=YES;
    self.whosTurn=Turn_Player;
    self.lockTouch=NO;
    self.isStarting=NO;
    self.updating=NO;
    self.updateCount=0;
    self.magicCastArray=[[NSMutableArray alloc]init];
    self.magicSelectedArray=[[NSMutableArray alloc]init];
	self.isTouchEnabled = YES;
    
    
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
    
    label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];     //stepLabel
    
    label.opacity=250;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(250,385);
    [self addChild:label z:4];
    self.stepLabel=label;
    
  
    
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
    //self.actionHandler=nil;
    
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
-(void)handleTimeOut{
    float timeInterval=0.1f;
    
    self.enemy.curStep+=self.enemy.apSpeed*timeInterval;
    if (self.enemy.curStep>=self.enemy.maxStep) {
        [Actions shakeSprite:self.statePanelLayerPlayer.personSprite delay:0];
        self.player.curHP-=self.enemy.damage;
        
        self.enemy.curStep=0;
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
    
    self.gameTime+=delta;
    if (self.lockUpdate) {
        return;
    }
    
    
    [self updateStatePanel];
    [self checkGameOver];
    
    if (self.updating||!(self.swapCount<=0)) {
        return;
    }
    if (!box.readyToRemoveTiles) {
        return;
    }
    [self checkGameOver];
    self.updating=YES;
    self.updateCount++;
    
    __weak PlayLayer* obj=self;
    
    
    [box.removeResultArray removeAllObjects];
    [box check];
    NSArray* matchedArray;
    //Person* nextPerson=self.turnOfPersons[(self.whosTurn+1) % 2];
    
    if(self.gameTime-self.lastSelectTimeOfMagic>=zMagicCD&&(self.lastSelectTimeOfMagic!=0))
    {
        int count=self.magicSelectedArray.count;
        while(count>3){
            Tile* tile=self.magicSelectedArray[count-1];
            tile.selected=NO;
            [self.magicSelectedArray removeObjectAtIndex:count-1]; //万一在这个时候按到球
            
            count--;
        }
        float comboShootInterval=0.3f;
        
        NSMutableArray* magicCountArray=[[NSMutableArray alloc]initWithObjects:@0,@0,@0,@0, nil];
        for(int i=0;i<count;i++){
            Tile* tile=self.magicSelectedArray[0];
            [self.magicSelectedArray removeObjectAtIndex:0];
            int magicId=tile.value;
            magicCountArray[magicId-101]=[NSNumber numberWithInt:[magicCountArray[magicId-101] intValue]+1];
            [box.readyToRemoveTiles addObject:tile];
        }

        for(int i=0;i<4;i++){
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
        //test.
        
        
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
            self.player.scoreInBattle+=mount*100*mul;
        }
        
        NSArray* tmp=[box.readyToRemoveTiles allObjects];
        for(int i=0;i<4;i++){
            
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
        
        matchedArray=[box findMatchedArray:tmp forValue:6];
        if (matchedArray) {self.player.expInBattle+=matchedArray.count;}
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
            if(self.gameTime-self.lastTipTime>2.0f){  //有东西但是没拿 且过了x秒 提示
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
}
-(void)magicShootByName:(NSString*)name{
    __weak PlayLayer* obj=self;
    if([name isEqualToString:@"fireBall"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions fireBallToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=8;}];
            
        }];
    }
    
    if([name isEqualToString:@"iceBall"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions iceBallToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=8;}];
            
        }];
    }
    
    if([name isEqualToString:@"poison"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions poisonToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=8;}];
            
        }];
    }
    
    if([name isEqualToString:@"bloodAbsorb"]){
        
        [self.actionHandler addActionWithBlock:^{
            [Actions bloodAbsorbSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                obj.enemy.curHP-=8;}];
            
        }];
    }
}
-(void)updateStatePanel{
    self.statePanelLayerPlayer.curHP=[NSString stringWithFormat:@"%d",self.player.curHP];
    self.statePanelLayerPlayer.maxHP=[NSString stringWithFormat:@"%d",self.player.maxHP];
    self.statePanelLayerEnemy.curHP=[NSString stringWithFormat:@"%d",self.enemy.curHP];
    self.statePanelLayerEnemy.maxHP=[NSString stringWithFormat:@"%d",self.enemy.maxHP];
    
    [self.stepLabel setString:[NSString stringWithFormat:@"AP %f/%f",self.enemy.curStep,self.enemy.maxStep]];
    
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
    [self updateStatePanel];
    
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
    self.statePanelLayerPlayer.person=self.player;
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
    
    self.isSoundEnabled=YES;
    
    //add back layer
    __block PlayLayer* obj=self;
    [self setTimeOut:2.0 withBlock:^{
        [obj unlock];
    }];
    
    [self setTimeOut:0.0f withSelect:@selector(addBackLayer)];
    
    [self setTimeOut:0.0f];
    
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
        [unRemoveTile.actionSequence addObject:unRemoveAction];
        //[unRemoveTile.sprite runAction:unRemoveAction];
        //        [a.actionSequence addObject:actionA];
        //        [b.actionSequence addObject:actionB];
        //[a.sprite runAction:actionA];
        //[b.sprite runAction:actionB];
        [self lock];
        [box swapWithTile:a B:b];
        [self unlock];
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
    self.player.curHP-=10;
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
        Person* person=[Person sharedPlayer];
        person.money+=self.player.moneyInBattle;
        person.experience+=self.player.expInBattle;
        person.experience+=[[Global sharedManager] currentLevelOfGame]*25;
        person.money+=[[Global sharedManager] currentLevelOfGame]*25;
        
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:YES FromBattle:self]];
    }
    else if (self.player.curHP<=0){
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
//	location = [[CCDirector sharedDirector] convertToGL: location];
//    if(self.effectOn) self.touchStreak.position=location;
//    
//    //[self ccTouchesBegan:touches withEvent:event];
//    
//    
//}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    if(self.effectOn) self.touchStreak.position=location;
    
    [self ccTouchesBegan:touches withEvent:event];
    
    
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    
    
 	if (self.lockTouch) {
        return;
    }
    
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    

    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	int x = (location.x -kStartX) / kTileSize;
	int y = (location.y -kStartY) / kTileSize;
	
	//test
    //[self magicShootByName:@"bloodAbsorb"];
    
    
	if (self.selectedTile && self.selectedTile.x ==x && self.selectedTile.y == y) {
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
    //tile=[box objectAtX:3 Y:3];
    //self.selectedTile=[box objectAtX:3 Y:4];
    
    
	
    //if(!tile.isActionDone)return;
    if(tile.value==0)return;

    

	if (self.selectedTile && [self.selectedTile nearTile:tile]&&self.selectedTile.value!=0) {
        //        if([box findMatchWithSwap:tile B:self.selectedTile]){
        //            int a=1;
        //        }
		[box setLock:YES];
        
		bool ret=[self changeWithTileA: self.selectedTile TileB: tile];
        //[self.selectedTile scaleToTileSize];
		self.selectedTile = nil;
        if(ret)
        {self.moveSuccessReady=YES;}
        else{
            [self moveFailed];
        }
        return;
	}
    if(tile.value>100&&(!tile.selected)){
        if (self.magicSelectedArray.count>=3) {
            return;
        }
        tile.selected=YES;
        [self.magicSelectedArray addObject:tile];
        self.lastSelectTimeOfMagic=self.gameTime;
        self.selectedTile=nil;
        return;
        
    }
    
    
    if(tile.value>100){
        self.selectedTile=nil;
        return;
    }
    
    if (self.selectedTile && (![self.selectedTile nearTile:tile])){
        self.selectedTile = tile;
        return;
    }
    if(!self.selectedTile) {
		self.selectedTile = tile;
        return;

	}
}

@end
