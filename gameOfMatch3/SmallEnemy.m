//
//  SmallEnemy.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-14.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "SmallEnemy.h"

@interface SmallEnemy()
@property int animatingTag;
@property (weak,nonatomic) AiObject* attackTarget;
@end


@implementation SmallEnemy



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withType:(NSString*)type;
{
    self = [super initWithAllObjectArray:allObjectsArray];
    if (self) {
        //self.showBoundingBox=YES;
        
        self.objectName=[NSString stringWithFormat:@"smallEnemy_%@",type];
        self.readyToEnd=NO;
        self.alive=YES;
        self.atDest=NO;
        self.startMove=NO;
        
        //初始化属性
        self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
        
        
        self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
        self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
        self.attackCD=[[self.attributeDict valueForKey:@"attackCD"] floatValue];
        self.moveSpeed=[[self.attributeDict valueForKey:@"moveSpeed"] floatValue];
        self.maxHP=[[self.attributeDict valueForKey:@"maxHP"] floatValue];
        self.curHP=self.maxHP;
        
        float scale=[[self.attributeDict valueForKey:@"spriteScale"] floatValue];
        
        self.sprite=[CCSprite spriteWithFile:@"transparent.png"];
        self.sprite.anchorPoint=ccp(0.5,0);
        self.sprite.scale=scale;
        self.sprite.visible=NO;
        [self addChild:self.sprite];
        
        self.node=self.sprite;
        


        //self.spriteEntity=self;
        [self addLifeBar];
        [self update];
        
        
    }
    return self;
}
-(CGRect)getBoundingBox{
    if (!self.sprite) {
        return CGRectZero;
    }
    float width=[[self.attributeDict valueForKey:@"width"] floatValue];
    float height=[[self.attributeDict valueForKey:@"height"] floatValue];
    CGRect rect=self.sprite.boundingBox;
    CGRect ret;
    float x,y;
    if (width==0) width=rect.size.width;
    if (height==0) height=rect.size.height;
    //boundingBox的origin是在左下角！！！ 这里要根据自定义宽度作调整
    x=rect.origin.x+ (rect.size.width-width)/2;
    y=rect.origin.y+ (rect.size.height-height)/2;
    ret=CGRectMake(x, y, width, height);
    return ret;
}
-(void)loadAttributeFromDict{
    
}
-(void)appearAtX:(int)x Y:(int)y{
    self.sprite.position=ccp(x,y);
   
    self.sprite.visible=YES;
    self.startMove=YES;
        
}
-(void)attackTarget:(AiObject *)target{
    self.attackTarget=target;
    
}
-(void)dieAction{
   
    [[SimpleAudioEngine sharedEngine] playEffect:@"boy_ah.wav"];
    
    
    int x=100+arc4random()%400;
    int y=500+arc4random()%100;
    if (arc4random()%2==1) {
        y=-(arc4random()%100);
    }
    float delayTime=1+arc4random()%200/100;
    

    
    self.sprite.anchorPoint=ccp(0.5,0.5);

    
    [self.sprite runAction:[CCSpawn actions:
                                [CCRotateBy actionWithDuration:delayTime angle:4145],

                                [CCScaleTo actionWithDuration:delayTime scale:1+delayTime*3],
                                [CCSequence actions:
                                                [CCMoveTo actionWithDuration:delayTime position:ccp(x,y)],
                                                //[CCDelayTime actionWithDuration:0.2f],
                                                [CCCallBlockN actionWithBlock:^(CCNode *node) {
                                                [node stopAllActions];
                                                [node removeFromParentAndCleanup:YES];
                                                }],
                                                
                                                nil],
                            
                            nil]];
    
    self.readyToEnd=YES;
}
-(void)handleCollision{
    if (!self.alive) {
        //[self removeFromParentAndCleanup:YES];
        return;
    }
    for (int i=0; i<self.collisionObjectArray.count; i++) {
        __block AiObject* obj=self.collisionObjectArray[i];
        __block SmallEnemy* selfObj=self;
        if([[obj objectName] isEqualToString:@"player"]&&!self.isAttacking){
            self.isAttacking=YES;
            [self setTimeOutWithDelay:self.attackCD withBlock:^{
                [selfObj normalAttack:obj];
            }];
            
            //攻击动画
            //[self.sprite stopAllActions];
            [self attackAnimation];
        }
    }

}
-(void)hurtByObject:(AiObject *)obj{
    bool needHurt=YES;
    
    if ([obj.objectName isEqualToString:@"snowBall"]) {
        if(!self.state.frozen){
            self.state.frozen=YES;
            [self.sprite stopAllActions];
            self.state.frozenStartTime=[[Global sharedManager] gameTime];
            [self.sprite runAction:[CCTintBy actionWithDuration:1 red:-120 green:-120 blue:0]];
        }
        else{  //如果已经冻结;
            needHurt=NO;
        }

    }
    

    if ([obj.objectName isEqualToString:@"iceBall"]) {
        if(self.moveSpeed>1){
            self.moveSpeed-=1;
            [self.sprite runAction:[CCTintBy actionWithDuration:1 red:-45 green:-45 blue:0]];

        }
            
        self.sprite.position=ccp(self.sprite.position.x+10,self.sprite.position.y);
        
                //[self.sprite runAction:[CCTintTo actionWithDuration:3 red:160 green:160 blue:255]];
    
    }
    
    
   if(needHurt) self.curHP-=obj.damage;
}
-(void)normalAttack:(AiObject*)target{
   
        
        AiObject* obj=target;
        [obj hurtByObject:self];
        self.isAttacking=NO;
    

}
-(void)moveAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=1;
    float delay=[[self.attributeDict valueForKey:@"animationMoveDelay"] floatValue];

    CCAnimation* animation=[self animationByPlist:self.animationMovePlist withDelay:delay];
    CCAction* action=[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    self.animatingTag=1;
    [self.sprite runAction:action ];
    
}
-(void)attackAnimation{
    [self.sprite stopAllActions];
    self.animatingTag=2;

    float delay=[[self.attributeDict valueForKey:@"animationAttackDelay"] floatValue];
    CCAnimation* animation=[self animationByPlist:[self.attributeDict valueForKey:@"animationAttackPlist"] withDelay:delay];

    CCAction* action=[CCAnimate actionWithAnimation:animation];
    [self.sprite runAction:action ];
    
}


-(void)update{
    
    float delayTime=0.04;
   
    
    //--------------结束标志----------------------
    if (self.readyToEnd) {
        if(self.lifeBar){
            [self.lifeBar removeFromParentAndCleanup:YES];
            [self.lifeBarBorder removeFromParentAndCleanup:YES];
        }
        return;
    }
    

    //-------------是否还活着--------------
    
    if (self.startMove) {
        if (self.curHP<=0) {
            self.alive=NO;
            [self.allObjectsArray removeObject:self];
            [self dieAction];
            [self setTimeOutOfUpdateWithDelay:delayTime];
            return;
        }
    }
    if(self.attackTarget){
        CGRect rect=[self.attackTarget getBoundingBox];
        CGPoint centerPos=[self.attackTarget getCenterPoint];
        
        self.destPos=ccp(centerPos.x,rect.origin.y);
        
    }
    
    //---------------是否开始移动 且未到目的地---------------------
    float moveSpeed=self.moveSpeed;
    if (self.startMove&&!self.atDest) {
        
        if(self.state.frozen){
            moveSpeed=0;
            if ([[Global sharedManager] gameTime]-self.state.frozenStartTime>=15.0f) {
                self.state.frozen=NO;
                moveSpeed=self.moveSpeed;
                [self moveAnimation];
                [self.sprite runAction:[[CCTintBy actionWithDuration:1 red:-120 green:-120 blue:0] reverse] ];
            }
        }
        
        if (!self.isAttacking) {
            CGPoint pos=self.sprite.position;
            if (pos.x>self.destPos.x) {   //没有到达目的地
                self.sprite.position=ccp(pos.x-moveSpeed*delayTime,pos.y);
            }else{
                self.atDest=YES;
            }
        }

       
    }
    


    [self setTimeOutOfUpdateWithDelay:delayTime];
}

@end
