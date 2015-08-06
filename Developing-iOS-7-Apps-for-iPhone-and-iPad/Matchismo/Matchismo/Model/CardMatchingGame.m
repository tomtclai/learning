//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()

// use readwrite to redeclare
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic) NSUInteger numOfCardsToPick;
@end

@implementation CardMatchingGame


-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}


- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    return [self initWithCardCount:count
                         usingDeck:deck
                  numOfCardsToPick:2];
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                 numOfCardsToPick:(NSUInteger)numOfCardsToPick
{
    self = [super init];
    self.numOfCardsToPick = numOfCardsToPick;
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])? [self.cards objectAtIndex:index] : nil;
}


static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 4;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    NSMutableArray* matchableCards = [NSMutableArray array];
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
            for (Card *otherCard in self.cards) {
                if (otherCard.isChosen && !otherCard.isMatched) {
                    [matchableCards addObject:otherCard];
                }
            }
            if ([matchableCards count]+1 == self.numOfCardsToPick)
            {
                int matchScore = [card match:matchableCards];
                if (matchScore ) {
                    self.score += matchScore * MATCH_BONUS;
                } else {
                    self.score -= MISMATCH_PENALTY;
                }
            }
            
            
            
        }
    }
}

- (instancetype)init {
    return nil;
}
@end
