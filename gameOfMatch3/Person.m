//
//  Person.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-8-30.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Person.h"
@interface Person()


@end
@implementation Person

@synthesize experience=_experience;

+(Person*)sharedPlayer{
    
    static Person* sharedPlayer = nil;
    
    if (sharedPlayer == nil) {
        sharedPlayer = [[self alloc] init];
    }
    return sharedPlayer;
}
+(void)initSharedPlayer{
    Person* person=[Person sharedPlayer];
    Person* defaultPerson=[self defaultPlayer];
    
    [Person copyWith:defaultPerson to:person];
    
    
}
+(Person*)sharedPlayerCopy{
    return [self copyWith:[Person sharedPlayer]];
    
}
+(void)copyWith:(Person *)oriPerson to:(Person*)destPerson{
    Person* defaultPerson=oriPerson;
    Person* person=destPerson;
    person.curHP=defaultPerson.curHP;
    person.maxHP=defaultPerson.maxHP;
    person.maxStep=defaultPerson.maxStep;
    person.curStep=defaultPerson.curStep;
    person.damage=defaultPerson.damage;
    person.spriteName=defaultPerson.spriteName;
    person.experience=defaultPerson.experience;
    person.spriteScale=defaultPerson.spriteScale;
    person.maxManaArray=defaultPerson.maxManaArray;
    person.stateDict=defaultPerson.stateDict ;
}
+(Person*)copyWith:(Person*)oriPerson{
    Person* person=[[Person alloc] init];
    [self copyWith:oriPerson to:person];
    return person;
}
+(Person*)defaultPlayer{
    
    Person* person=[[Person alloc] init];
    

    person.experience=0;
    person.curHP=100;
    person.maxHP=100;
    person.maxStep=5;
    person.curStep=person.maxStep;
    person.damage=5;
    person.spriteName=[NSString stringWithFormat:@"player.png"];
    person.spriteScale=0.4f;
    person.maxManaArray=[NSMutableArray arrayWithObjects:@10,@10,@10,@10, nil];
    person.stateDict=[[NSMutableDictionary alloc ]initWithObjectsAndKeys:@0.0,@"fired",@0.0,@"poisoned", nil];
    return person;
    
    
    
    
}

+(int)lvByExp:(int)experience{
    int lv=sqrt(experience/50.0)+1;
    return lv;
}

-(int)expByNextLv:(int)lv{ //到下一级所需总经验
    int experience=lv*lv*50;
    return experience;
}
-(int)expToNextLV{
    int experience=[self expByNextLv:self.lv]-self.experience;
    
    return experience;
}


-(int)lv{
    return [Person lvByExp:self.experience];
}


-(int)magicDamage{
   
    return 20+(self.lv-1)*2;;
}
-(int)experience{
    return _experience;
}
-(void)setExperience:(int)experience{
    if ([Person lvByExp:experience]>10) {
        _experience=[self expByNextLv:10];
    }else{
        _experience=experience;
    }
}
+(Person*)defaultEnemy
{
    Person* person=[[Person alloc] init];
    person=[[Person alloc]init];
    person.damage=13;
    person.curHP=100;
    person.maxHP=100;
    person.spriteName=[NSString stringWithFormat:@"enemy_4.png"];
    person.spriteScale=1.0f;
    person.apSpeed=5.0f;
    person.stateDict=[[NSMutableDictionary alloc ]initWithObjectsAndKeys:@1.0,@"slow",@1.0,@"poison", nil];
    return person;
}

+(Person*)enemyWithLevel:(int)level{
    Person* person=[self copyWith:[Person defaultEnemy]];
    
    
    int raw_level=level;
    level=(level-1)%3+1;
    
    if(level==1){
        person.damage=13;
        person.maxHP=60;
    }
    if(level==2){
        person.damage=15;
        person.maxHP=85;
    }
    if(level==3){
        person.damage=17;
        person.maxHP=110;
    }
    if(level==4){
        person.damage=24;
        person.maxHP=120;
    }
    if(level==5){
        person.damage=24;
        person.maxHP=140;
    }

    person.damage+=4*(int)((raw_level-1)/3);
    person.maxHP+=140*(int)((raw_level-1)/3);
    person.apSpeed=5.0f+1*(int)((raw_level-1)/3);
    
    person.curHP=person.maxHP;
    person.spriteName=[NSString stringWithFormat:@"enemy_%d.png",level];
    person.spriteScale=1.0f;
    person.maxStep=100;
    person.curStep=0;
    person.level=level;
    
    
    return person;
    
}
@end

