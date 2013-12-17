//
//  SmallEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "SmallEnemy.h"

@interface SmallEnemy()


@end


@implementation SmallEnemy

-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray;
{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        
        self.objectName=@"smallEnemy";
        self.readyToEnd=NO;
        self.alive=YES;
        self.atDest=NO;
        self.startMove=NO;
        
        self.sprite=[CCSprite spriteWithFile:@"skeleton_left.png"];
        self.sprite.anchorPoint=ccp(0,0);
        self.sprite.scale=2.0f;
        self.sprite.visible=NO;
        [self addChild:self.sprite];
        
        self.damage=1.0;
        self.attackCD=2.0f;
        self.moveSpeed=14.0f;

        //self.spriteEntity=self;
        [self update];
        
        
    }
    return self;
}
//-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
//    [self runAction:
//     [CCSequence actions:
//      [CCDelayTime actionWithDuration:timeOut],
//      [CCCallFunc actionWithTarget:self selector:@selector(update)],
//      nil]];
//    
//}
//-(CGRect)getBoundingBox{
//    if (self.sprite) {
//        return self.sprite.boundingBox;
//    }else{
//        return CGRectZero;
//    }
//    
//}
-(void)appearAtX:(int)x Y:(int)y{
    self.sprite.position=ccp(x,y);
   
    self.sprite.visible=YES;
    self.startMove=YES;
        
}
-(void)dieAction{
    int x=100+arc4random()%400;
    int y=self.sprite.position.y+30+arc4random()%500;
    if (arc4random()%2==1) {
        y=-(arc4random()%300);
    }
    
    
    [self.sprite runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:.5 position:ccp(x,y)],
                           
                           [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                [node removeFromParentAndCleanup:YES];
                            }],
                           
                           nil]];
    
    self.readyToEnd=YES;
}
-(void)handleCollision{
    for (int i=0; i<self.collisionObjectArray.count; i++) {
        AiObject* obj=self.collisionObjectArray[i];
        if([[obj objectName] isEqualToString:@"player"]&&!self.isAttacking){
            self.isAttacking=YES;
            [self setTimeOutWithDelay:self.attackCD withSelector:@selector(nomalAttack)];
        }
    }

}
-(void)hurtByObject:(AiObject *)obj{
    if ([obj.objectName isEqualToString:@"fireBall"]) {
        self.curHP-=6;
    }
    
}
-(void)nomalAttack{
    if(self.collisionObjectArray.count>0){
        
        AiObject* obj=self.collisionObjectArray[0];
        [obj hurtByObject:self];
        self.isAttacking=NO;
    }

}

-(void)update{
    float delayTime=0.04;
    
    //--------------结束标志----------------------
    if (self.readyToEnd) {
        return;
    }
    
    //-------------是否还活着--------------
    
    if (self.startMove) {
        if (self.curHP<=0) {
            self.alive=NO;
            [self dieAction];
        }
    }
    
    
    //---------------是否开始移动 且未到目的地---------------------
    float moveSpeed=self.moveSpeed;
    if (self.startMove&&!self.atDest) {
        CGPoint pos=self.sprite.position;
        if (pos.x>self.destPos.x) {   //没有到达目的地
            self.sprite.position=ccp(pos.x-moveSpeed*delayTime,pos.y);
        }else{
            self.atDest=YES;
        }
       
    }
    


    [self setTimeOutOfUpdateWithDelay:delayTime];
}

@end
