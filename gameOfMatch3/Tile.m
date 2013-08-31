//
//  Tile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Tile.h"
@interface Tile()
@property (nonatomic,strong)  CCSequence* ccSequnce;

@property (nonatomic,strong)  CCSpawn* ccSpawn;
@property (nonatomic,strong)  NSMutableArray* cache;
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
    self.ccSequnce2=nil;
    [self update];

	return self;
}


-(void)update{
    int interval=0.01;
     //NSLog(@"tile update sequence count is %d",1);
    int count=self.actionSequence.count;

   if (count==0||!sprite) {
        [self performSelector:@selector(update) withObject:nil afterDelay:interval];
        return;
    }
//    //if(![self.ccSequnce isDone]){return;}
    if(self.sprite.numberOfRunningActions>0){[self performSelector:@selector(update) withObject:nil afterDelay:interval];return;}
    if(!self.isActionDone){
                //NSLog(@"tile update action running");
        [self performSelector:@selector(update) withObject:nil afterDelay:interval];
        return;
    }
//    //NSLog(@"tile update sequence count is %d",count);
    self.isActionDone=NO;

    [self.cache removeAllObjects];
    for(int i=0;i<count;i++){
        CCFiniteTimeAction* action=self.actionSequence[0];
        if(x==1&&y==1){
            NSLog(@"action added:%@", [action debugDescription]);
        }
        if (!self.ccSequnce) {
            self.ccSequnce=[CCSequence actions:action, nil];
        }else{
            self.ccSequnce=[CCSequence actionOne:self.ccSequnce two:action];
        }
        [self.cache addObject:self.actionSequence[0]];
        [self.actionSequence removeObjectAtIndex:0];
        //[self.sprite runAction:self.cache[0]];

        
        
    }
    CCFiniteTimeAction* actionEnd=[CCCallBlock actionWithBlock:^{
        //NSLog(@"tile update in block");
        self.ccSequnce=nil;
        self.isActionDone=YES;
        [self performSelector:@selector(update) withObject:nil afterDelay:interval];
    }];
    self.ccSequnce=[CCSequence actionOne:self.ccSequnce two:actionEnd];
//    [self.cache addObject:[CCCallBlock actionWithBlock:^{
//        NSLog(@"tile update in block");
//           
//        self.isActionDone=YES;
//         [self performSelector:@selector(update) withObject:nil afterDelay:.1];
//    }]
//     ];
    
//    self.ccSequnce=[CCSequence actionWithArray:self.cache];
//    [self.sprite runAction:self.ccSequnce];
   // [self.actionSequence removeAllObjects];

    //[self.sprite runAction:[CCSequence actionWithArray:self.cache]];
    CCAction* final=[CCSpawn actions:self.ccSequnce,self.ccSequnce2,nil];
    [self.sprite runAction:final];

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

-(CGPoint) pixPosition{
    float kStartX=[[consts sharedManager] kStartX];
    float kStartY=[[consts sharedManager] kStartY];
	return ccp(kStartX + x * kTileSize +kTileSize/2.0f,kStartY + y * kTileSize +kTileSize/2.0f);
}
@end
