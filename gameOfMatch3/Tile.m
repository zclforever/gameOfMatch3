//
//  Tile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Tile.h"
@interface Tile()


@property (nonatomic,strong)  CCSpawn* ccSpawn;
@property (nonatomic,strong)  NSMutableArray* cache;
@property bool updating;
@property  bool locking;
@end
@implementation Tile

@synthesize x, y, value, sprite;

-(id) initWithX: (int) posX Y: (int) posY{
	self = [super init];
	x = posX;
	y = posY;
    
    self.actionSequence=[[NSMutableArray alloc]init];
    self.cache=[[NSMutableArray alloc]init];
    self.isActionDone=YES;
    self.updating=NO;
    self.ccSequnce2=nil;
    self.readyToEnd=NO;
    //[self update];

    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(update) forTarget:self interval:0.1 repeat:kCCRepeatForever delay:0 paused:NO] ;
	return self;
}


-(void)update{
    if(self.locking)return;
    if(self.updating)return;
    if(self.readyToEnd){
        [self lock];
        CCAction *disappearAction = [CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:0.0f],
                            [CCCallBlockN actionWithBlock:^(CCNode* node){
                                    [self scaleToNone];
                                    [node removeFromParentAndCleanup:YES];
                                    }],
                            nil];
        
        [sprite stopAllActions];
        while(sprite.numberOfRunningActions>0){        [sprite stopAllActions];};
        [sprite runAction:disappearAction];
      return;  
    }
    int count=self.actionSequence.count;

   if (count==0||!sprite) {
        return;
    }
    //if(self.sprite.numberOfRunningActions>0){return;}
    if(!self.isActionDone)return;


    self.isActionDone=NO;
    self.updating=YES;
    self.ccSequnce=nil;
    [self.cache removeAllObjects];
    int removeCount=count-zTileMaxAction;
    for(int i=0;i<count;i++){
        
        if(removeCount>0){
            [self.actionSequence removeObjectAtIndex:0];
            removeCount--;
            continue;
        }
        
        CCFiniteTimeAction* action=self.actionSequence[0];

        if (!self.ccSequnce) {
            self.ccSequnce=[CCSequence actions:action, nil];
        }else{
            self.ccSequnce=[CCSequence actionOne:self.ccSequnce two:action];
        }
        [self.actionSequence removeObjectAtIndex:0];
    
        
    }

    
    CCFiniteTimeAction* actionEnd=[CCCallBlock actionWithBlock:^{
        //NSLog(@"tile update in block");
        self.ccSequnce=nil;
        self.isActionDone=YES;
    }];
    
    self.ccSequnce=[CCSequence actionOne:self.ccSequnce two:actionEnd];
    [self.sprite runAction:self.ccSequnce];

    self.updating=NO;
}
-(void)scaleToNone{
    [sprite setScaleX: 0];
    [sprite setScaleY: 0];
}
-(void)scaleToTileSize{
    [sprite setScaleX: kTileSize/sprite.contentSize.width];
    [sprite setScaleY: kTileSize/sprite.contentSize.height];
}
-(BOOL) nearTile: (Tile *)othertile{
	return
	(x == othertile.x && abs(y - othertile.y)==1)
	||
	(y == othertile.y && abs(x - othertile.x)==1);
}

-(void) trade: (Tile *)otherTile{
//	CCSprite *tempSprite = sprite;
//	self.sprite = otherTile.sprite;
//   	otherTile.sprite = tempSprite;

//	int tempValue = value;
//	self.value = otherTile.value;
//	otherTile.value = tempValue;
    
	int tmpX = otherTile.x;
	otherTile.x= x ;
    x=tmpX;
    
	int tmpY = otherTile.y;
	otherTile.y= y ;
    y=tmpY;

}
-(void)lock{
    while(self.updating){
    };
    self.locking=YES;
}
-(void)unlock{
    while(self.updating){};
    self.locking=NO;
}
-(Tile*)copyTile{
    Tile* tmpTile=[[Tile alloc]initWithX:x Y:y];
    tmpTile.value=value;
    NSString *name = [NSString stringWithFormat:@"block_%d.png",value];
    tmpTile.sprite=[CCSprite spriteWithFile:name];
    return tmpTile;
}
-(CGPoint) pixPosition{
    float kStartX=[[consts sharedManager] kStartX];
    float kStartY=[[consts sharedManager] kStartY];
	return ccp(kStartX + x * kTileSize +kTileSize/2.0f,kStartY + y * kTileSize +kTileSize/2.0f);
}
@end
