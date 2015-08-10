//
//  SetCard.h
//  Matchismo
//
//  Created by Tom Lai on 8/10/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
+ (NSArray *)validShapes;
+ (NSArray *)validColor;
+ (int)maxNumber;
+ (NSArray *)validShading;
@end
