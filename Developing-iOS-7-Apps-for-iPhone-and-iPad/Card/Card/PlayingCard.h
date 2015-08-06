//
//  PlayingCard.h
//  Card
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSArray *)rankStrings;
+ (NSUInteger)maxRank;
@end

