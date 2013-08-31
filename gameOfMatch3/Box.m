//
//  Box.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Box.h"
@interface Box()
-(int) repair;
-(int) repairSingleColumn: (int) columnIndex;
@end
@implementation Box
@synthesize layer;
@synthesize size;
@synthesize lock;

-(id) initWithSize: (CGSize) aSize factor: (int) aFactor{
	self = [super init];
	size = aSize;
	OutBorderTile = [[Tile alloc] initWithX:-1 Y:-1];
    OutBorderTile.value=-1;
	content = [NSMutableArray arrayWithCapacity: size.height];
	
	for (int y=0; y<size.height; y++) {
		
		NSMutableArray *rowContent = [NSMutableArray arrayWithCapacity:size.width];
		for (int x=0; x < size.width; x++) {
			Tile *tile = [[Tile alloc] initWithX:x Y:y];
			[rowContent addObject:tile];

		}
		[content addObject:rowContent];

	}
	
	readyToRemoveTiles = [NSMutableSet setWithCapacity:kMaxRecordCount];

	return self;
}

-(Tile *) objectAtX: (int) x Y: (int) y{
	if (x < 0 || x >= kBoxWidth || y < 0 || y >= kBoxHeight) {
		return OutBorderTile;
	}
	return [[content objectAtIndex: y] objectAtIndex: x];
}

-(void) checkWith: (Orientation) orient{
	int iMax = (orient == OrientationHori) ? size.width : size.height;
	int jMax = (orient == OrientationVert) ? size.height : size.width;
	for (int i=0; i<iMax; i++) {
		int count = 0;
		int value = -1;
		first = nil;
		second = nil;
		for (int j=0; j<jMax; j++) {
			Tile *tile = [self objectAtX:((orient == OrientationHori) ?i :j)  Y:((orient == OrientationHori) ?j :i)];
			if(tile.value == value){
				count++;
				if (count > 3) {
					[readyToRemoveTiles addObject:tile];
				}else
					if (count == 3) {
						[readyToRemoveTiles addObject:first];
						[readyToRemoveTiles addObject:second];
						[readyToRemoveTiles addObject:tile];
						first = nil;
						second = nil;
						
					}else if (count == 2) {
						second = tile;
					}else {
						
					}
				
			}else {
				count = 1;
				first = tile;
				second = nil;
				value = tile.value;
			}
		}
	}
}

-(BOOL) check{
	[self checkWith:OrientationHori];
	[self checkWith:OrientationVert];
	
	NSArray *objects = [[readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	
	int count = [objects count];
	for (int i=0; i<count; i++) {
        
		Tile *tile = [objects objectAtIndex:i];
		tile.value = 0;
		if (tile.sprite) {
			CCAction *action = [CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:0.0f],
								[CCCallFuncN actionWithTarget: self selector:@selector(removeSprite:)],
								nil];
			[tile.sprite runAction: action];
		}
	}
    
	[readyToRemoveTiles removeAllObjects];
	int maxCount = [self repair];
	
	[layer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: kMoveTileTime * maxCount + 0.03f],
					   [CCCallFunc actionWithTarget:self selector:@selector(afterAllMoveDone)],
					   nil]];
	return YES;
}

-(void) removeSprite: (id) sender{
	[layer removeChild: sender cleanup:YES];
}

-(void) afterAllMoveDone{
	if([self check]){
		
	}else {
		[self unlock];
	}
    
}

-(void) unlock{
	self.lock = NO;
}

-(int) repair{
	int maxCount = 0;
	for (int x=0; x<size.width; x++) {
		int count = [self repairSingleColumn:x];
		if (count > maxCount) {
			maxCount = count;
		}
	}
	return maxCount;
}

-(int) repairSingleColumn: (int) columnIndex{
	int extension = 0;
	for (int y=0; y<size.height; y++) {
		Tile *tile = [self objectAtX:columnIndex Y:y];
        if(tile.value == 0){
            extension++;
        }else if (extension == 0) {
            
        }else{
            Tile *destTile = [self objectAtX:columnIndex Y:y-extension];
            
            CCSequence *action = [CCSequence actions:
                                  [CCMoveBy actionWithDuration:kMoveTileTime*extension position:ccp(0,-kTileSize*extension)],
                                  nil];
            
            [tile.sprite runAction: action];
            
            destTile.value = tile.value;
            destTile.sprite = tile.sprite;
            
        }
	}
	
	for (int i=0; i<extension; i++) {
		int value = (arc4random()%kKindCount+1);
		Tile *destTile = [self objectAtX:columnIndex Y:kBoxHeight-extension+i];
		NSString *name = [NSString stringWithFormat:@"block_%d.png",value];
        
		CCSprite *sprite = [CCSprite spriteWithFile:name];
        [sprite setScaleX: kTileSize/sprite.contentSize.width];
        [sprite setScaleY: kTileSize/sprite.contentSize.height];
		sprite.position = ccp(kStartX + columnIndex * kTileSize + kTileSize/2, kStartY + (kBoxHeight + i) * kTileSize + kTileSize/2);
		CCSequence *action = [CCSequence actions:
							  [CCMoveBy actionWithDuration:kMoveTileTime*extension position:ccp(0,-kTileSize*extension)],
							  nil];
		[layer addChild: sprite];
		[sprite runAction: action];
		destTile.value = value;
		destTile.sprite = sprite;
	}
	return extension;
}

-(NSMutableArray*) scanMaxLineAtRow:(int) rowIndex{
    NSMutableArray* maxLineArray=[[NSMutableArray alloc]init];
    int start=0;   //扫描最长线
    int value=nil;
    for (int x=0; x<size.width+1; x++) {
        Tile *tile = [self objectAtX:x Y:rowIndex];
        if(value==tile.value){
            
        }else{
            value=tile.value;
            if(x>start){[maxLineArray addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:start],[NSNumber numberWithInt:x],nil]];}
            start=x+1;
        }
    }
    return maxLineArray;
}
-(NSMutableArray*) scanMaxLineAtColumn:(int) columnIndex{
    NSMutableArray* maxLineArray=[[NSMutableArray alloc]init];
    int start=0;   //扫描最长线
    int value=nil;
    for (int x=0; x<size.height+1; x++) {
        Tile *tile = [self objectAtX:columnIndex Y:x];
        if(value==tile.value){
            
        }else{
            value=tile.value;
            if(x>start){[maxLineArray addObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:start],[NSNumber numberWithInt:x],nil]];}
            start=x+1;
        }
    }
    return maxLineArray;
}
-(NSMutableArray*) scanSingleRow: (int) rowIndex{
    Tile *oriTile;
    Tile *destTile;
    Tile *matchTile;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    
    NSMutableArray* maxLineArray=[self scanMaxLineAtRow:rowIndex];
    for(NSArray* range in maxLineArray){
        int start=[range[0] intValue];
        int end=[range[1] intValue];
        matchTile=[self objectAtX:start Y:rowIndex];
        
        destTile=[self objectAtX:start-1 Y:rowIndex];
        oriTile = [self objectAtX:start-1 Y:rowIndex-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:start-1 Y:rowIndex+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:start-2 Y:rowIndex];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        
        destTile=[self objectAtX:end+1 Y:rowIndex];
        oriTile = [self objectAtX:end+1 Y:rowIndex-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:end+1 Y:rowIndex+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:end+2 Y:rowIndex];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
    }
    return ret;

}

-(NSMutableArray*) scanSingleColumn: (int) columnIndex{
    Tile *oriTile;
    Tile *destTile;
    Tile *matchTile;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    
    NSMutableArray* maxLineArray=[self scanMaxLineAtColumn:columnIndex];
    for(NSArray* range in maxLineArray){
        int start=[range[0] intValue];
        int end=[range[1] intValue];
        matchTile=[self objectAtX:columnIndex Y:start];
        
        destTile=[self objectAtX:columnIndex Y:start-1];
        oriTile = [self objectAtX:columnIndex-1 Y:start-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex+1 Y:start-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex Y:start-2];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        
        destTile=[self objectAtX:columnIndex Y:end+1];
        oriTile = [self objectAtX:columnIndex-1 Y:end+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex+1 Y:end+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex Y:end+2];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
    }
    return ret;
    
}


-(NSMutableArray*) scanForMatch{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (int x=0; x<size.height; x++) {
        [ret arrayByAddingObjectsFromArray:[self scanSingleRow:x]];
        
    }
    for (int x=0; x<size.width; x++) {
        [ret arrayByAddingObjectsFromArray:[self scanSingleColumn:x]];
    }
    return ret;
}

-(NSArray*) findMatchedArray:(NSArray*)matchedArray forValue:(int)value{
    for(NSArray* item in matchedArray){
        Tile* destTile=item[1];
        if (destTile.value==value){
            return item;
        }
    }
 
    return nil;
}


@end