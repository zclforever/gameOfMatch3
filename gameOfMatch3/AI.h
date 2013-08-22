//
//  AI.h
//  gameOfMatch3
//
//  Created by Wei Ju on 13-8-22.
//  Copyright (c) 2013年 Wei Ju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box.h"
@interface AI : NSObject{

}
@property (strong,nonatomic) Box* box;
-(id) initWithBox: (Box*) box;
@end
