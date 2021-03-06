//
//  PlayLayer.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "PlayLayer.h"
@interface PlayLayer()
@property bool updating;
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
	
	self.isTouchEnabled = YES;
    self.updating=NO;
    [self schedule:@selector(update:)];
	return self;
}
-(void)update:(ccTime)delta{
    

    if (self.updating) {
        return;
    }
//    if (!box.readyToRemoveTiles) {
//        return;
//    }
    self.updating=YES;
    //NSLog(@"in update");

    [box check];

    self.updating=NO;
}

-(void) onEnterTransitionDidFinish{
	//[box check];
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	NSLog(@"ccTouchesBegan");
	
	if ([box lock]) {
		return;
	}
	
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	
	int x = (location.x -kStartX) / kTileSize;
	int y = (location.y -kStartY) / kTileSize;
	
	
	if (selectedTile && selectedTile.x ==x && selectedTile.y == y) {
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
	
	if (selectedTile && [selectedTile nearTile:tile]) {
		[box setLock:YES];
		[self changeWithTileA: selectedTile TileB: tile sel: @selector(check:data:)];
		selectedTile = nil;
	}else {
		selectedTile = tile;
		[self afterTurn:tile.sprite];
	}
}

-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b sel : (SEL) sel{
	CCAction *actionA = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[b pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: (void*)a],
						 nil
						 ];
	
	CCAction *actionB = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[a pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: (void*)b],
						 nil
						 ];
	[a.sprite runAction:actionA];
	[b.sprite runAction:actionB];
	
	[a trade:b];
}

-(void) backCheck: (id) sender data: (id) data{
	if(nil == firstOne){
		firstOne = data;
		return;
	}
	firstOne = nil;
	[box setLock:NO];
}

-(void) check: (id) sender data: (id) data{
	if(nil == firstOne){
		firstOne = data;
		return;
	}
	BOOL result = [box check];
	if (result) {
		[box setLock:NO];
	}else {
		[self changeWithTileA:(Tile *)data TileB:firstOne sel:@selector(backCheck:data:)];
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kMoveTileTime + 0.03f],
						 [CCCallFunc actionWithTarget:box selector:@selector(unlock)],
						 nil]];
	}
    
	firstOne = nil;
}


-(void)afterTurn: (id) node{
	if (selectedTile && node == selectedTile.sprite) {
		CCSprite *sprite = (CCSprite *)node;
		CCSequence *someAction = [CCSequence actions:
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:0.5f],
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:2.0f],
								  [CCCallFuncN actionWithTarget:self selector:@selector(afterTurn:)],
								  nil];
		
		[sprite runAction:someAction];
	}
}
@end
