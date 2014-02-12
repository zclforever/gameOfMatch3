//
//  Tile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Tile.h"
#import "Magic.h"



@interface Tile()


@property (nonatomic,strong)  CCSpawn* ccSpawn;
@property (nonatomic,strong)  NSMutableArray* cache;
@property bool updating;
@property  bool locking;

@end
@implementation Tile



-(id) initWithX: (int) posX Y: (int) posY delegate:(id<tileDelegate>)tileDelegate{
	self = [super init];
    //debug
    Global* dbg=[Global sharedManager];
    dbg.debugTest++;
    //NSLog(@"init x:%d y:%d",posX,posY);
    
    
    self.tileDelegate=tileDelegate;
    self.sprite=[CCSprite spriteWithFile:self.tileDelegate.tileSpriteName];
    
    //init checkMark;
//    CCSprite* checkedSprite;
//    checkedSprite=[CCSprite spriteWithFile:@"checkMark_White.png"];
//    checkedSprite.position=[tile pixPosition];
//    checkedSprite.visible=NO;
//    [self.checkMarkSpriteArray addObject:checkedSprite];
//    [self addChild:checkedSprite z:8];
    
//    //checkMark
//    int index=tile.y*size.width+tile.x;
//    CCSprite* checkedSprite=self.checkMarkSpriteArray[index];
//    if (tile.selected) {
//        checkedSprite.visible=YES;
//    }else{
//        checkedSprite.visible=NO;
//    }
    
	self.x = posX;
	self.y = posY;
    
    self.actionSequence=[[NSMutableArray alloc]init];
    self.cache=[[NSMutableArray alloc]init];
    self.isActionDone=YES;
    self.updating=NO;
    self.ccSequnce2=nil;
    self.readyToEnd=NO;
    self.skillBall=0;
    
    self.selected=NO;
    self.tradeTile=NO;
    [self update];

    
    //[[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(update) forTarget:self interval:0.1 repeat:kCCRepeatForever delay:0 paused:NO] ;
	return self;
}
-(void)onExit{
    [super onExit];
    Global* dbg=[Global sharedManager];
    dbg.debugTest--;
    
    self.sprite=nil;
    self.actionSequence=nil;
    self.ccSequnce=nil;
    self.ccSequnce2=nil;
    self.ccSpawn=nil;
    self.cache=nil;

//    NSLog(@"exit x:%d y:%d",x,y);
    
}

-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
    //[self schedule:@selector(update:) interval:timeOut];
    //[self scheduleOnce:@selector(update:) delay:timeOut];
//    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(update) forTarget:self];
//    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(update) forTarget:self interval:timeOut repeat:kCCRepeatForever delay:timeOut paused:NO] ;

    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:@selector(update)],
      
      nil]];
    
}
-(CCAction *)disappareAction{
    __block Tile* obj=self;
    CCAction *disappearAction = [CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:0.0f],
                                 [CCCallBlockN actionWithBlock:^(CCNode* node){
        [obj scaleToNone];
        [node removeFromParentAndCleanup:YES];
    }],
                                 nil];
    return disappearAction;
}
-(CCAction *)appareActionWithDelay:(float)delay{
    CCAction *action = [CCSequence actions:
                        [CCDelayTime actionWithDuration:delay],
                        [CCScaleTo actionWithDuration:0.3f scaleX:kTileSize/self.sprite.contentSize.width scaleY:kTileSize/self.sprite.contentSize.height],
                                 [CCCallBlockN actionWithBlock:^(CCNode* node){
        [self scaleToTileSize];
    }],
                                 nil];
    return action;
}
-(void)update{
    float updateDelay=0.1;
    
    
    if(self.locking){[self setTimeOutOfUpdateWithDelay:updateDelay];return;};
    if(self.updating){[self setTimeOutOfUpdateWithDelay:updateDelay];return;};
    if(self.actionSequence.count==0&& self.readyToEnd){
//        [self lock];
//        CCAction *disappearAction = [self disappareAction];
//       
//        [sprite stopAllActions];
//        while(sprite.numberOfRunningActions>0){        [sprite stopAllActions];};
//        [sprite runAction:disappearAction];
      //[self setTimeOutOfUpdateWithDelay:updateDelay];
          
          
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [node removeAllChildrenWithCleanup:YES];
            }],
          
          nil]];
        return;
      
      
      
    }
    int count=self.actionSequence.count;

   if (count==0||!self.sprite) {
        {[self setTimeOutOfUpdateWithDelay:updateDelay];return;};
    }
    //if(self.sprite.numberOfRunningActions>0){return;}
    if(!self.isActionDone){[self setTimeOutOfUpdateWithDelay:updateDelay];return;};


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
    {[self setTimeOutOfUpdateWithDelay:updateDelay];return;};
}
-(void)scaleToNone{
    [self.sprite setScaleX: 0];
    [self.sprite setScaleY: 0];
}
-(void)scaleToTileSize{
    [self.sprite setScaleX: kTileSize/self.sprite.contentSize.width];
    [self.sprite setScaleY: kTileSize/self.sprite.contentSize.height];
}
-(BOOL) nearTile: (Tile *)othertile{
	return
	(self.x == othertile.x && abs(self.y - othertile.y)==1)
	||
	(self.y == othertile.y && abs(self.x - othertile.x)==1);
}

-(void) trade: (Tile *)otherTile{
//	CCSprite *tempSprite = sprite;
//	self.sprite = otherTile.sprite;
//   	otherTile.sprite = tempSprite;

//	int tempValue = value;
//	self.value = otherTile.value;
//	otherTile.value = tempValue;
    
	int tmpX = otherTile.x;
	otherTile.x= self.x ;
    self.x=tmpX;
    
	int tmpY = otherTile.y;
	otherTile.y= self.y ;
    self.y=tmpY;

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
    Tile* tmpTile=[[Tile alloc]initWithX:self.x Y:self.y delegate:self.tileDelegate];
    tmpTile.value=self.value;
    NSString *name = [NSString stringWithFormat:@"block_%d.png",self.value];
    tmpTile.sprite=[CCSprite spriteWithFile:name];
    return tmpTile;
}
-(CGPoint) pixPosition{
    float kStartX=[[Global sharedManager] kStartX];
    float kStartY=[[Global sharedManager] kStartY];
	return ccp(kStartX + self.x * kTileSize +kTileSize/2.0f,kStartY + self.y * kTileSize +kTileSize/2.0f);
}
@end




