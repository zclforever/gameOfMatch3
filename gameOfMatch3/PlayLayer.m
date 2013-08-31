//
//  PlayLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "PlayLayer.h"

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
@property  int swapCount;
@property  bool updating;
-(void)afterTurn: (id) node;
@end

@implementation PlayLayer

-(id) init{
	self = [super init];
	
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
    
    self.enemy=[[Person alloc]init];
    self.enemy.curHP=100;
    self.enemy.maxHP=100;

    self.turnOfPersons=[NSArray arrayWithObjects:self.player, self.enemy, nil];
    self.lifeBarOfPlayer=[CCSprite spriteWithFile:@"lifeBar.png" ];
    [self.lifeBarOfPlayer setScaleY:15.0/self.lifeBarOfPlayer.contentSize.height];
    self.lifeBarOfPlayer.position=ccp(5,300);
    self.lifeBarOfPlayer.anchorPoint=ccp(0,0);
    [self addChild:self.lifeBarOfPlayer];

    
    CCLabelTTF * label = [CCLabelTTF labelWithString:@"/" fontName:@"Georgia-Bold" fontSize:14];
    label.color = ccc3(255,255,255);
    label.position = ccp(self.lifeBarOfPlayer.position.x+self.lifeBarOfPlayer.contentSize.width/2-label.contentSize.width/2, self.lifeBarOfPlayer.position.y+self.lifeBarOfPlayer.contentSize.height/2);
    [self addChild:label];
    
    self.curHPOfPlayer=[CCLabelTTF labelWithString:@"0" fontName:@"Georgia-Bold" fontSize:14];
    self.curHPOfPlayer.color = ccc3(255,255,255);
    self.curHPOfPlayer.position = ccp(self.lifeBarOfPlayer.position.x+self.lifeBarOfPlayer.contentSize.width/3-self.curHPOfPlayer.contentSize.width/2, self.lifeBarOfPlayer.position.y+self.lifeBarOfPlayer.contentSize.height/2);
    [self addChild:self.curHPOfPlayer];
    
    self.maxHPOfPlayer=[CCLabelTTF labelWithString:@"0" fontName:@"Georgia-Bold" fontSize:14];
    self.maxHPOfPlayer.color = ccc3(255,255,255);
    self.maxHPOfPlayer.position = ccp(self.lifeBarOfPlayer.position.x+self.lifeBarOfPlayer.contentSize.width*2/3-self.maxHPOfPlayer.contentSize.width/2, self.lifeBarOfPlayer.position.y+self.maxHPOfPlayer.contentSize.height/2);
    [self addChild:self.maxHPOfPlayer];
    
    [self setLabelString:self.curHPOfPlayer withInt:self.player.curHP];
    [self setLabelString:self.maxHPOfPlayer withInt:self.player.maxHP];
    
    
    
    self.lifeBarOfEnemy=[CCSprite spriteWithFile:@"lifeBar.png" ];
    [self.lifeBarOfEnemy setScaleY:15.0/self.lifeBarOfEnemy.contentSize.height];
    self.lifeBarOfEnemy.position=ccp(winSize.width/2+kBoxWidth*kTileSize/2,300);
    self.lifeBarOfEnemy.anchorPoint=ccp(0,0);
    [self addChild:self.lifeBarOfEnemy];
    
    //init Enemy
    CCLabelTTF * label2 = [CCLabelTTF labelWithString:@"/" fontName:@"Georgia-Bold" fontSize:14];
    label2.color = ccc3(255,255,255);
    label2.position = ccp(self.lifeBarOfEnemy.position.x+self.lifeBarOfEnemy.contentSize.width/2-label.contentSize.width/2, self.lifeBarOfEnemy.position.y+self.lifeBarOfEnemy.contentSize.height/2);
    [self addChild:label2];
    
    self.curHPOfEnemy=[CCLabelTTF labelWithString:@"0" fontName:@"Georgia-Bold" fontSize:14];
    self.curHPOfEnemy.color = ccc3(255,255,255);
    self.curHPOfEnemy.position = ccp(self.lifeBarOfEnemy.position.x+self.lifeBarOfEnemy.contentSize.width/3-self.curHPOfEnemy.contentSize.width/2, self.lifeBarOfEnemy.position.y+self.lifeBarOfEnemy.contentSize.height/2);
    [self addChild:self.curHPOfEnemy];
    

    self.maxHPOfEnemy=[CCLabelTTF labelWithString:@"0" fontName:@"Georgia-Bold" fontSize:14];
    self.maxHPOfEnemy.color = ccc3(255,255,255);
    self.maxHPOfEnemy.position = ccp(self.lifeBarOfEnemy.position.x+self.lifeBarOfEnemy.contentSize.width*2/3-self.maxHPOfEnemy.contentSize.width/2, self.lifeBarOfEnemy.position.y+self.lifeBarOfEnemy.contentSize.height/2);
    [self addChild:self.maxHPOfEnemy];
    
    [self setLabelString:self.curHPOfEnemy withInt:self.enemy.curHP];
    [self setLabelString:self.maxHPOfEnemy withInt:self.enemy.maxHP];
    
    
	self.isTouchEnabled = YES;
    self.whosTurn=Turn_Player;
    
	//[self schedule:@selector(changeTurn:) interval:.3];
    self.updating=NO;
    self.swapCount=0;
    [self schedule:@selector(update:)];
	return self;
}
-(void)setLabelString:(CCLabelTTF*)label withInt:(int)value{
    [label setString:[NSString stringWithFormat:@"%d",value]];
}
-(void)update:(ccTime)delta{
    self.whosTurn=Turn_Player;
    if (self.updating||!(self.swapCount<=0)) {
        return;
    }
    if (!box.readyToRemoveTiles) {
        return;
    }
    self.updating=YES;
    //NSLog(@"in update");
    [self.lifeBarOfPlayer setScaleX:self.player.curHP/self.lifeBarOfPlayer.contentSize.width];
    [self setLabelString:self.curHPOfPlayer withInt:self.player.curHP];
    [self.lifeBarOfEnemy setScaleX:self.player.curHP/self.lifeBarOfEnemy.contentSize.width];
    [self setLabelString:self.curHPOfEnemy withInt:self.player.curHP];

    bool ret=[box check];
    NSArray* matchedArray;
    Person* nextPerson=self.turnOfPersons[(self.whosTurn+1) % 2];

    if(ret){
        NSLog(@"in check is value 5");
//        NSArray* tmp=[box.readyToRemoveTiles allObjects];
//        matchedArray=[box findMatchedArray:tmp forValue:5];
//        if (matchedArray) {
//            nextPerson.curHP-=10;
//        }
        [box removeAndRepair];
        NSLog(@"in check is value 5 finished");

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

-(void)computerAIgo{
    //NSLog(@"computerAIgo");
    NSArray* ret=[ai thinkAndFindTile];
    selectedTile=ret[0];
    Tile* tile=ret[1];
    if(ret){
		[box setLock:YES];
        
        [self performSelector:@selector(changeWithTileArray:) withObject:[NSArray arrayWithObjects:selectedTile,tile, nil] afterDelay:.8 ];


		//[self changeWithTileA: selectedTile TileB: tile];
		selectedTile = nil;
        //self.player.curHP-=10;

    }
}
-(void) onEnterTransitionDidFinish{
	//[box check];
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch  *touch = [touches anyObject];
    CGPoint  location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
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
	
	
	if (selectedTile && selectedTile.x ==x && selectedTile.y == y) {
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
    
	if(!tile.isActionDone)return;
    
	if (selectedTile && [selectedTile nearTile:tile]) {
		[box setLock:YES];
		[self changeWithTileA: selectedTile TileB: tile];
		selectedTile = nil;
        self.whosTurn=(self.whosTurn+1) % 2;
	}else {
        [selectedTile scaleToTileSize];
		selectedTile = tile;
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
//        [a.actionSequence addObject:actionA];
//        [b.actionSequence addObject:actionB];
        //[a.sprite runAction:actionA];
        //[b.sprite runAction:actionB];
        [box swapWithTile:a B:b];
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
        //[a.actionSequence addObject:actionA];
        //[b.actionSequence addObject:actionB];
        [a.sprite runAction:actionA];
        [b.sprite runAction:actionB];
    }

}


-(void)afterTurn: (id) node{
    CCSprite *sprite = (CCSprite *)node;
	if (selectedTile && node == selectedTile.sprite) {
        [sprite setScaleX: kTileSize/sprite.contentSize.width];
        [sprite setScaleY: kTileSize/sprite.contentSize.height];
        if([box readyToRemoveTiles].count>0||sprite.numberOfRunningActions>1){
            
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
		//selectedTile.ccSequnce2=someAction;
		[sprite runAction:someAction];
	}
}
@end
