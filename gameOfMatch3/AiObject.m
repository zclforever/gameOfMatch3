//
//  AiObject.m
//  gameOfMatch3
//
//  Created by Wei Ju on 13-12-17.
//  Copyright 2013年 Wei Ju. All rights reserved.
//

#import "AiObject.h"

@implementation State

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
@interface AiObject()
@property (strong,nonatomic) AiObject* wantedObject;

@end

@implementation AiObject



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString *)name{
    self = [super init];
    //self.contentSize=[[CCDirector sharedDirector]winSize];
    if (self) {
        if (!allObjectsArray) {
            return self;
        }
        self.delayTime=0.04;
        
        self.objectName=name;
        [self initFromPlist];
        
        self.aiState=aiState_nothingToDo;

        self.autoUpdateCollision=YES;
        
        self.alive=YES;
        self.state=[[State alloc]init];
        self.collisionObjects=[[NSMutableArray alloc]init];
        self.allObjectsArray=allObjectsArray;
        [self.allObjectsArray addObject:self];
        [self updateForCommon];
    }
    return self;
}
-(void)initFromPlist{
    self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
    //    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    self.attackCD=[[self.attributeDict valueForKey:@"attackCD"] floatValue];
    self.moveSpeed=[[self.attributeDict valueForKey:@"moveSpeed"] floatValue];
    self.maxHP=[[self.attributeDict valueForKey:@"maxHP"] floatValue];
    self.curHP=self.maxHP;
    self.curEnergy=0;
    self.maxEnergy=[[self.attributeDict valueForKey:@"maxEnergy"] floatValue];
    self.targetTags=[self.attributeDict valueForKey:@"targetTags"];
    self.tags=[self.attributeDict valueForKey:@"tags"];
    
}
-(NSArray*)getNameOfFramesFromPlist:(NSString*)name{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:name];
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathForFilename:name];
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary* nameDict=[dict valueForKey:@"frames"];
    NSArray* sortedArray= [nameDict.allKeys sortedArrayUsingSelector:@selector(localizedCompare:)];
    return sortedArray;
}
-(CCAnimation* )animationByPlist:(NSString*)name withDelay:(float)delay{
    if (!delay) {
        delay=.1;
    }
    NSArray* sortedArray=[self getNameOfFramesFromPlist:name];
    
    CCSpriteBatchNode *batchNode = [CCSpriteBatchNode batchNodeWithFile:[NSString stringWithFormat:@"%@.png",[name substringToIndex:name.length-6]]];
    [self addChild:batchNode];
    
    NSMutableArray* frames=[[NSMutableArray alloc]init];
    for (NSString* name in sortedArray) {
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:name]];
    }
    
    CCAnimation* animation=[CCAnimation animationWithSpriteFrames:frames delay:delay];
    return animation;
}
-(NSMutableArray*)collisionObjectsByRect:(CGRect)rect{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    CGRect selfRect=rect;
    for (AiObject* obj in self.allObjectsArray) {
        if(obj==self)continue;
        CGRect objRect=[obj getBoundingBox];
        
        if ([Global rectInsect:objRect :selfRect]) {
            [ret addObject:obj];
        }

    }
    return ret;
}
-(void)updateCollisionObjectArray{
    CGRect rect;
    CGSize size;

    [self.collisionObjects removeAllObjects];
    rect=[self getBoundingBox];
    self.collisionObjects=[self collisionObjectsByRect:rect];
    
    //update collisionObjectsInSight 
    size=CGSizeFromString([self.attributeDict valueForKey:@"sightRange"]);
    rect=[self getBoundingBox];
    rect.size=size;   //要把origin转换到左下角
    rect.origin.x=[self getCenterPoint].x-size.width/2;
    rect.origin.y=[self getCenterPoint].y-size.height/2;
    self.collisionObjectsInSight=[self objectsByTags:self.targetTags from:[self collisionObjectsByRect:rect]];
    
    
    //update collisionObjectsInAttankRange
    size=CGSizeFromString([self.attributeDict valueForKey:@"attackRange"]);
    rect=[self getBoundingBox];
    rect.size=size;
    rect.origin.x=[self getCenterPoint].x-size.width/2;
    rect.origin.y=[self getCenterPoint].y-size.height/2;
    self.collisionObjectsInAttankRange=[self objectsByTags:self.targetTags from:[self collisionObjectsByRect:rect]];
    
    
}
-(NSArray*)sortAllObjectsByDistanceFromPosition:(CGPoint)position{
    NSMutableArray* ret=[NSMutableArray arrayWithArray:self.allObjectsArray];

    
    for(int i=ret.count-1;i>0;i--){
        for(int j=0;j<i;j++){
            CGPoint pos1=[ret[j] getCenterPoint] ;
            CGPoint pos2=[ret[j+1] getCenterPoint];
            
            float distance1 = abs(ccpDistance(position, pos1));
            float distance2 = abs(ccpDistance(position, pos2));
            if (distance1>distance2) {
                [ret exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return ret;
    
}


-(void)handleCollision{
    //NSLog(@"in the collisionHandler");
}
-(void)hurtByObject:(AiObject*)obj{
    
}
-(CGRect)getBoundingBox{
    if (!self.node) {
        return CGRectZero;
    }
    float width=[[self.attributeDict valueForKey:@"width"] floatValue];
    float height=[[self.attributeDict valueForKey:@"height"] floatValue];
    CGRect rect=self.node.boundingBox;
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
-(CGPoint)getCenterPoint{
    CGRect rect =[self getBoundingBox];
    float x=rect.origin.x+rect.size.width/2;
    float y=rect.origin.y+rect.size.height/2;
    return ccp(x,y);
}

-(void)setTimeOutOfUpdateWithDelay:(float)timeOut{
    [self setTimeOutWithDelay:timeOut withSelector:@selector(update)];
    
}
-(void)setTimeOutWithDelay:(float)timeOut withBlock:(void(^)())block{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallBlock actionWithBlock:block],
      nil]];
}
-(void)setTimeOutWithDelay:(float)timeOut withSelector:(SEL)selector{
    [self runAction:
     [CCSequence actions:
      [CCDelayTime actionWithDuration:timeOut],
      [CCCallFunc actionWithTarget:self selector:selector],
      nil]];
    
}



-(void)magicAttackWithName:(NSString *)magicName{
    [self magicAttackWithName:magicName withParameter:nil];
}
-(void)magicAttackWithName:(NSString*)magicName withParameter:(NSMutableDictionary*)paraDict{
}
-(void)addLifeBar{
    //init LifeBar
    float width=[[self.attributeDict valueForKey:@"lifeBarWidth"] floatValue];
    float height=[[self.attributeDict valueForKey:@"lifeBarHeight"] floatValue];

    
    self.lifeBar=[CCSprite spriteWithFile:@"lifeBar.png" ];
    self.lifeBar.anchorPoint=ccp(0,0);
    self.lifeBar.scaleX=width/self.lifeBar.contentSize.width;
    self.lifeBar.scaleY=height/self.lifeBar.contentSize.height;
    self.lifeBar.visible=NO;
    
    [self addChild:self.lifeBar];
    
    self.lifeBarBorder=[CCSprite spriteWithFile:@"border.png"];
    self.lifeBarBorder.anchorPoint=ccp(0,0);
    self.lifeBarBorder.scaleX=width/self.lifeBarBorder.contentSize.width;
    self.lifeBarBorder.scaleY=height/self.lifeBarBorder.contentSize.height;
    self.lifeBarBorder.visible=NO;
    
    [self addChild:self.lifeBarBorder];
    
    
    
}
-(void)updateLifeBar{
    self.lifeBar.visible=YES;
    self.lifeBarBorder.visible=YES;
    
    float marginHead=[[self.attributeDict valueForKey:@"lifeBarMarginHead"] floatValue];
    if(!marginHead)marginHead=5;
    
    float width=[[self.attributeDict valueForKey:@"lifeBarWidth"] floatValue];
    //float height=[[self.attributeDict valueForKey:@"top"] floatValue];
    if(self.curHP<0) self.curHP=0;
    
    //updatePosition
    CGRect rect=[self getBoundingBox];
    
    self.lifeBar.position=ccp(self.sprite.position.x-10,self.sprite.position.y+rect.size.height+marginHead);
    self.lifeBarBorder.position=self.lifeBar.position;
    
    self.lifeBar.scaleX=self.curHP/self.maxHP*width/self.lifeBar.contentSize.width;
    
}
-(void)draw{
    if(self.showBoundingBox){
        ccDrawColor4B(255, 0, 0,0);
        glLineWidth(4);
        CGRect rect=[self getBoundingBox];
//        if (self.node.anchorPoint.x==0.5){
//            ccDrawRect(CGPointMake(rect.origin.x-rect.size.width/2, rect.origin.y-rect.size.height/2), CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2));
//        }
        if (YES){
         ccDrawRect(rect.origin, CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height));
        }         
    }
}

-(NSArray*)objectsByTags:(NSArray*)tags from:(NSArray*)objectsArray{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (NSString* tag in tags) {
        for (AiObject* obj in objectsArray) {
            if ([obj.tags containsObject:tag]) {
                [ret addObject:obj];
            }
        }
    }
    return ret;
}


-(void)onAttackWantedButNotInAttackRangeFromObject:(AiObject*)obj{
    // 重载用
}
-(void)onNothingInSight{
   // 重载用
}
-(void)nothingToDo{

        self.aiState=aiState_searchingInSight;


}
-(void)moveToPosition:(CGPoint)pos{
    if (isnan(pos.x)||isnan(pos.y)) {
        return;
    }
    
    CGPoint position=self.node.position;

    float moveDistanceX=self.moveSpeed*self.delayTime;
    float moveDistanceY=self.moveSpeed*self.delayTime;
    float xDistance=pos.x-position.x;
    float yDistance=pos.y-position.y;
    float xMoveDistance=xDistance>0?moveDistanceX:-moveDistanceX;
    float yMoveDistance=yDistance>0?moveDistanceY:-moveDistanceY;
    
    if (abs(xDistance)>abs(yDistance)){yMoveDistance/=abs(xDistance/yDistance);}
    else{ xMoveDistance/=abs(yDistance/xDistance);   }
    


    
    self.node.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
    
    float destMinDistance=max(moveDistanceX,3);
    if(
       (abs(xDistance)<destMinDistance||self.moveSpeed==0)&&
       (abs(yDistance)<destMinDistance||self.moveSpeed==0)
       ){
        self.atDest=YES;
    }
}
-(void)searchingInSight{
    if (self.collisionObjectsInSight.count>0) {//找到目标
        self.aiState=aiState_attackWantedObject;
        self.wantedObject=self.collisionObjectsInSight[0];
    }else{//视线内找不到目标
        self.aiState=aiState_nothingToDo;
        [self onNothingInSight];
     
    }
    
}

-(void)attackingWantedObject{  //不管有没有视线，直接攻击
    AiObject* obj=self.wantedObject;
    if (self.collisionObjectsInAttankRange.count>0) {
        self.aiState=aiState_inAttackRange;
    }else{
        self.aiState=aiState_attackWantedObject;
        [self onAttackWantedButNotInAttackRangeFromObject:obj];
    }
}



-(void)doInAttackRange{
    //目标在攻击范围内时，攻击目标 近身攻击，看成发出在目标身上即时碰撞的透明放射物。
    //英雄攻击 能量有时 正常攻击，技能球时，主动放射攻击
    //小怪 正常攻击，
    if (self.collisionObjectsInAttankRange.count>0) {
        float gameTime=[[Global sharedManager] gameTime];
        if(self.lastAttackTime&&(gameTime-self.lastAttackTime<self.attackCD))
        {
            return;
            
        }else{
            if ([self normalAttackTarget:self.wantedObject]) {
                self.lastAttackTime=gameTime;
            }
            
            
        }

    } else{ //目标逃出攻击范围 
        
      self.aiState=aiState_attackWantedObject;
        return;
    }


    
}
-(bool)normalAttackTarget:(AiObject*)obj{
    NSString* skillName=[self.attributeDict valueForKey:@"skill_0"];
    [self magicAttackWithName:skillName];
    return YES;
}
-(void)updateForCommon{
    float delayTime=self.delayTime;
    if (!self.node) {
        [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
    }
    
    //AI主体，视线范围是否找得到符合条件的目标，找得到做什么(移动并攻击)，找不到做什么(英雄站立，小兵移动)
    
    
    if(self.wantedObject&&self.wantedObject.alive==NO){ //判断死亡 状态
            self.wantedObject=nil;
            self.aiState=aiState_nothingToDo;

    }
    
    [self updateCollisionObjectArray];
    

    switch (self.aiState) {
        case aiState_nothingToDo:
            [self nothingToDo];
            break;
        case aiState_searchingInSight:
            [self searchingInSight];
            break;
        case aiState_attackWantedObject:
            [self attackingWantedObject];
            break;
        case aiState_inAttackRange:
            [self doInAttackRange];
            break;
            
        default:
            break;
    }
   
    

    //todo lifeBar 之类做在这里
     if(self.lifeBar){[self updateLifeBar];};
    
    
    [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
}


@end
