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
@property (nonatomic) const NSUInteger numOfCardsToPick;
@property (nonatomic, strong) NSMutableArray *currentlySelectedCards;
@end

@implementation CardMatchingGame

-(NSMutableArray *)currentlySelectedCards
{
    if (!_currentlySelectedCards) _currentlySelectedCards = [[NSMutableArray alloc]init];
    return _currentlySelectedCards;
}

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
                  numOfCardsToPick:3];
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
    Card *thisCard = [self cardAtIndex:index];
    if (!thisCard.isMatched) {
        if (thisCard.isChosen) {
            thisCard.chosen = NO;
            [self.currentlySelectedCards removeObject:thisCard];
        } else {
            thisCard.chosen = YES;
            [self.currentlySelectedCards addObject:thisCard];
            
            self.score -= COST_TO_CHOOSE;
            if ([self.currentlySelectedCards count] >= self.numOfCardsToPick)
            {
                int matchScore = [thisCard match:self.currentlySelectedCards];
                if (matchScore ) {
                    self.score += matchScore * MATCH_BONUS;
                    [self.currentlySelectedCards removeAllObjects];
                    
                } else {
                    self.score -= MISMATCH_PENALTY;
                    Card* cardToUnchose= [self.currentlySelectedCards objectAtIndex:0];
                    cardToUnchose.chosen = NO;
                    [self.currentlySelectedCards removeObjectAtIndex:0];
                    
                }
            }
        }
    }
}

- (instancetype)init {
    return nil;
}
@end
