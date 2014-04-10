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


@end

@implementation AiObject



-(id)initWithAllObjectArray:(NSMutableArray*)allObjectsArray withName:(NSString *)name{
    self = [super init];
    //self.contentSize=[[CCDirector sharedDirector]winSize];
    if (self) {
        if (!allObjectsArray) {
            return self;
        }
        self.delayTime=0.04f;
        
        self.objectName=name;
        [self initFromPlist];
        
        self.aiState=aiState_nothingToDo;
        
        self.alive=YES;
        self.state=[[State alloc]init];
        //self.collisionObjects=[[NSMutableArray alloc]init];
        self.allObjectsArray=allObjectsArray;
        [self.allObjectsArray addObject:self];
        
        self.findTargetsDelegate=[[AiObjectFindTargetsDelegate alloc]initWithOwner:self];
        [self.findTargetsDelegate addObserverWithType:@"attackRadius"];

    }
    return self;
}
-(void)start{
    [self updateForCommon];
}
-(void)initFromPlist{
    self.attributeDict=[[[Global sharedManager]aiObjectsAttributeDict] valueForKey:self.objectName];
    
    
    //self.animationMovePlist=[self.attributeDict valueForKey:@"animationMovePlist"];
    //    self.damage=[[self.attributeDict valueForKey:@"damage"] floatValue];
    [self loadAttributeFromDict];
    self.attackCD=[[Attribute alloc]init];
    self.moveSpeed=[[Attribute alloc]init];
    self.maxHP=[[Attribute alloc]init];
    self.maxEnergy=[[Attribute alloc]init];
    
    self.curHP=[self.maxHP finalValue];
    self.curEnergy=0;
    self.targetTags=[self.attributeDict valueForKey:@"targetTags"];
    self.selfTags=[self.attributeDict valueForKey:@"tags"];

    if (!self.attributeDict[@"attackRadius"]) {
        [self.attributeDict setValue:@20 forKey:@"attackRadius"];
    }
}

-(void)loadAttributeFromDict{
    [self.attackCD loadWithKey:@"attackCD" fromDict:self.attributeDict];
    [self.moveSpeed loadWithKey:@"moveSpeed" fromDict:self.attributeDict];
    [self.maxHP loadWithKey:@"maxHP" fromDict:self.attributeDict];
    [self.maxEnergy loadWithKey:@"maxEnergy" fromDict:self.attributeDict];
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
-(NSMutableArray*)collisionObjectsByDistance:(float)distance withObjectsArray:(NSArray*)objectsArray{
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (AiObject* obj in objectsArray) {
        if(obj==self)continue;
        
        if (ccpDistance([self getCenterPoint], [obj getCenterPoint])<=distance) {
            [ret addObject:obj];
        }
        
    }
    return ret;
    
}
-(NSMutableArray*)collisionObjectsByDistance:(float)distance{
    return [self collisionObjectsByDistance:distance withObjectsArray:self.allObjectsArray];
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
//-(void)updateCollisionObjectArray{
//    CGRect rect;
//    CGSize size;
//
//    [self.collisionObjects removeAllObjects];
//    rect=[self getBoundingBox];
//    self.collisionObjects=[self collisionObjectsByRect:rect];
//    
//    //update collisionObjectsInSight 
//    size=CGSizeFromString([self.attributeDict valueForKey:@"sightRange"]);
//    if (size.height==0&&size.width==0) {
//        size.height=999;size.width=999;   //plist未定义时
//    }
//    rect=[self getBoundingBox];
//    rect.size=size;   //要把origin转换到左下角
//    rect.origin.x=[self getCenterPoint].x-size.width/2;
//    rect.origin.y=[self getCenterPoint].y-size.height/2;
//    self.collisionObjectsInSight=[self objectsByTags:self.targetTags from:[self collisionObjectsByRect:rect]];
//    
//    
//    //update collisionObjectsInAttankRange
//    size=CGSizeFromString([self.attributeDict valueForKey:@"attackRange"]);
//    rect=[self getBoundingBox];
//    rect.size=size;
//    rect.origin.x=[self getCenterPoint].x-size.width/2;
//    rect.origin.y=[self getCenterPoint].y-size.height/2;
//    self.collisionObjectsInAttankRange=[self objectsByTags:self.targetTags from:[self collisionObjectsByRect:rect]];
//    
//    
//}
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
    if (!tags) {
        return [NSArray arrayWithArray:objectsArray];
    }
    NSMutableArray* ret=[[NSMutableArray alloc]init];
    for (NSString* tag in tags) {
        for (AiObject* obj in objectsArray) {
            if ([obj.selfTags containsObject:tag]) {
                [ret addObject:obj];
            }
        }
    }
    return ret;
}
-(void)onInSightButNotInAttackRange{
    //重载用
}
-(void)onNotReadyToAttackTargetInRange{
    
}
-(bool)onReadyToAttackTargetInRange{
    return NO;
}
-(void)onInAttackRange{
    float gameTime=[[Global sharedManager] gameTime];
    if(self.lastAttackTime&&(gameTime-self.lastAttackTime<[self.attackCD finalValue]))
    {
        [self onNotReadyToAttackTargetInRange];
        return;
        
    }else{
        if ([self onReadyToAttackTargetInRange]) {
            self.lastAttackTime=gameTime;
        }
        
        
    }
    
    //重载用
}
-(void)onFindTargets{
    // 重载用
}
-(void)onFindNothing{
   // 重载用
}
-(void)onNothingToDo{
    //重载用
}
-(void)onCurHPIsZero{
    //重载用
}

-(void)onEnterFrame{
    //重载用
}
-(void)onDie{
    //重载用
}
-(bool)checkDie{
    return NO;
}

-(void)moveToPosition:(CGPoint)pos{
    if(!self.node)return;
    if (isnan(pos.x)||isnan(pos.y)) {
        return;
    }
    
    float speed=[self.moveSpeed finalValue];
    
    CGPoint position=self.node.position;

    float moveDistanceX=speed*self.delayTime;
    float moveDistanceY=speed*self.delayTime;
    float xDistance=pos.x-position.x;
    float yDistance=pos.y-position.y;
    float xMoveDistance=xDistance==0?0:(xDistance>0?moveDistanceX:-moveDistanceX);
    float yMoveDistance=yDistance==0?0:(yDistance>0?moveDistanceY:-moveDistanceY);
    
//    if (abs(xDistance)>abs(yDistance)){yMoveDistance=yDistance==0?0:yMoveDistance/abs(xDistance/yDistance);}
//    else{ xMoveDistance=xDistance==0?0:xMoveDistance/abs(yDistance/xDistance);}
    

    
    float destMinDistance=max(moveDistanceX,3);
    if(
       (abs(xDistance)<destMinDistance)&&
       (abs(yDistance)<destMinDistance)
       ){
        self.atDest=YES;
        return;
    }
    
//    if(
//       (abs(xDistance)<destMinDistance||speed==0)&&
//       (abs(yDistance)<destMinDistance||speed==0)
//       ){
//        self.atDest=YES;
//        return;
//    }
    
    self.node.position=ccp( position.x+xMoveDistance,position.y+yMoveDistance);
}

-(bool)directAttackTarget:(AiObject*)obj{
    DamageData* damageData=[AiObjectInteraction physicalDamageBy:obj];
    [obj hurtByObject:damageData];
    return YES;
}
-(void)hurtByObject:(DamageData*)data{  //一些关于 受到冰伤变色之类的也可以在interaction里设状态 然后aiobject专门有一块来做动画更新//要不由buff来做先
    NSDictionary* finalDamage=[AiObjectInteraction finalDamageOn:self withData:data];
    self.curHP+=[finalDamage[@"hp"] floatValue];
}
-(void)onRecalcAttribute{
    [self loadAttributeFromDict];
}
-(void)updateForCommon{
    float delayTime=self.delayTime;
    if (!self.node) {
        [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
        return;
    }
    
    //检测死亡（逻辑上）
    if (self.curHP<=0) {
        [self onCurHPIsZero];
    }
    
    if ([self checkDie]){
        [self onDie];
    }
    //检测结束(退出update)
    if(self.readyToEnd){
        [self removeAllChildrenWithCleanup:YES];
        [self removeFromParentAndCleanup:YES];
        [self unschedule:@selector(updateForCommon)];
        return;
    }
    
    //重算属性
    [self onRecalcAttribute];
    //进入帧
    [self onEnterFrame];

    //找目标

    [self.findTargetsDelegate findTargets];
    
    
//    [self updateCollisionObjectArray];
//    
//    if (self.collisionObjectsInAttankRange.count>0) {
//        [self onInAttackRange];
//    }else if (self.collisionObjectsInSight.count>0){
//        [self onInSightButNotInAttackRange];
//    }else{
//        [self onNothingInSight];
//    }
    

    
    
    [self setTimeOutWithDelay:delayTime withSelector:@selector(updateForCommon)];
}


@end
