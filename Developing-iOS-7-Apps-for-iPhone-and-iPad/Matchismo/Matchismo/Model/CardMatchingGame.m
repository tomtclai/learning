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
@property (nonatomic, strong) NSMutableArray *matchableCards;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableResult;
@end

@implementation CardMatchingGame
NSString * lastMoveWasProfitableKey = @"lastMoveWasProfitable";
NSString * lastSelectedCardsKey = @"lastSelectedCards";
NSString * changeInScoreAbsKey = @"changeInScoreAbs";
NSString * winningComboKey = @"winningCombo";


-(NSMutableDictionary *)mutableResult
{
    if (!_mutableResult) _mutableResult = [NSMutableDictionary dictionary];
    return (NSMutableDictionary*) _mutableResult;
}

-(NSMutableDictionary *)result
{
    return [_mutableResult copy];
}

-(NSMutableArray *)matchableCards
{
    if (!_matchableCards) _matchableCards = [[NSMutableArray alloc]init];
    return _matchableCards;
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

- (void)chooseCardAtIndex:(NSUInteger)index
{
    static const int COST_TO_CHOOSE = 0;
    Card *thisCard = [self cardAtIndex:index];
    if (!thisCard.isMatched) {
        if (thisCard.isChosen) {

            thisCard.chosen = NO;
            [self.matchableCards removeObject:thisCard];
        } else {
            thisCard.chosen = YES;
            [self.matchableCards addObject:thisCard];

            self.score -= COST_TO_CHOOSE;
            if ([self.matchableCards count] == self.numOfCardsToPick)
            {
                [self calculateScore];
            }
            else
            {
                [self.mutableResult setValue:0 forKey:changeInScoreAbsKey];
            }
        }
    }
}

- (void)calculateScore
{
    static const int MISMATCH_PENALTY = 1;
    int MATCH_BONUS = 5 / [self numOfCardsToPick] ;

    int sumScore =0;
    NSMutableArray *matched = [NSMutableArray array];
    for (Card* card in self.matchableCards)
    {
        int matchScore = [card match:self.matchableCards];
        if (matchScore ) {
            sumScore += matchScore;
            [matched addObject:card];
        }
    }
    
    self.mutableResult[lastSelectedCardsKey]=[self.matchableCards copy];
    self.mutableResult[winningComboKey]=[matched copy];
    if ([matched count]==0)
    {
        // 0 out of 3 match -> unchoose the last one. deselect
        Card* card = self.matchableCards[0];
        card.chosen = NO;
        [self.matchableCards removeObjectAtIndex:0];
        self.score -= MISMATCH_PENALTY;
        
        self.mutableResult[lastMoveWasProfitableKey]=@NO;
        self.mutableResult[changeInScoreAbsKey]=@(MISMATCH_PENALTY);
    }
    else
    {
        // 2 out of 3 match -> set 2 as matched. deselect
        // 3 out of 3 match -> set 3 as matched. deselect
        int pointsEarned = sumScore + sumScore * MATCH_BONUS;
        self.mutableResult[lastMoveWasProfitableKey]=@YES;
        self.mutableResult[changeInScoreAbsKey]=@(pointsEarned);
        self.score += pointsEarned;
        for (Card* card in matched)
        {
            card.matched = YES;
            [self.matchableCards removeObject:card];
        }
    }
    

}
- (NSUInteger)numOfCards {
    return self.cards.count;
}
- (instancetype)init {
    return nil;
}
@end
