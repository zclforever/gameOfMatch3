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
@interface PlayLayer()
@property  int whosTurn;
@property bool effectOn;
@property int level;
@property bool isSoundEnabled;
@property (strong,nonatomic) ActionQueue* actionHandler;
@property (strong,nonatomic) CCLabelTTF *testLabel;
@property (strong,nonatomic) CCLabelTTF *stepLabel;
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (strong,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property (strong,nonatomic) NSMutableArray* magicCastArray;

@property int swapCount;
@property bool updating;
@property bool lockUpdate;
@property bool lockTouch;
@property int timeCount;
@property int updateCount;
@property bool isStarting;
@property bool moveSuccessReady;

@property bool usingMagic;
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
	box.layer = self;
	box.lock = YES;
    
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
        [self addChild:self.touchStreak];
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
    
    label = [CCLabelTTF labelWithString:@"返回" fontName:@"Arial" fontSize:18];
    label.opacity=250;
    label.color = ccc3(255,255,230);
    CCMenuItemLabel* menuLabel=[CCMenuItemLabel itemWithLabel:label block:^(id sender) {
        [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
    }];
    
    CCMenu* backMenu=[CCMenu menuWithItems:menuLabel, nil];
    backMenu.anchorPoint=ccp(0,0);
    backMenu.position = ccp(100,30);
    [self addChild:backMenu z:4];
    
    
    

	return self;
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
    int CD=8.0f;
    
    
    if(self.timeCount<CD&&!self.isStarting){
        self.isStarting=YES;
        //addMagic
        [self.statePanelLayerPlayer addMagicLayerWithMagicName:@"removeValue_3"];
        [self.statePanelLayerPlayer addMagicLayerWithMagicName:@"removeValue_2"];
        
        //readyGO
        [self addReadyGo];
        [self setTimeOut:3.7f];
        return;
        
    }
    
    
    //changeTurn
    if (self.timeCount%CD==0) {
        self.whosTurn=(self.whosTurn+1) % 2;
        
    }
    if(self.whosTurn==Turn_Enemy){
        self.lockTouch=YES;
        [self computerAIgo];
        
        
    }else{
        self.lockTouch=NO;
    }
    
    // setLabel
    NSString* message=[NSString stringWithFormat:@"玩家回合"];
    if (self.whosTurn==Turn_Player) {
        message=[message stringByAppendingFormat:@"  %d",CD-self.timeCount%CD];
        [self.testLabel setString:message];
        self.testLabel.scale=100/self.testLabel.contentSize.width;
        
        self.testLabel.position=ccp(0,150);
    }
    if (self.whosTurn==Turn_Enemy) {
        message=@"敌方行动";
        message=[message stringByAppendingFormat:@"  %d",CD-self.timeCount%CD];
        [self.testLabel setString:message];
        self.testLabel.position=ccp(self.contentSize.width/2-140,self.contentSize.height/2);
        //self.testLabel.scale=300.0f/self.testLabel.contentSize.width;
        self.testLabel.scale=1;
    }
    
    //NSLog(@"font pos %f %f",self.testLabel.contentSize.width,self.testLabel.contentSize.height);
    
    
    
    self.timeCount++;
    [self setTimeOut:1.0f];
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
-(void)update:(ccTime)delta{   //.update.
    self.gameTime+=delta;
    if (self.lockUpdate) {
        return;
    }
    
    
    [self updateStatePanel];
    
    if (self.updating||!(self.swapCount<=0)) {
        return;
    }
    if (!box.readyToRemoveTiles) {
        return;
    }
    [self checkGameOver];
    self.updating=YES;
    self.updateCount++;
    
    [box.removeResultArray removeAllObjects];
    [box check];
    NSArray* matchedArray;
    //Person* nextPerson=self.turnOfPersons[(self.whosTurn+1) % 2];
    
    //checkMagic
    int countOfMagicCastArray=self.magicCastArray.count;
    
    //countOfMagicCastArray=0;
    for(int i=0;i<countOfMagicCastArray;i++){
        int index=[self.magicCastArray[0] intValue]; //取出Magic
        [self.magicCastArray removeObjectAtIndex:0];
        
        MagicLayer* magicLayer=self.statePanelLayerPlayer.magicLayerArray[index];
        if(magicLayer&&magicLayer.isManaReady){
            if(magicLayer.isSelected){
                if(magicLayer.magicEnabled ){ //魔法 准备发射
                    if([magicLayer.magic.name isEqualToString:@"fireBall"]){
                        NSLog(@"魔法发射");
                        __weak PlayLayer* obj=self;
                        [self.actionHandler addActionWithBlock:^{
                            [Actions fireBallToSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                                obj.enemy.curHP-=30;}];
                            
                        }];
                        
                        [self.statePanelLayerPlayer.manaLayer calcManaAfterShootWithMagic:magicLayer.magic]; //减掉魔法
                    }
                    
                    magicLayer.isSelected=NO;
                    
                }
            }
            else if(!magicLayer.isSelected){
                magicLayer.isSelected=YES;
                continue;
            }
            
            //[self.statePanelLayerPlayer setMagicState:NO atIndex:index];
            //            [box pushTilesToRemoveForValue:magicLayer.magic.value];
            
            
            //            [self.statePanelLayerPlayer runAction:
            //             [CCSequence actions:
            //              [CCDelayTime actionWithDuration:magicLayer.magic.CD],
            //              [CCCallBlockN actionWithBlock:^(CCNode *node) {
            //                 [(StatePanelLayerInBattle*)node setMagicState:YES atIndex:index];
            //             }],
            //
            //              nil]];
            
        }
        
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
                CCLabelTTF* showLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"额外%d步",mount-3] fontName:@"Arial" fontSize:48];
                showLabel.anchorPoint=ccp(0,0);
                showLabel.position=ccp(260,160);
                [self addChild:showLabel];
                [showLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:3.0f],[CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [node removeFromParentAndCleanup:YES];
                }], nil]];
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
            __weak PlayLayer* obj=self;

            [self.actionHandler addActionWithBlock:^{
                
                [Actions attackSpriteB:obj.statePanelLayerEnemy.personSprite fromSpriteA:obj.statePanelLayerPlayer.personSprite withFinishedBlock:^{
                    obj.enemy.curHP-=matchedArray.count;}];
                
            }];

        }
        
        matchedArray=[box findMatchedArray:tmp forValue:6];
        if (matchedArray) {self.player.expInBattle+=matchedArray.count;}
        matchedArray=[box findMatchedArray:tmp forValue:7];
        if (matchedArray) {self.player.curHP+=matchedArray.count;
            self.player.curHP=self.player.curHP<=self.player.maxHP?self.player.curHP:self.player.maxHP;}
        
        [box removeAndRepair];
        if(self.moveSuccessReady){
            [self setTimeOut:0.1 withSelect:@selector(moveSuccess)];
            self.moveSuccessReady=NO;
        }
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
-(void)updateStatePanel{
    self.statePanelLayerPlayer.curHP=[NSString stringWithFormat:@"%d",self.player.curHP];
    self.statePanelLayerPlayer.maxHP=[NSString stringWithFormat:@"%d",self.player.maxHP];
    self.statePanelLayerEnemy.curHP=[NSString stringWithFormat:@"%d",self.enemy.curHP];
    self.statePanelLayerEnemy.maxHP=[NSString stringWithFormat:@"%d",self.enemy.maxHP];
    
    [self.stepLabel setString:[NSString stringWithFormat:@"AP %d/%d",self.enemy.curStep,self.enemy.maxStep]];
    
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
    while(box.readyToRemoveTiles.count>0){
        
        [box removeAndRepair];
        [box check];
    }
    [self unlock];
    
    CGSize winSize=[[CCDirector sharedDirector] winSize];
    
    [self.statePanelLayerPlayer addMagicLayerWithMagicName:@"fireBall"];
    self.statePanelLayerPlayer.person=self.player;
    [self.statePanelLayerPlayer addPersonSpriteAtPosition:ccp(zPlayerMarginLeft,winSize.height-zPlayerMarginTop)];
    [self.statePanelLayerPlayer addBorderOfMagic];
    [self.statePanelLayerPlayer addMoneyExpLabel];
    [self.statePanelLayerPlayer addScoreLayer];
    [self.statePanelLayerPlayer addManaLayer];
    
    
    self.statePanelLayerEnemy.person=self.enemy;
    [self.statePanelLayerEnemy addPersonSpriteAtPosition:ccp(zEnemyMarginLeft,winSize.height-zPlayerMarginTop)];
    self.isSoundEnabled=YES;
    
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
        self.lockTouch=YES;
        bool magicAttack=YES;
        
        int minTimes=0;
        //        Magic* magic=self.statePanelLayerPlayer.magicArray[0];
        //        int minTimes=10;
        //        for(int i=0;i<4;i++){    //check magic attain
        //            int value=[self.statePanelLayerPlayer.manaArray[i] intValue];
        //            int times=value/[magic.manaCostArray[i] intValue];
        //            if(times<minTimes)minTimes=times;
        //            if(times==0){
        //                magicAttack=NO;
        //                break;
        //            }
        //        }
        
        finalDam=self.player.damage;
        if(magicAttack){
            finalDam+=self.player.magicDamage*minTimes;
        }
        
        [Actions shakeSprite:self.statePanelLayerPlayer.personSprite delay:0];
        //来个动画
        /*
         CCLayerColor* animationLayer=[[CCLayerColor alloc]initWithColor:ccc4(0, 0, 0, 200)];
         [self addChild:animationLayer z:10];
         
         CCSprite* playerSprite=[CCSprite spriteWithFile:self.player.spriteName];
         playerSprite.position=ccp(50,150);
         playerSprite.scale=self.player.spriteScale;
         CCSprite* enemySprite=[CCSprite spriteWithFile:self.enemy.spriteName];
         enemySprite.position=ccp(380,150);
         enemySprite.scale=self.enemy.spriteScale;
         [self addChild:playerSprite z:11];
         [self addChild:enemySprite z:11];
         
         CCLabelTTF* playerDamageLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"-%d",finalDam] fontName:@"Arial" fontSize:28];
         playerDamageLabel.scale=0;
         playerDamageLabel.position=ccp(350,280);
         CCLabelTTF* enemyDamageLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"-%d",enemy_dam] fontName:@"Arial" fontSize:28];
         enemyDamageLabel.scale=0;
         enemyDamageLabel.position=ccp(70,280);
         
         [self addChild:playerDamageLabel z:11];
         [self addChild:enemyDamageLabel z:11];
         
         
         [self runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:1],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [[SimpleAudioEngine sharedEngine] playEffect:@"ada.m4a"];
         }], nil]];
         [playerDamageLabel runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:2.5],
         [CCScaleTo actionWithDuration:1.0 scale:1.0],
         //[CCMoveTo actionWithDuration:1.0 position:ccp(360,150)],
         //[CCMoveTo actionWithDuration:1.0 position:ccp(50,150)],
         [CCDelayTime actionWithDuration:4.0],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
         }], nil]];
         
         [enemyDamageLabel runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:5.5],
         [CCScaleTo actionWithDuration:0.5 scale:1.0],
         //[CCMoveTo actionWithDuration:1.0 position:ccp(360,150)],
         //[CCMoveTo actionWithDuration:1.0 position:ccp(50,150)],
         [CCDelayTime actionWithDuration:1.5],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [node removeFromParentAndCleanup:YES];
         }], nil]];
         
         [playerSprite runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:1.0],
         [CCMoveTo actionWithDuration:0.5 position:ccp(280,300)],
         [CCMoveTo actionWithDuration:0.5 position:ccp(340,200)],
         
         [CCMoveTo actionWithDuration:0.1 position:ccp(310,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(340,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(310,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(340,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(310,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(340,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(310,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(340,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(310,200)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(340,200)],
         
         [CCMoveTo actionWithDuration:0.5 position:ccp(50,150)],
         [CCDelayTime actionWithDuration:4.0],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         self.player.curHP-=enemy_dam;
         [node removeFromParentAndCleanup:YES];
         }], nil]];
         //Person* player=(Person*)object;
         //player.curHP-=enemy_dam;
         
         //[self removeFromParentAndCleanup:YES];
         [self runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:3.3],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [[SimpleAudioEngine sharedEngine] playEffect:@"yamede.m4a"];
         }], nil]];
         [self runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:4.8],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         [[SimpleAudioEngine sharedEngine] playEffect:@"yamede2.m4a"];
         }], nil]];
         [enemySprite runAction:[CCSequence actions:
         [CCDelayTime actionWithDuration:4.0],
         [CCMoveTo actionWithDuration:0.5 position:ccp(50,300)],
         [CCMoveTo actionWithDuration:0.5 position:ccp(50,150)],
         [CCMoveTo actionWithDuration:0.5 position:ccp(50,250)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,150)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,250)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,150)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,250)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,150)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,250)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,150)],
         [CCMoveTo actionWithDuration:0.1 position:ccp(50,250)],
         [CCMoveTo actionWithDuration:1.0 position:ccp(380,150)],
         [CCDelayTime actionWithDuration:0.1],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         self.enemy.curHP-=finalDam;
         [node removeFromParentAndCleanup:YES];
         }], nil]];
         
         [animationLayer runAction:[CCSequence actions:[CCDelayTime actionWithDuration:8.0],
         [CCCallBlockN actionWithBlock:^(CCNode *node) {
         //self.enemy.curHP-=finalDam;
         [node removeFromParentAndCleanup:YES];
         }], nil]];
         
         //        self.enemy.curHP-=finalDam;
         //        self.player.curHP-=enemy_dam;
         
         
         
         [self setTimeOut:8.0 withSelect:@selector(battleFinish)];
         */
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
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    if(self.effectOn) self.touchStreak.position=location;
    
    [self ccTouchesBegan:touches withEvent:event];
    
    
}
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    
	//NSLog(@"ccTouchesBegan");
	
    //	if ([box lock]) {
    //        NSLog(@"locked return");
    //		return;
    //	}
    //    if(!box.allMoveDone) return;
    
 	if (self.lockTouch) {
        return;
    }
    
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    
    //是否按下魔法
    CGPoint statePlayerPos=[self.statePanelLayerPlayer convertTouchToNodeSpace:touch];
    int index=[self.statePanelLayerPlayer findMagicTouchedIndex:statePlayerPos];
    
    if(index>=0){
        [self.magicCastArray addObject:[NSNumber numberWithInt:index]];
        
        //todo 这里要加上魔法介绍
        return;
    }    
    //是否按下魔法转换
    //    CGPoint manaLayerPos=[self.statePanelLayerPlayer.manaLayer convertTouchToNodeSpace:touch];
    //    index=[self.statePanelLayerPlayer findManaTouchedIndex:manaLayerPos];
    //
    //    if(index>=0){
    //        [self converManaAtIndex:index];
    //        return;
    //    }
    
    
	
    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	int x = (location.x -kStartX) / kTileSize;
	int y = (location.y -kStartY) / kTileSize;
	
	
	if (self.selectedTile && self.selectedTile.x ==x && self.selectedTile.y == y) {
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
    //tile=[box objectAtX:3 Y:3];
    //self.selectedTile=[box objectAtX:3 Y:4];
    
    
	
    if(!tile.isActionDone)return;
    if(tile.value==0)return;
    
    //    if(self.usingMagic){
    //        [box pushTilesToRemoveForValue:tile.value];  //magic
    //        self.usingMagic=NO;
    //    }
    
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
	}else {
        //[self.selectedTile scaleToTileSize];
		self.selectedTile = tile;
		//[self afterTurn:tile.sprite];
	}
}

@end
