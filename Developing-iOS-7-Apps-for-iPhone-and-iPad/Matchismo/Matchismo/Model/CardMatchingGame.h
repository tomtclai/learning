//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject
extern const NSString * lastMoveWasProfitableKey;
extern const NSString * lastSelectedCardsKey;
extern const NSString * changeInScoreAbsKey;
extern const NSString * winningComboKey;
// desginated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
                 numOfCardsToPick:(NSUInteger)numOfCardsToPick;

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)numOfCards;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSDictionary *result;
@end
