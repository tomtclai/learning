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
#pragma mark - view controller life cycle
const CGFloat elementAspectRatio = 52.0/77.0;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification
             object:device];
    self.grid.size = self.cardView.bounds.size;
    self.grid.cellAspectRatio = elementAspectRatio;
    self.grid.minimumNumberOfCells = self.numCards;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self layoutButtons];
    NSLog(@"viewWillAppear");
}
- (void)orientationChanged:(NSNotification *)note {
    
    [self layoutButtons];
    NSLog(@"orientationChanged");
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
- (NSArray *)cardButtons
{
    if (!_cardButtons) {
        NSMutableArray *tmp = [NSMutableArray array];
        for (int i = 0 ; i < self.numCards; i++) {
            UIButton *cardButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [tmp addObject:cardButton];
        }
        _cardButtons = tmp;
    }
    return _cardButtons;
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

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int) [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card]
                    forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]
                              forState:UIControlStateNormal];
        [cardButton setEnabled:!card.isMatched];
        if (card.isMatched) {
            cardButton.alpha = 0.5;
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
    self.grid.size = self.cardView.bounds.size;
    if (self.grid.inputsAreValid) {
        NSUInteger row = self.grid.rowCount;
        NSUInteger col = self.grid.columnCount;
        int cardI = 0;
        for (NSUInteger y = 0 ; y < row; y ++)
        {
            for (NSUInteger x = 0; x < col; x ++)
            {
                if (cardI >= self.numCards) return;
                
                UIButton * buttonI = (UIButton *) self.cardButtons[cardI];

                [buttonI setFrame:[self.grid frameOfCellAtRow:y
                                                     inColumn:x]];
//                
                [buttonI addTarget:self
                            action:@selector(touchCardButton:)
                  forControlEvents:UIControlEventTouchUpInside];
                
                [buttonI setTitleColor:[UIColor blackColor]
                              forState:UIControlStateNormal];
                


                [self.cardView addSubview:buttonI];
                //TODO: animate this
                cardI++;
            }
        }
        [self updateUI];
    }
}

@end
