//
//  Box.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Box.h"
#import "SimpleAudioEngine.h"
@interface Box()
-(int) repair;
-(int) repairSingleColumn: (int) columnIndex;
@property (nonatomic,strong) NSMutableArray* checkMarkSpriteArray;
@property NSMutableArray* columnExtension;
@end
@implementation Box

@synthesize size;
@synthesize lock;
@synthesize allMoveDone;
@synthesize readyToRemoveTiles;
@synthesize columnExtension=_columnExtension;

-(id) initWithSize: (CGSize) aSize factor: (int) aFactor{
    
	self = [super init];
	size = aSize;
	self.OutBorderTile = [[Tile alloc] initWithX:-1 Y:-1];
    self.OutBorderTile.value=-1;
    [self addChild:self.OutBorderTile];
	self.content = [NSMutableArray arrayWithCapacity: size.height];
	self.checkMarkSpriteArray=[NSMutableArray arrayWithCapacity:size.height*size.width];
    
	for (int y=0; y<size.height; y++) {
		
		NSMutableArray *rowContent = [NSMutableArray arrayWithCapacity:size.width];
		for (int x=0; x < size.width; x++) {
			Tile *tile = [[Tile alloc] initWithX:x Y:y];
            [self addChild:tile];
			[rowContent addObject:tile];
            
            //init checkMark;
            CCSprite* checkedSprite;
            checkedSprite=[CCSprite spriteWithFile:@"checkMark_White.png"];
            checkedSprite.position=[tile pixPosition];
            checkedSprite.visible=NO;
            [self.checkMarkSpriteArray addObject:checkedSprite];
            [self addChild:checkedSprite z:8];

		}
		[self.content addObject:rowContent];

	}
	
	self.readyToRemoveTiles = [NSMutableSet setWithCapacity:kMaxRecordCount];
    self.columnExtension=[[NSMutableArray alloc]init];
    for (int i=0; i<kBoxWidth; i++) {
        [self.columnExtension addObject:[NSMutableArray arrayWithObjects:@0,@0,nil]];
    }
    
    self.removeResultArray=[[NSMutableArray alloc]init];
    
    self.isSoundEnabled=NO;
	return self;
}
-(void)onExit{
    [super onExit];
    
    [self removeAllChildrenWithCleanup:YES];
    self.lockedEnemy=nil;
    self.lockedPlayer=nil;
    self.OutBorderTile=nil;
    self.readyToRemoveTiles=nil;
    self.removeResultArray=nil;
    self.columnExtension=nil;
    self.checkMarkSpriteArray=nil;
    first=nil;
    second=nil;
    self.content=nil;

}
-(void) swapWithTile:(Tile*)a B:(Tile*)b{
    [a lock];
    [b lock];
    [self setObjectAtX:a.x Y:a.y withTile:b];
    [self setObjectAtX:b.x Y:b.y withTile:a];
    [a trade:b];
    [b unlock];
    [a unlock];
    //[self unlock];
}
-(Tile *) objectAtX: (int) x Y: (int) y{
	if (x < 0 || x >= kBoxWidth || y < 0 || y >= kBoxHeight) {
		return self.OutBorderTile;
	}
	return [[self.content objectAtIndex: y] objectAtIndex: x];
}
-(void) setObjectAtX: (int) x Y: (int) y withTile:(Tile*)tile{
	if (x < 0 || x >= kBoxWidth || y < 0 || y >= kBoxHeight) {
		return ;
	}
    self.content[y][x]=tile;
}
-(Tile *) objectAtX: (int) x Y: (int) y withSwapA:(Tile*)A B:(Tile*)B{
	if (x < 0 || x >= kBoxWidth || y < 0 || y >= kBoxHeight) {
		return self.OutBorderTile;
	}
    if(A&&B){
        if(A.x==x&&A.y==y){
            return B;
        }
        if(B.x==x&&B.y==y){
            return A;
        }
    }
	return [[self.content objectAtIndex: y] objectAtIndex: x];
}
-(void) checkWith: (Orientation) orient{
    NSMutableArray* tmpRemoveArray;;
    //[self.removeResultArray removeAllObjects];

	int iMax = (orient == OrientationHori) ? size.width : size.height;
	int jMax = (orient == OrientationVert) ? size.height : size.width;
	for (int i=0; i<iMax; i++) {
		int count = 0;
		int value = -1;
		first = nil;
		second = nil;
        bool readToAddResultArray=NO;
        tmpRemoveArray=nil;
        
		for (int j=0; j<jMax; j++) {
			Tile *tile = [self objectAtX:((orient == OrientationHori) ?i :j)  Y:((orient == OrientationHori) ?j :i)];
            //checkMark
            int index=tile.y*size.width+tile.x;
            CCSprite* checkedSprite=self.checkMarkSpriteArray[index];
            if (tile.selected) {
                checkedSprite.visible=YES;
            }else{
                checkedSprite.visible=NO;
            }
            
            
            if(tile.skillBall){
             value=arc4random();
            }
            
            if(tile.value == value){
                if(value>0){
                    [tmpRemoveArray addObject:tile];
                }
				count++;
				if (count > 3) {
					[self.readyToRemoveTiles addObject:tile];
                    [tmpRemoveArray addObject:tile];
				}else
					if (count == 3) {
						[self.readyToRemoveTiles addObject:first];
						[self.readyToRemoveTiles addObject:second];
						[self.readyToRemoveTiles addObject:tile];
                        tmpRemoveArray=[NSMutableArray arrayWithObjects:first,second,tile, nil];
  						first = nil;
						second = nil;
                        //if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"zizizi.m4a"];
                        //[[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
						
					}else if (count == 2) {
						second = tile;
					}else {
						
					}
				
			}else {
                if (tmpRemoveArray) {
                    [self.removeResultArray addObject:tmpRemoveArray];
                }
                tmpRemoveArray=nil;
				count = 1;
				first = tile;
				second = nil;
				value = tile.value;
			}

            
		} //end for
        if(tmpRemoveArray){
            [self.removeResultArray addObject:tmpRemoveArray];
        }
	}//end for
}
-(BOOL)removeAndRepair{
    for(NSMutableArray* removeArray in self.removeResultArray){
        Tile* firstTile=removeArray[0];
        Tile* secondTile=removeArray[1];
        Tile* tile=[removeArray lastObject];
        if(firstTile.x==secondTile.x){
            tile=removeArray[0];
        }
        if(tile.value==5&&self.lockedEnemy){  //剑的话
            
            CGPoint pos=self.lockedEnemy.position;
            for (int i=0; i<removeArray.count; i++) {
                tile=removeArray[i];
                CCAction* moveAction=[CCMoveTo actionWithDuration:.4 position:pos];
                [tile.actionSequence addObject:moveAction];
            }
            continue;
        }
        if(tile.value==7&&self.lockedPlayer){  //医药箱的话
            
            CGPoint pos=self.lockedPlayer.position;
            for (int i=0; i<removeArray.count; i++) {
                tile=removeArray[i];
                CCAction* moveAction=[CCMoveTo actionWithDuration:.4 position:ccp(pos.x+zPersonWidth,pos.y)];
                [tile.actionSequence addObject:moveAction];
            }
            continue;
        }
        
        if(tile.value<=0||tile.value>4)continue;
        
        [removeArray removeObject:tile];
        //[self.readyToRemoveTiles removeObject:tile];
        //[tile.actionSequence addObject:tile.disappareAction]; //统一消失
        //[tile scaleToNone];
        
        CGPoint pos=[tile pixPosition];
        
        Tile *destTile = [[Tile alloc]initWithX:tile.x Y:tile.y];
        [self addChild:destTile];
        [self setObjectAtX:tile.x Y:tile.y withTile:destTile];
        CCSprite* sprite;
        destTile.value+=tile.value+100;
        sprite=[CCSprite spriteWithFile:[NSString stringWithFormat:@"block_%d.png",destTile.value]];
        destTile.skillBall=3*(removeArray.count-1);
        sprite.position=pos;
        sprite.scale=0;
        destTile.sprite=sprite;
        [self addChild:destTile.sprite];
        [destTile.actionSequence addObject:[destTile appareAction]];
        for (int i=0; i<removeArray.count; i++) {
            tile=removeArray[i];
            CCAction* moveAction=[CCMoveTo actionWithDuration:kMoveTileTime position:pos];
            [tile.actionSequence addObject:moveAction];
        }
        

        
        
    }
    
    
  	NSArray *objects = [[self.readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}
	allMoveDone=NO;
	int count = [objects count];
	for (int i=0; i<count; i++) {
        
		Tile *tile = [objects objectAtIndex:i];
        tile.selected=NO;
		tile.value = 0;
		if (tile.sprite) {
			[tile.actionSequence addObject:[tile disappareAction]];
            //tile.readyToEnd=YES;
		}
        [self.readyToRemoveTiles removeObject:tile];
         
	}


         [self repair];

        //[self.readyToRemoveTiles removeAllObjects];
        
        
//        [layer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: kMoveTileTime * maxCount + 0.03f],
//                           [CCCallFunc actionWithTarget:self selector:@selector(afterAllMoveDone)],
//                           nil]];

	return YES;
}

-(BOOL) check{
    
	[self checkWith:OrientationHori];
	[self checkWith:OrientationVert];
  	NSArray *objects = [[self.readyToRemoveTiles objectEnumerator] allObjects];
	if ([objects count] == 0) {
		return NO;
	}else{return YES;}
}

-(void) removeSprite: (id) sender{
	[self removeChild: sender cleanup:YES];
}

-(void) afterAllMoveDone{
    [self unlock];
    allMoveDone=YES;
    return;
	if([self check]){
		[self removeAndRepair];
	}else {
		[self unlock];
        allMoveDone=YES;
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
    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	int extension = 0;
    Tile* topTile;
	for (int y=0; y<size.height; y++) {
		Tile *tile = [self objectAtX:columnIndex Y:y];
        if (!topTile) {
            topTile=tile;
        }else{
            if (topTile.sprite.position.y<tile.sprite.position.y) {
                topTile=tile;
            }
        }
        
        if(tile.value == 0){
            extension++;
        }else if (extension == 0) {
            
        }else{
    
            
            Tile *destTile = [self objectAtX:columnIndex Y:y-extension];
            //[self setObjectAtX:columnIndex Y:y-extension withTile:tile];
            CGPoint pos=[tile pixPosition];
            [self swapWithTile:tile B:destTile];
            CCSequence *action = [CCSequence actions:
                                  //[CCMoveBy actionWithDuration:kMoveTileTime*extension position:ccp(0,-kTileSize*extension)],
                                  [CCMoveTo actionWithDuration:kMoveTileTime*extension position:ccp(pos.x,pos.y-kTileSize*extension)],
                                  nil];
            
            //[tile.sprite runAction: action];
            
//            destTile.value = tile.value;
//            destTile.sprite = tile.sprite;
            [tile.actionSequence addObject:action];
            
        }
	}
    

  
	for (int i=0; i<extension; i++) {
		int value = (arc4random()%kKindCount+1);
        Tile *sourceTile =[self objectAtX:columnIndex Y:kBoxHeight-extension+i];
        [sourceTile disappareAction];
        
        
        Tile *destTile = [[Tile alloc]initWithX:columnIndex Y:kBoxHeight-extension+i];
       
        [self addChild:destTile];
        [self setObjectAtX:columnIndex Y:kBoxHeight-extension+i withTile:destTile];
		NSString *name = [NSString stringWithFormat:@"block_%d.png",value];
        
		CCSprite *sprite = [CCSprite spriteWithFile:name];
        [sprite setScaleX: kTileSize/sprite.contentSize.width];
        [sprite setScaleY: kTileSize/sprite.contentSize.height];
        CGPoint topPoint=[self getLocalPosition:topTile.sprite.position];
        int topY=MAX(topPoint.y+1, kBoxHeight);
        
		sprite.position = ccp(kStartX + columnIndex * kTileSize + kTileSize/2, kStartY + (topY + i) * kTileSize + kTileSize/2);
        float moveTime=ccpDistance(sprite.position, destTile.pixPosition)/(kTileSize/kMoveTileTime);
        if(moveTime>4.0f){
            NSLog(@"%f",moveTime);
            moveTime=2;
        }
		CCSequence *action = [CCSequence actions:
                              //[CCMoveBy actionWithDuration:kMoveTileTime*extension position:ccp(0,-kTileSize*extension)],
							  [CCMoveTo actionWithDuration:moveTime position:[destTile pixPosition]],
							  nil];
		//action=[CCEaseInOut actionWithAction:action rate:2];
        [destTile addChild: sprite];
		//[sprite runAction: action];
		destTile.value = value;
		destTile.sprite = sprite;
        [destTile.actionSequence addObject:action];
	}
    
	return extension;
}

-(void) addColumnExtensionAtIndex:(int)index withValue:(int)value{
    int tmp=[_columnExtension[index][0] intValue];
    if(tmp+value<0){
        NSLog(@"warnning:addColumnExtension value<0");
    }
    _columnExtension[index][0]=[NSNumber numberWithInt:tmp+value];
}

-(bool) hasMatchAtRow: (int) rowIndex withSwap:(Tile*)A B:(Tile*)B{
    int y=rowIndex;
    if(y<0||y>=size.height)return nil;
    int value=nil;
    int count=1;
    for (int x=0; x<size.width; x++) {
        Tile *tile = [self objectAtX:x Y:rowIndex withSwapA:A B:B];
        
        if(tile.skillBall){value=arc4random();}
        
        if(value==tile.value){
            count++;
        }else{
            value=tile.value;
            count=1;
        }
        if (count>=3) {
            return YES;
        }

    }
    return NO;
}
-(bool) hasMatchAtRow: (int) rowIndex{
    return [self hasMatchAtRow:rowIndex withSwap:nil B:nil];
}
-(bool) hasMatchAtColumn: (int) columnIndex withSwap:(Tile*)A B:(Tile*)B{
    int x=columnIndex;
    if(x<0||x>=size.width)return nil;
    int value=nil;
    int count=1;
    for (int x=0; x<size.height; x++) {
        Tile *tile = [self objectAtX:columnIndex Y:x withSwapA:A B:B];
        
        if(tile.skillBall){value=arc4random();}
        
        if(value==tile.value){
            count++;
        }else{
            value=tile.value;
            count=1;
        }
        if (count>=3) {
            return YES;
        }
        
    }
    return NO;
}
-(bool) hasMatchAtColumn: (int) columnIndex{
    return [self hasMatchAtColumn:columnIndex withSwap:nil B:nil];
}
-(NSMutableArray*) findMatchAtColumnIndex: (int) columnIndex{
    return [self findMatchAtColumnIndex:columnIndex withSwap:nil B:nil];
}
-(NSMutableArray*) findMatchAtColumnIndex: (int) columnIndex withSwap:(Tile*)A B:(Tile*)B{
    int x=columnIndex;
    if(x<0||x>=size.width)return nil;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    NSMutableArray* tmp=[[NSMutableArray alloc]init];
    int value=nil;
    int count=1;
    for (int x=0; x<size.height; x++) {
        Tile *tile = [self objectAtX:columnIndex Y:x withSwapA:A B:B];
        
        if(tile.skillBall){value=arc4random();}
        
        if(value==tile.value){
            count++;
        }else{
            value=tile.value;
            count=1;
            [tmp removeAllObjects];
        }
        [tmp addObject:tile];
        if (count>=3) {
            [ret addObjectsFromArray:tmp];
            [tmp removeAllObjects];
        }
        
    }
    if(ret.count==0) return nil;
    return ret;
}
-(NSMutableArray*) findMatchAtRowIndex:(int)rowIndex{
    return [self findMatchAtRowIndex:rowIndex withSwap:nil B:nil];
}
-(NSMutableArray*) findMatchAtRowIndex:(int)rowIndex withSwap:(Tile*)A B:(Tile*)B{
    int y=rowIndex;
    if(y<0||y>=size.height)return nil;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    NSMutableArray* tmp=[[NSMutableArray alloc]init];
    int value=nil;
    int count=1;
    for (int x=0; x<size.width; x++) {
        Tile *tile = [self objectAtX:x Y:rowIndex withSwapA:A B:B];
        
        if(tile.skillBall){value=arc4random();}
        
        if(value==tile.value){
            count++;
        }else{
            value=tile.value;
            count=1;
            [tmp removeAllObjects];
        }
        [tmp addObject:tile];
        if (count>=3) {
            [ret addObjectsFromArray:tmp];
            [tmp removeAllObjects];
        }
        
    }
    if(ret.count==0) return nil;
    return ret;
}
-(NSMutableArray*) findSwapMatchAtRowIndex: (int) y{ //交换后是否有ＭＡＴＣＨ 实际不交换
    if(y<0||y>=size.height)return nil;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (int x=0; x<size.width-1; x++) {
        Tile* oriTile=[self objectAtX:x Y:y];
        Tile* destTile=[self objectAtX:x+1 Y:y];
        //[oriTile trade:destTile];
        bool matched=[self hasMatchAtRow:y withSwap:oriTile B:destTile]|[self hasMatchAtColumn:x withSwap:oriTile B:destTile] |[self hasMatchAtColumn:x+1 withSwap:oriTile B:destTile] ;
        //[oriTile trade:destTile];
        if(matched){
            {[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        }

    }
    return ret;
}
-(NSMutableArray*) findSwapMatchAtColumnIndex: (int) x{ //交换后是否有ＭＡＴＣＨ 实际不交换
    if(x<0||x>=size.width)return nil;
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (int y=0; y<size.height-1; y++) {
        Tile* oriTile=[self objectAtX:x Y:y];
        Tile* destTile=[self objectAtX:x Y:y+1];
        //[oriTile trade:destTile];
        bool matched=[self hasMatchAtColumn:x withSwap:oriTile B:destTile]|[self hasMatchAtRow:y withSwap:oriTile B:destTile]|[self hasMatchAtRow:y+1 withSwap:oriTile B:destTile];
        //[oriTile trade:destTile];
        if(matched){
            {[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        }
        
    }
    return ret;
}
-(NSMutableArray*) findMatchWithSwap:(Tile*)A B:(Tile*)B{ //return normalArray
    //if(A.value>100||B.value>100){return nil;}
    
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    [ret addObjectsFromArray:[self findMatchAtColumnIndex:A.x withSwap:A B:B]];
    [ret addObjectsFromArray:[self findMatchAtColumnIndex:B.x withSwap:A B:B]];
    [ret addObjectsFromArray:[self findMatchAtRowIndex:A.y withSwap:A B:B]];
    [ret addObjectsFromArray:[self findMatchAtRowIndex:B.y withSwap:A B:B]];
    if(ret.count==0){return nil;}
    return ret;
}
-(NSMutableArray*) scanSwapMatch{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (int y=0; y<size.height; y++) {
        
        [ret addObjectsFromArray:[self findSwapMatchAtRowIndex:y]];
        
    }
    for (int x=0; x<size.width; x++) {
        [ret addObjectsFromArray:[self findSwapMatchAtColumnIndex:x]];
    }
    return ret;
}
-(NSArray*) findMatchedArray:(NSArray*)matchedArray forValue:(int)value{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for(Tile* tile in matchedArray){
        if (tile.value==value){
            [ret addObject:tile];
        }
    }
    if(ret.count==0) return nil;
    return ret;
}
-(NSArray*) findMatchedSwapArray:(NSArray*)matchedArray forValue:(int)value{
    for(NSArray* item in matchedArray){
        Tile* destTile=item[1];
        if (destTile.value==value){
            return item;
        }
    }
    
    return nil;
}

-(CGPoint) getLocalPosition:(CGPoint) location{
    CGPoint ret;
    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	ret.x = (location.x -kStartX) / kTileSize;
	ret.y = (location.y -kStartY) / kTileSize;
    return ret;
}

-(int) pushTilesToRemoveForValue:(int)value{
    int count=0;
	for (int x=0; x<self.size.width; x++) {
        for (int y=0; y<self.size.height; y++) {
            Tile* tile=[self objectAtX:x Y:y];
            if(tile.value==value){
                [self.readyToRemoveTiles addObject:tile];count++;
            }
		}
	}
    return count;
}
/*
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
        if(destTile.value==-1)continue;
        oriTile = [self objectAtX:start-1 Y:rowIndex-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:start-1 Y:rowIndex+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:start-2 Y:rowIndex];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        
        destTile=[self objectAtX:end+1 Y:rowIndex];
        if(destTile.value==-1)continue;
        oriTile = [self objectAtX:end+1 Y:rowIndex-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:end+1 Y:rowIndex+1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:end+2 Y:rowIndex];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
    }
    return ret;

}
 */
/*
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
        if(destTile.value==-1)continue;
        oriTile = [self objectAtX:columnIndex-1 Y:start-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex+1 Y:start-1];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        oriTile = [self objectAtX:columnIndex Y:start-2];
        if(destTile.value==oriTile.value){[ret addObject:[NSArray arrayWithObjects:oriTile,destTile, nil]];}
        
        destTile=[self objectAtX:columnIndex Y:end+1];
        if(destTile.value==-1)continue;
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

*/

@end