//
//  Projectile.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "Projectile.h"
#import "Magic.h"
#import "AiBehavior.h"

@interface Projectile()
@property int count;
@property float speedX;
@property float speedY;


@end

@implementation Projectile
-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withPostion:(CGPoint)pos byName:(NSString*)name{
    self = [super initWithAllObjectArray:allObjectsArray withName:name];
    if (self) {

        
        self.objectName=name;
        [self makeNode];
        self.node.position=pos;
        [self addChild:self.node z:5];
        
        [self.findTargetsDelegate addObserverWithType:@"sightRadius"];
        
        self.attackedObjectsArray=[[NSMutableArray alloc]init];
        self.aiBeharviorsArray=[[NSMutableArray alloc]init];
        
        self.attributeDatabase=[Global searchArray:[[[Global sharedManager]dataBase] skills] whereKey:@"name" isEqualToValue:name][0];
        
        

        self.moveSpeed=[Attribute initWithValue:150.0f];

       
       
        self.accelerometerEnabled = NO;


      
        //self.particle.visible=NO;

        
        if (self.accelerometerEnabled) {
            [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
            [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        }
        
        //[self update];
    }
    return self;
    
}
-(void)makeNode{
    
}

-(void)pushAiBeharvior:(AiBehavior*)aiBeharvior{
    [self.aiBeharviorsArray addObject:aiBeharvior];
}

-(void)initFromPlist{
   
    [super initFromPlist];
    //self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];
}
-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    float THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        CCLOG(@"zcl shake");
        
    }

    self.node.position=ccp(self.node.position.x+acceleration.x*8,self.node.position.y);


}
-(void)start{
    for (AiBehavior* aiBehavior in self.aiBeharviorsArray) {
        [aiBehavior start];
    }
    [super start];
}
-(void)onDirectAttatckTarget:(AiObject*)obj{ //重载 用来做攻击效果 比如冰冻给BUFF
    
}

-(void)directAttackTarget:(AiObject *)obj{



}
-(bool)attackTarget:(AiObject *)obj{
    [self onDirectAttatckTarget:obj];
    
    [obj hurtByObject:self.damageData];
    return YES;
}
-(void)onDie{
    [self dieAction];
}

-(void)dieAction{
    self.alive=NO;
    self.readyToEnd=YES;
    [self.allObjectsArray removeObject:self];
    [self removeFromParentAndCleanup:YES];
}


//delegate
-(void)onEnterFrame{
    for (id<ProjectileAiDelegate> aiBeharvior in self.aiBeharviorsArray) {
        [aiBeharvior onEnterFrame];
    }
}




//-(void)move{  //self.moveDestPosition;
//    if (!self.moving) {
//        return;
//    }
//
//    CGPoint pos=self.moveDestPosition;
//    CGPoint position=self.particle.position;
//    float moveDistanceX=self.speedX*self.delayTime;
//    float moveDistanceY=self.speedY*self.delayTime;
//    float xDistance=pos.x-position.x;
//    float yDistance=pos.y-position.y;
//    float xMoveDistance=xDistance>0?moveDistanceX:-moveDistanceX;
//    float yMoveDistance=yDistance>0?moveDistanceY:-moveDistanceY;
//    
//    if (abs(xDistance)>abs(yDistance)){yMoveDistance/=abs(xDistance/yDistance);}
//    else{ xMoveDistance/=abs(yDistance/xDistance);   }
//
//    self.particle.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
//    
//    float destMinDistance=max(moveDistanceX,3);
//    if(
//       (abs(xDistance)<destMinDistance||self.speedX==0)&&
//       (abs(yDistance)<destMinDistance||self.speedY==0)
//       ){
//        self.atDest=YES;
//    }
//    
//}



@end
