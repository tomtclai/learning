//
//  PlayingCardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/6/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@end
@implementation PlayingCardGameViewController

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
            NSString *labelText = [NSString stringWithFormat:@"Matched %@ for %@ points",winningCardsStr,scoreChange];
            self.statusTextLabel.text = labelText;
            [[self log]appendString:labelText];
            [[self log]appendString:@"\n"];
        } else
        {
            NSString *labelText = [NSString stringWithFormat:@"%@ don't match: %@ point penalty",cardsStr, scoreChange];
            self.statusTextLabel.text = labelText;
            [[self log]appendString:labelText];
            [[self log]appendString:@"\n"];
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showPlayCardHistory"]) {
        
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController* hvc = segue.destinationViewController;
            hvc.history = [self log];
        }
    }
}
@end
