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
@interface PlayLayer()
@property  int whosTurn;
@property (strong,nonatomic) CCSprite* lifeBarOfPlayer;
@property (strong,nonatomic) CCSprite* lifeBarOfEnemy;
@property (strong,nonatomic) CCLabelTTF *curHPOfPlayer;
@property (strong,nonatomic) CCLabelTTF *maxHPOfPlayer;
@property (strong,nonatomic) CCLabelTTF *curHPOfEnemy;
@property (strong,nonatomic) CCLabelTTF *maxHPOfEnemy;
@property (strong,nonatomic) Person* player;
@property (strong,nonatomic) Person* enemy;
@property (strong,nonatomic) NSArray* turnOfPersons;
@property (strong,nonatomic) Tile *selectedTile;
@property (strong,nonatomic)  CCMotionStreak* touchStreak;
@property  int swapCount;
@property  bool updating;
@property  bool locking;
-(void)afterTurn: (id) node;
@end

@implementation PlayLayer
@synthesize selectedTile=_selectedTile;
-(id) init{
	self = [super init];
	
	CCSprite *bg = [CCSprite spriteWithFile: @"playLayer.jpg"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [bg setScaleX: winSize.width/bg.contentSize.width];
    [bg setScaleY: winSize.height/bg.contentSize.height];
	bg.position = ccp(winSize.width/2,winSize.height/2);
	[self addChild: bg z:0];

//    CCSprite *touchSprite= [CCSprite spriteWithFile: @"fire.png"];
//    [touchSprite setScaleX: 32/touchSprite.contentSize.width];
//    [touchSprite setScaleY: 32/touchSprite.contentSize.height];
//	touchSprite.position = ccp(winSize.width/2,winSize.height/2);
//	[self addChild: touchSprite z:0];
    

    
    
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) factor:6];
	box.layer = self;
	box.lock = YES;

    ai=[[AI alloc]initWithBox:box];
    
    self.player=[[Person alloc]init];
    self.player.curHP=100;
    self.player.maxHP=100;
    
    self.enemy=[[Person alloc]init];
    self.enemy.curHP=100;
    self.enemy.maxHP=100;
    
    [self updateStatePanel];
    //self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];
    
	self.isTouchEnabled = YES;
    self.whosTurn=Turn_Player;
    
	//[self schedule:@selector(changeTurn:) interval:.3];
    self.updating=NO;
    self.swapCount=0;
    self.locking=NO;
    [self schedule:@selector(update:) interval:0 repeat:kCCRepeatForever delay:3];
    //system=[CCParticleRain node];

    //[self addChild:[CCParticleFire node]];
    //[self addChild:[CCParticleFlower node]];
    [self addChild:[CCParticleGalaxy node]];
    [self addChild:[CCParticleRain node]];
    //[self addChild:[CCParticleSnow node]];
    //[self addChild:[CCParticleSun node]];
    //[self addChild:[CCParticleMeteor node]];
    
    
        self.touchStreak=[[CCMotionStreak alloc]initWithFade:.99f minSeg:8 width:64 color:ccc3(255,0,255) textureFilename:@"fire.png"];
    [self addChild:self.touchStreak];
    
    
	return self;
}

-(void)update:(ccTime)delta{
    if (self.locking) {
        return;
    }
    

    [self updateStatePanel];
    self.whosTurn=Turn_Player;
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

    if(ret){
        //NSLog(@"in check is value 5");
        NSArray* tmp=[box.readyToRemoveTiles allObjects];
        matchedArray=[box findMatchedArray:tmp forValue:5];
        if (matchedArray) {
            nextPerson.curHP-=10;
            
            self.enemy.curHP-=10;//testing
            if (self.enemy.curHP<=0) {
                [[CCDirector sharedDirector]replaceScene:[GameOverLayer sceneWithWon:YES]];
            }
        }
        [box removeAndRepair];
        //NSLog(@"in check is value 5 finished");

    }
//    if(box.allMoveDone&&!box.lock){
//        
//        if(self.whosTurn==Turn_Enemy){
//            [self computerAIgo];
//            self.whosTurn=(self.whosTurn+1) % 2;
//        }
//        
//    }
    self.updating=NO;
}
-(void)updateStatePanel{
    self.statePanelLayer.curHP=[NSString stringWithFormat:@"%d",self.player.curHP];
    self.statePanelLayer.maxHP=[NSString stringWithFormat:@"%d",self.player.maxHP];
    self.statePanelLayerEnemy.curHP=[NSString stringWithFormat:@"%d",self.enemy.curHP];
    self.statePanelLayerEnemy.maxHP=[NSString stringWithFormat:@"%d",self.enemy.maxHP];
    
}

-(void)computerAIgo{
    //NSLog(@"computerAIgo");
    NSArray* ret=[ai thinkAndFindTile];
    self.selectedTile=ret[0];
    Tile* tile=ret[1];
    if(ret){
		[box setLock:YES];
        
        [self performSelector:@selector(changeWithTileArray:) withObject:[NSArray arrayWithObjects:self.selectedTile,tile, nil] afterDelay:.8 ];


		//[self changeWithTileA: self.selectedTile TileB: tile];
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
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    self.touchStreak.position=location;
    
    [self ccTouchesBegan:touches withEvent:event];
    

}
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	//NSLog(@"ccTouchesBegan");
	
//	if ([box lock]) {
//        NSLog(@"locked return");
//		return;
//	}
//	if(!self.whosTurn==Turn_Player){
//        return;
//    }
//    if(!box.allMoveDone) return;

    
    
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
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
    
    //[box pushTilesToRemoveForValue:tile.value];  //magic
	
    if(!tile.isActionDone)return;
    if(tile.value==0)return;
	if (self.selectedTile && [self.selectedTile nearTile:tile]&&self.selectedTile.value!=0) {
//        if([box findMatchWithSwap:tile B:self.selectedTile]){
//            int a=1;
//        }
		[box setLock:YES];
		[self changeWithTileA: self.selectedTile TileB: tile];
        //[self.selectedTile scaleToTileSize];
		self.selectedTile = nil;
        self.whosTurn=(self.whosTurn+1) % 2;
	}else {
        [self.selectedTile scaleToTileSize];
		self.selectedTile = tile;
		[self afterTurn:tile.sprite];
	}
}

-(void) changeWithTileArray:(NSArray*)tiles{
    Tile* a=tiles[0];
    Tile* b=tiles[1];
    [self changeWithTileA:a TileB:b];
}
-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b{

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

        NSLog(@"in changeWithTile ready to swap a b ");
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
        NSLog(@"in changeWithTile finished");
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
    }

}
-(void)lock{
    while(self.updating){};
    self.locking=YES;
}
-(void)unlock{
    while(self.updating){};
    self.locking=NO;
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
@end
