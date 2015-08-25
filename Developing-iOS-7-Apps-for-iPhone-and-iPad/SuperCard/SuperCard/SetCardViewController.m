//
//  SetCardViewController.m
//  SuperCard
//
//  Created by Tom Lai on 8/21/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCardViewController.h"
#import "SetCardDeck.h"
#import "SetCardButton.h"
#import "SetCard.h"
@interface SetCardViewController ()
@property (weak, nonatomic) IBOutlet SetCardButton *setCardButton;
@property (strong,nonatomic) Deck *deck;
@end

@implementation SetCardViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[SetCardDeck alloc] init];
    return _deck;
}

- (void)drawRandomSetCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        self.setCardButton.shading = setCard.shading;
        self.setCardButton.color = setCard.color;
        self.setCardButton.symbol = setCard.shape;
        self.setCardButton.number = setCard.number;
        self.setCardButton.chosen = setCard.chosen;
        //assign card
    }
}

- (void)drawSetCard
{
    
}

- (IBAction)touchCard:(SetCardButton *)sender {
    [self drawRandomSetCard];
}

- (void)viewDidLoad {
    [self drawRandomSetCard];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
