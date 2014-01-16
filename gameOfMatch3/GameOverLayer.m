//
//  GameOverLayer.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-9-2.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "GameOverLayer.h"
#import "Global.h"
#import "SimpleAudioEngine.h"
@interface GameOverLayer()
@property int touchCount;
@property bool won;
@end
@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won withGameInfo:nil] ;
    [scene addChild: layer];

    return scene;
}
+(CCScene *) sceneWithWon:(BOOL)won withGameInfo:(NSDictionary*) info{
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[GameOverLayer alloc] initWithWon:won withGameInfo:info] ;
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won withGameInfo:(NSDictionary*) info{
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        self.isTouchEnabled=YES;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.won=won;
        float duration=8.0f;
        bool backwards=NO;
        NSString * message;
        if (won) {
            message = @"胜利";
            [self addChild:[CCParticleSpiral node]];
            [self addChild:[CCParticleFireworks node]];
            //[self addChild:[CCParticleMeteor node]];
            [self addChild:[CCParticleExplosion node]];
            
            if (info) {
                NSMutableArray* labelArray=[[NSMutableArray alloc]init];
                CGSize winSize = [[CCDirector sharedDirector] winSize];
                CCLabelTTF * label ;
                int padding=40;
                for(int i=0;i<5;i++){
                    label= [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:28];
                    label.color = ccc3(0,0,0);
                    label.position = ccp(winSize.width/2+10, winSize.height-padding*(i+1));
                    [self addChild:label];
                    [labelArray addObject:label];
                    
                }
                int moneyInBattle=[[info valueForKey:@"moneyInBattle"] intValue];
                int moneyWin=[[info valueForKey:@"moneyWin"] intValue];
                int starMount=[[info valueForKey:@"star"] intValue];
                int score=[[info valueForKey:@"score"] intValue];
                NSString* star;
                if (starMount==0) star=@"☆☆☆";
                if (starMount==1) star=@"★☆☆";
                if (starMount==2) star=@"★★☆";
                if (starMount==3) star=@"★★★";
                int i=0;
                int curLevel=[[Global sharedManager] currentLevelOfGame];
                //[labelArray[i++] setString:[NSString stringWithFormat:@"得到经验:%d",player.expInBattle]];
                [labelArray[i++] setString:[NSString stringWithFormat:@"%@",star]];
                [labelArray[i++] setString:[NSString stringWithFormat:@"得到金线:%d",moneyInBattle]];
                //[labelArray[i++] setString:[NSString stringWithFormat:@"过关经验:%d",curLevel*25]];
                [labelArray[i++] setString:[NSString stringWithFormat:@"过关金钱:%d",moneyWin]];
                [labelArray[i++] setString:[NSString stringWithFormat:@"得分:%d",score]];
                
                [[Global sharedManager] nameOfGameLevelArray][curLevel-1]=[NSString stringWithFormat:@"%02d",curLevel];

                
//                CGSize winSize = [[CCDirector sharedDirector] winSize];
//                CCLabelTTF * label ;
//                Person* player=playLayer.player;
//                label= [CCLabelTTF labelWithString:[NSString stringWithFormat:@"得到经验:%d",player.expInBattle] fontName:@"Arial" fontSize:28];
//                label.color = ccc3(0,0,0);
//                label.position = ccp(winSize.width/2+10, winSize.height-20);
//                [self addChild:label];
//                
//                label= [CCLabelTTF labelWithString:[NSString stringWithFormat:@"得到金线:%d",player.moneyInBattle] fontName:@"Arial" fontSize:28];
//                label.color = ccc3(0,0,0);
//                label.position = ccp(winSize.width/2+10, winSize.height-40);
//                [self addChild:label];
            }
        } else {
            //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameOver.mp3"];
            message = @"你翘了  ";
            [self setColor:ccc3(0,0,0)];
            [self addChild:[CCParticleFire node]];
            //[self addChild:[CCParticleSmoke node]];
            duration=6.0f;
            backwards=YES;
        }
        
        
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"Arial" fontSize:28];
        label.color = ccc3(0,0,0);
        label.position = ccp(winSize.width/2+10, winSize.height/2-20);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:duration],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:.5 scene:[GameLevelLayer scene] backwards:backwards]];
             //[[CCDirector sharedDirector] replaceScene:[GameLevelLayer scene]];
         }],
          nil]];
        
        
    }
    return self;
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchCount++;
    UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    
    if(self.touchCount>1){
        [self stopAllActions];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:.5 scene:[GameLevelLayer scene] backwards:!self.won]];
    }



}
@end
