//
//  PlayingCardDeck.m
//  Card
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Tom Lai. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"
@implementation PlayingCardDeck


- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc]init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card]; // think this is the homework
            }
        }
    }
    return self;
}

@end
