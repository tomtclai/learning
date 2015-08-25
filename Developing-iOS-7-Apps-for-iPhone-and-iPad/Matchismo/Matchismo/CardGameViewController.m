//
//  CardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "Grid.h"
#import "CardMatchingGame.h"
@interface CardGameViewController ()
@property (nonatomic, strong) Deck* deck;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (nonatomic, strong) Grid* grid;
@end

@implementation CardGameViewController
@dynamic cardButtons, numberOfStartingCards;
#pragma mark - view controller life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.grid.size = self.cardView.bounds.size;
    self.grid.cellAspectRatio = self.elementAspectRatio;
    self.grid.minimumNumberOfCells = self.numberOfStartingCards;
}

- (void)viewWillLayoutSubviews
{
    self.grid.size = self.cardView.bounds.size;
    [self layoutButtons];
}


- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
#pragma mark - instantiations
- (Grid *)grid {
    if (!_grid)
    {
        _grid = [[Grid alloc] init];
    }
    return _grid;
}
- (History *)log
{
    if (!_log) {
        _log = [[History alloc]init];
    }
    return _log;
}
- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]
                                                   numOfCardsToPick:self.gameModeSwitch.on? 3 : 2];
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}
#pragma mark - buttons
- (IBAction)touchCardButton:(UIButton *)sender
{
    
    int cardIndex = (int) [self.cardButtons indexOfObject:sender];
    self.gameModeSwitch.enabled = NO;
    [self.game chooseCardAtIndex: cardIndex];
    [self updateUI];
}
- (IBAction)deal3MoreCards:(id)sender {
    
}
#define CARDSPACINGINPERCENT 0.08
- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int) [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
//                              forState:UIControlStateNormal];
        [cardButton setEnabled:!card.isMatched];
        if (card.isMatched) {
            cardButton.alpha = 0.6;
        }

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
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (IBAction)changeGameMode:(UISwitch *)sender {
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchRestartButton {
    self.gameModeSwitch.enabled = YES;
    self.game = nil;
    self.log = nil;
    [self updateUI];
}
- (void)layoutButtons {

    if (self.grid.inputsAreValid) {
        NSUInteger col = self.grid.columnCount;
        
        for (NSUInteger i = 0 ; i < [self.cardButtons count]; i++)
        {
            UIButton * buttonI = (UIButton *) self.cardButtons[i];
            
            CGRect frame = [self.grid frameOfCellAtRow:i / col
                                              inColumn:i % col];
            frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT,
                                frame.size.height * CARDSPACINGINPERCENT);
            [buttonI setFrame:frame];
            [buttonI addTarget:self
                        action:@selector(touchCardButton:)
              forControlEvents:UIControlEventTouchUpInside];
            
            
            [self.cardView addSubview:buttonI];
        }
        
        [self updateUI];
    }
}

@end
