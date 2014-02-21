//
//  Item.m
//  gameOfMatch3
//
//  Created by Wei Ju on 14-2-15.
//  Copyright 2014年 Wei Ju. All rights reserved.
//

#import "ItemDelegate.h"


@implementation ItemDelegate
-(id)initWithName:(NSString*)name{
    self = [super init];
    if (self) {
        self.objectName=name;
        self.tileType=@"item";
        [self initFromPlist];

    }
    return self;
}
-(void)initFromPlist{
    self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
    //    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    self.tileSpriteName=[self.attributeDict valueForKey:@"tileSpriteName"];
}
-(NSDictionary*) removeByMount:(int)mount{
    NSDictionary* result=[[NSMutableDictionary alloc] init];
    [result setValue:nil forKey:@"newDelegate"];
    
    return result;
    
    
    
    
    
    /*
     //        for (NSArray* result in box.removeResultArray) {
     //            int value;
     //            for (Tile* tile in result) {
     //                value=tile.value;
     //                NSLog(@"@x:%d,y:%d",tile.x,tile.y);
     //            }
     //
     //            int mul=1;
     //            int mount=result.count;
     //            if(mount==3){
     //                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"ding.wav"];
     //            }
     //            if(mount>3) {
     //                if(self.isSoundEnabled)[[SimpleAudioEngine sharedEngine]playEffect:@"ding.wav"];
     //                mul=pow(2, mount-2);
     //
     //            }
     //            if(mount>6){
     //                NSLog(@"combo mount:%d",mount);
     //            }
     //            self.scoreInBattle+=mount*10*mul;
     //
     //
     //            if(mount>=3&&(1<=value&&value<=3)){
     //                Hero* hero=self.tileDelegateArray[value-1];
     //                hero.curEnergy+=mount;
     //            }
     //
     //        }
     
     //        NSArray* tmp=[box.readyToRemoveTiles allObjects];
     
     //        matchedArray=[box findMatchedArray:tmp forValue:5];  //5 is PlayerAttack
     //        if (matchedArray) {
     //            float delayTime=0.5f;
     //            int reduceHp=matchedArray.count;
     //            if(self.enemy.curHP<=reduceHp){
     //                //self.scale=1.5;
     //                //self.position=ccp(-100,-100);
     //                delayTime=2.5f;
     //                CCSprite* sword=[CCSprite spriteWithFile:@"block_5.png"];
     //                sword.position=ccp(250,300);
     //
     //                [self addChild:sword];
     //                //[self endingZoom];
     //
     //                [sword runAction:[CCSequence actions:
     //                                  [CCDelayTime actionWithDuration:1.0],
     //                                  [CCSpawn actions:
     //                                   [CCRotateBy actionWithDuration:1.5 angle:720],
     //                                   [CCMoveTo actionWithDuration:1.5 position:self.enemy.sprite.position],
     //
     //                                   nil],
     //                                  [CCMoveTo actionWithDuration:.5 position:ccp(350,530)],
     //                                  nil]];
     //                [Actions shakeSprite:obj.enemy.sprite delay:2.5];
     //
     //            }
     //            for (Tile* tile in matchedArray) {
     //                CCSprite* sword=[CCSprite spriteWithFile:@"block_5.png"];
     //                sword.position=tile.sprite.position;
     //                sword.scaleX=tile.sprite.scaleX;
     //                sword.scaleY=tile.sprite.scaleY;
     //                sword.anchorPoint=tile.sprite.anchorPoint;
     //                [self addChild:sword];
     //
     //
     //
     //                CGPoint pos=self.enemy.sprite.position;
     //
     //                __block CCSprite* obj=sword;
     //                [sword  runAction:[CCSequence actions:
     //                                   [CCMoveTo actionWithDuration:.4 position:pos],
     //                                   [CCCallBlock actionWithBlock:^{
     //                                        [obj removeFromParentAndCleanup:YES];
     //                                    }]
     //                                   , nil] ];
     //
     //            }
     //
     //
     //            __block AiObject* hurtObj=[[AiObject alloc]initWithAllObjectArray:nil];
     //            hurtObj.damage=reduceHp;
     //            [self.actionHandler addActionWithBlock:^{
     //                [Actions shakeSprite:obj.enemy.sprite delay:delayTime withFinishedBlock:^{
     //                    [obj.enemy hurtByObject:hurtObj];
     //                    //obj.enemy.curHP-=reduceHp;
     //                     }];
     //            }];
     //            
     //        }
     //        matchedArray=[box findMatchedArray:tmp forValue:4];
     //        if (matchedArray) {self.moneyInBattle+=matchedArray.count;}
     //        matchedArray=[box findMatchedArray:tmp forValue:6];
     //        //if (matchedArray) {self.expInBattle+=matchedArray.count;}
     //        matchedArray=[box findMatchedArray:tmp forValue:7];
     //        if (matchedArray) {
     //                //7的时候
     //        
     //        }

     
     */
    
    
    
}
@end
