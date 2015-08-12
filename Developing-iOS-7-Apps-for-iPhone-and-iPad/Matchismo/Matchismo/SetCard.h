//
//  SetCard.h
//  Matchismo
//
//  Created by Tom Lai on 8/10/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property(strong, nonatomic) NSString *shape;
@property(strong, nonatomic) NSString *color;
@property(nonatomic) NSUInteger number;
@property(strong, nonatomic) NSString *shading;

+ (NSArray *)validShapes;
+ (NSArray *)validColors;
+ (int)maxNumber;
+ (NSArray *)validShadings;
@end
