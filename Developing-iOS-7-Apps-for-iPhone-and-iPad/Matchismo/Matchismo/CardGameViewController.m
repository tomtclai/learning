//
//  CardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
//#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
@interface CardGameViewController ()
@property (nonatomic, strong) Deck* deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;


@end

@implementation CardGameViewController

- (CardMatchingGame *)game {
    int howManyCard = self.gameModeSwitch.on? 3 : 2;
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]
                                                   numOfCardsToPick:howManyCard];
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    
    int cardIndex = (int) [self.cardButtons indexOfObject:sender];
    self.gameModeSwitch.enabled = NO;
    [self.game chooseCardAtIndex: cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int) [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %@", [@(self.game.score) stringValue]];
    
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : [[NSString alloc]init];
//    return card.contents; //for debug
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardfront"];
}

- (IBAction)changeGameMode:(UISwitch *)sender {
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchRestartButton {
    self.gameModeSwitch.enabled = YES;
    self.game = nil;
    [self updateUI];
}

@end
