//
//  ViewController.m
//  SuperCard
//
//  Created by Tom Lai on 8/13/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardButton.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
@interface PlayingCardViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardButton *playingCardButton;
@property (strong,nonatomic) Deck *deck;
@end

@implementation PlayingCardViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        self.playingCardButton.rank = playingCard.rank;
        self.playingCardButton.suit = playingCard.suit;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playingCardButton.suit = @"♥️";
    self.playingCardButton.rank = 13;
    [self.playingCardButton addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.playingCardButton
                                                                                       action:@selector(pinch:)]];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    if (!self.playingCardButton.faceUp) [self drawRandomPlayingCard];
    self.playingCardButton.faceUp = !self.playingCardButton.faceUp;
}


@end
