//
//  PlayLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "PlayLayer.h"
#import "GameOverLayer.h"
#import "Person.h"
#import "ManaLayer.h"
@interface PlayLayer()
@property  int whosTurn;
@property bool effectOn;
@property (strong,nonatomic) CCLabelTTF *testLabel;
@property (strong,nonatomic) CCLabelTTF *stepLabel;
@property (strong,nonatomic) Person* player;
@property (strong,nonatomic) Person* enemy;
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (strong,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property (strong,nonatomic) NSMutableArray* magicCastArray;

@property int swapCount;
@property bool updating;
@property bool lockUpdate;
@property bool lockTouch;
@property int timeCount;
@property bool isStarting;

@property bool usingMagic;
-(void)afterTurn: (id) node;
@end

@implementation PlayLayer
@synthesize selectedTile=_selectedTile;
-(id) init{
	self = [super init];
    
    self.effectOn=NO;
    self.effectOn=YES;
	
	CCSprite *bg = [CCSprite spriteWithFile: @"playLayer.jpg"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [bg setScaleX: winSize.width/bg.contentSize.width];
    [bg setScaleY: winSize.height/bg.contentSize.height];
	bg.position = ccp(winSize.width/2,winSize.height/2);
	[self addChild: bg z:0];
    
    
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) factor:6];
	box.layer = self;
	box.lock = YES;
    
    ai=[[AI alloc]initWithBox:box];
    
    self.player=[[Person alloc]init];
    self.player.curHP=100;
    self.player.maxHP=100;
    self.player.maxStep=5;
    self.player.curStep=self.player.maxStep;
    
    self.enemy=[[Person alloc]init];
    self.enemy.curHP=100;
    self.enemy.maxHP=100;
    
    
    
    [self updateStatePanel];
    self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];
    //    self.whosTurn=Turn_Enemy;
    //    self.lockTouch=YES;
    self.whosTurn=Turn_Player;
    self.lockTouch=NO;
    self.isStarting=NO;
    self.updating=NO;
    
    self.magicCastArray=[[NSMutableArray alloc]init];
    
	self.isTouchEnabled = YES;
    
    
	//[self schedule:@selector(changeTurn:) interval:.3];
    self.updating=NO;
    self.swapCount=0;
    self.lockUpdate=NO;
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
    
    
    label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:18];
    label.opacity=100;
    label.color = ccc3(255,255,230);
    label.anchorPoint=ccp(0,0);
    label.position = ccp(10,150);
    [self addChild:label z:4];
    
    self.stepLabel=label;
    
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
-(void)update:(ccTime)delta{   //.update
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
    self.updating=YES;
    
    
    
    bool ret=[box check];
    NSArray* matchedArray;
    Person* nextPerson=self.turnOfPersons[(self.whosTurn+1) % 2];
    
    //checkMagic
    int countOfMagicCastArray=self.magicCastArray.count;
    
    countOfMagicCastArray=0;
    for(int i=0;i<countOfMagicCastArray;i++){
        int index=[self.magicCastArray[0] intValue]; //取出Magic
        [self.magicCastArray removeObjectAtIndex:0];
        
        MagicLayer* magicLayer=self.statePanelLayerPlayer.magicLayerArray[index];
        if(magicLayer&&magicLayer.magicEnabled){
            //self.usingMagic=YES;  // 这种是要点棋盘，
            [self.statePanelLayerPlayer setMagicState:NO atIndex:index]; //不能点 等同于magicLayer.magicEnabled=NO;
            
            [box pushTilesToRemoveForValue:magicLayer.magic.value];
            
            [self.statePanelLayerPlayer runAction:
             [CCSequence actions:
              [CCDelayTime actionWithDuration:magicLayer.magic.CD],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 [(StatePanelLayer*)node setMagicState:YES atIndex:index];
             }],
              
              nil]];
            
        }
        
    }
    
    
    if(box.readyToRemoveTiles.count>0){
        //NSLog(@"in check is value 5");
        for(int i=0;i<5;i++){
            NSArray* tmp=[box.readyToRemoveTiles allObjects];
            matchedArray=[box findMatchedArray:tmp forValue:i+1];
            if (matchedArray) {
                [self.statePanelLayerPlayer.manaLayer addManaArrayAtIndex:i withValue:matchedArray.count];
            }
            
            
            
        }
        
        
        //        NSArray* tmp=[box.readyToRemoveTiles allObjects];
        //        matchedArray=[box findMatchedArray:tmp forValue:5];
        //        if (matchedArray) {
        //            nextPerson.curHP-=matchedArray.count;
        //
        //            if (self.enemy.curHP<=0) {
        //                [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:YES]];
        //            }
        //            if (self.player.curHP<=0) {
        //                [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
        //            }
        //        }
        [box removeAndRepair];
        //NSLog(@"in check is value 5 finished");
        
    }
    
    self.updating=NO;
}
-(void)updateStatePanel{
    self.statePanelLayerPlayer.curHP=[NSString stringWithFormat:@"%d",self.player.curHP];
    self.statePanelLayerPlayer.maxHP=[NSString stringWithFormat:@"%d",self.player.maxHP];
    self.statePanelLayerEnemy.curHP=[NSString stringWithFormat:@"%d",self.enemy.curHP];
    self.statePanelLayerEnemy.maxHP=[NSString stringWithFormat:@"%d",self.enemy.maxHP];
    
    [self.stepLabel setString:[NSString stringWithFormat:@"剩余步数 %d",self.player.curStep]];
    
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
    
    [self.statePanelLayerPlayer addMagicLayerWithMagicName:@"magicAttackType_1"];
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
    [lastTile scaleToTileSize];
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
-(void)moveSuccess{
    int finalDam=0;
    int enemy_dam=10;
    
    self.player.curStep--;
    if(self.player.curStep<=0){   //turnFinished
        self.lockTouch=YES;
        bool magicAttack=YES;
        Magic* magic=self.statePanelLayerPlayer.magicArray[0];
        for(int i=0;i<4;i++){
            int value=[self.statePanelLayerPlayer.manaArray[i] intValue];
            
            if(value<[magic.manaCostArray[i] intValue]){magicAttack=NO;break;}
        }
        
        finalDam=5;
        if(magicAttack){
            finalDam+=20;
        }
        self.enemy.curHP-=finalDam;
        self.player.curHP-=enemy_dam;
        
        if (self.enemy.curHP<=0) {
            [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:YES]];
        }
        else if (self.player.curHP<=0){
            [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:NO]];
            
        }
        
        [self setTimeOut:3.0 withSelect:@selector(battleFinish)];
        
    }
}
-(void)battleFinish{
    self.player.curStep=self.player.maxStep;
    self.lockTouch=NO;
    for(int i=0;i<4;i++){
        [self.statePanelLayerPlayer.manaLayer setManaArrayAtIndex:i withValue:0];
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
        return;
    }
    
    //是否按下魔法转换
    CGPoint manaLayerPos=[self.statePanelLayerPlayer.manaLayer convertTouchToNodeSpace:touch];
    index=[self.statePanelLayerPlayer findManaTouchedIndex:manaLayerPos];
    
    if(index>=0){
        [self converManaAtIndex:index];
        return;
    }
    
    
	
    float kStartX=[[consts sharedManager] kStartX];
    float kStartY=[[consts sharedManager] kStartY];
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
        if(ret)[self moveSuccess];
	}else {
        [self.selectedTile scaleToTileSize];
		self.selectedTile = tile;
		[self afterTurn:tile.sprite];
	}
}

@end
