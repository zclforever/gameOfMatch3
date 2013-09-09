//
//  Person.m
//  gameOfMatch3
//
//  Created by 张成龙 on 13-8-30.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import "Person.h"

@implementation Person

+(Person*)defaultPlayer{
    Person* person=[[Person alloc] init];
    
    person.curHP=100;
    person.maxHP=100;
    person.maxStep=5;
    person.curStep=person.maxStep;
    person.damage=5;
    person.magicDamage=20;
    person.spriteName=[NSString stringWithFormat:@"player.png"];
    return person;
    
    
    
    
}
+(Person*)defaultEnemy
{
    Person* person=[[Person alloc] init];
    person=[[Person alloc]init];
    person.damage=13;
    person.curHP=100;
    person.maxHP=100;
    person.spriteName=[NSString stringWithFormat:@"enemy_4.png"];
    return person;
}

+(Person*)enemyWithLevel:(int)level{
    Person* person=[[Person alloc]init];
    
    if(level==1){
        person.damage=13;
        person.maxHP=100;
    }
    if(level==2){
        person.damage=15;
        person.maxHP=105;
    }
    if(level==3){
        person.damage=17;
        person.maxHP=110;
    }
    if(level==4){
        person.damage=24;
        person.maxHP=120;
    }
    person.curHP=person.maxHP;
    person.spriteName=[NSString stringWithFormat:@"enemy_%d.png",level];
    return person;
    
}
@end

