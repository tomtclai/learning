//
//  PlayingCardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/6/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "PlayingCardGameVIewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
@interface PlayingCardGameVIewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@end
@implementation PlayingCardGameVIewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (void)updateUI
{
    [super updateUI];
    CardMatchingGame* game = super.game;
    if (game.result[changeInScoreAbsKey] !=0)
    {
        NSNumber* profit = game.result[lastMoveWasProfitableKey];
        NSArray *cards = game.result[lastSelectedCardsKey];
        NSString *cardsStr = [cards componentsJoinedByString:@" "];
        NSArray *winningCombo = game.result[winningComboKey];
        NSString *winningCardsStr = [winningCombo componentsJoinedByString:@" "];
        NSNumber* scoreChange = game.result[changeInScoreAbsKey];
        
        if ([profit boolValue])
        {
            self.statusTextLabel.text =
            [NSString stringWithFormat:@"Matched %@ for %@ points",winningCardsStr,scoreChange];

        } else
        {
            
            self.statusTextLabel.text =
            [NSString stringWithFormat:@"%@ don't match: \n%@ point penalty",cardsStr, scoreChange];
        }
    }
}
@end
