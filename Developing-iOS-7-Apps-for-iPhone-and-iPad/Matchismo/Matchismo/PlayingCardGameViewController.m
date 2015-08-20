//
//  PlayingCardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/6/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"
#import "PlayingCardView.h"
@interface PlayingCardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;
@end
@implementation PlayingCardGameViewController
- (void)viewDidLoad {
    self.buttonClass = NSStringFromClass([PlayingCardView class]);
    [super viewDidLoad];
}

- (NSUInteger) numCards {
    if (super.numCards == 0) {
        super.numCards = 30;
    }
    return super.numCards;
}
- (IBAction)touchCardButton:(UIButton *)sender
{
    [super touchCardButton:sender];
    if ([sender isKindOfClass:[PlayingCardView class]]) {
        PlayingCardView *btn = (PlayingCardView *)sender;
        btn.faceUp = !btn.faceUp;
        
    }
}
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (void)updateUI
{
    [super updateUI];
    [self displayCards];
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
- (void) displayCards {
    
    
    for (int i = 0 ; i < [self.cardButtons count]; i++) {
        PlayingCardView *cardButton = self.cardButtons[i];
        PlayingCard *playingCard = (PlayingCard*) [self.game cardAtIndex:i];
        cardButton.rank = playingCard.rank;
        cardButton.suit = playingCard.suit;
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
