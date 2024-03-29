//
//  PlayingCard.m
//  Card
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// need this if you implement both setter and getter
@synthesize suit=_suit;

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}
- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}


+ (NSArray *)rankStrings
{
    return  @[@"?",@"A",@"2",@"3",
              @"4",@"5",@"6",@"7",
              @"8",@"9",@"10",@"J",
              @"Q",@"K"];
}

+ (NSUInteger)maxRank {return [[self rankStrings] count]-1;}

- (NSString *)suit
{
    return _suit ? _suit:@"?";
}

@end
