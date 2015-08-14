//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/12/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "History.h"
#import "HistoryViewController.h"
@interface SetCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray*cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;


@end
@implementation SetCardGameViewController
@synthesize game=_game;
- (void) viewWillAppear:(BOOL)animated
{
    [self updateUI];
}
- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]
                                                   numOfCardsToPick:3];
    return _game;
}

// override
- (Deck *)createDeck
{
    return [[SetCardDeck alloc]init];
}

// override
- (void)updateUI
{
    

    [super updateUI];
    [self displayCards];
    CardMatchingGame* game =  self.game;
    if (game.result[changeInScoreAbsKey] !=0)
    {
        NSNumber* profit = game.result[lastMoveWasProfitableKey];
        NSArray *cards = game.result[lastSelectedCardsKey];
        NSArray *winningCombo = game.result[winningComboKey];
        
        
        NSNumber* scoreChange = game.result[changeInScoreAbsKey];
        
        if ([profit boolValue])
        {
            NSAttributedString *winningCardsStr = [self attributedStringForCards: winningCombo
                                                                  joinedByString:@" "];
            
            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc]initWithString:@"Matched "];
            
            [labelText appendAttributedString:winningCardsStr];
            
            [labelText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:
                                               [NSString stringWithFormat:@" for %@ points", scoreChange]]];
            self.statusTextLabel.attributedText = labelText;
            [[self log]appendAttributedString:labelText];
            [[self log]appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
            
        } else
        {
            NSAttributedString *cardsStr = [self attributedStringForCards: cards
                                                           joinedByString:@" "];
            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc]initWithAttributedString:cardsStr];
            
            [labelText appendAttributedString:[[NSMutableAttributedString alloc]initWithString:
                                               [NSString stringWithFormat:@" don't match: %@ point penalty", scoreChange]]];
            self.statusTextLabel.attributedText = labelText;
            [[self log]appendAttributedString:labelText];
            [[self log]appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
        }
    }
}

- (void) displayCards {

    
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int) [self.cardButtons indexOfObject:cardButton];
        
        SetCard *card = (SetCard*) [self.game cardAtIndex:cardIndex];

        NSMutableAttributedString* result = [self attributedStringForCard:card];
        
        [cardButton setAttributedTitle:result forState:UIControlStateNormal];

    }
}
- (NSMutableAttributedString *)attributedStringForCard: (SetCard *) card
{
    const NSDictionary *shapesDict = @{@"ovals":@"●",
                                   @"squiggles":@"▲",
                                   @"diamonds":@"■"};
    const NSDictionary *colorsDict = @{@"red":[UIColor redColor],
                                   @"purple":[UIColor purpleColor],
                                   @"green":[UIColor greenColor]};
    NSAttributedString * shape = [[NSAttributedString alloc]initWithString:shapesDict[card.shape]];
    
    // Shape
    NSMutableAttributedString* result =
    [[NSMutableAttributedString alloc]initWithAttributedString:shape];
    
    for (int i = 1; i < card.number; i++)
    {
        [result appendAttributedString:shape];
        
    }
    
    // Color
    [result addAttribute:NSForegroundColorAttributeName
                   value:colorsDict[card.color]
                   range:NSMakeRange(0, [result length])];
    
    
    // Shading
    if ([card.shading isEqualToString:@"outlined"]) {
        [result addAttributes:@{ NSStrokeWidthAttributeName : @5,
                                 NSStrokeColorAttributeName : colorsDict[card.color]}
                        range:NSMakeRange(0, [result length])];
    }
    
    if ([card.shading isEqualToString:@"striped"]) {
        UIColor *tmp = colorsDict[card.color];
        const CGFloat * rgbComp = CGColorGetComponents(tmp.CGColor);
        
        UIColor *shadedColor = [UIColor colorWithRed:rgbComp[0]
                                               green:rgbComp[1]
                                                blue:rgbComp[2]
                                               alpha:0.5];
        
        [result setAttributes:@{ NSForegroundColorAttributeName : shadedColor}
                        range:NSMakeRange(0, [result length])];
    }
    return result;
}
- (NSAttributedString *)attributedStringForCards: (NSArray*) cards
                                  joinedByString: (NSString*) delim
{
    NSMutableAttributedString* result = [[NSMutableAttributedString alloc]init];
    if ([cards[0] isKindOfClass:[SetCard class]]) {
        SetCard* setCard = cards[0];
        [result appendAttributedString:[self attributedStringForCard:setCard]];
    }
    for (int i = 1; i < [cards count]; i++) {
        if ([cards[i] isKindOfClass:[SetCard class]]) {
            SetCard* setCard = cards[i];
            [result appendAttributedString:[[NSAttributedString alloc]initWithString:delim]];
            [result appendAttributedString:[self attributedStringForCard:setCard]];
        }
    }
    return result;
}
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfrontchosen" : @"cardfront"];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showSetCardHistory"]) {
        
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]]) {
            HistoryViewController* hvc = segue.destinationViewController;
            hvc.history = [self log];
        }
    }
}
@end
