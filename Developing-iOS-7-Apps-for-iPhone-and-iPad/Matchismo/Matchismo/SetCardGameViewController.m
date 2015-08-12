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
@interface SetCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray*cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *statusTextLabel;

@end
@implementation SetCardGameViewController
@synthesize game=_game;
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
    const NSDictionary *shapes = @{@"ovals":@"●",
                                   @"squiggles":@"▲",
                                   @"diamonds":@"■"};
    const NSDictionary *colors = @{@"red":[UIColor redColor],
                                   @"purple":[UIColor purpleColor],
                                   @"green":[UIColor greenColor]};
    
    for (UIButton *cardButton in self.cardButtons) {
        int cardIndex = (int) [self.cardButtons indexOfObject:cardButton];
        SetCard *card = (SetCard*) [self.game cardAtIndex:cardIndex];
        
        NSAttributedString * shape = [[NSAttributedString alloc]initWithString:shapes[card.shape]];
        
        // Shape
        NSMutableAttributedString* result =
        [[NSMutableAttributedString alloc]initWithAttributedString:shape];
        
        for (int i = 1; i < card.number; i++)
        {
            [result appendAttributedString:shape];
            
        }
        
        // Color
        [result addAttribute:NSForegroundColorAttributeName
                       value:colors[card.color]
                       range:NSMakeRange(0, [result length])];

        
        // Shading
        if ([card.shading isEqualToString:@"outlined"]) {
            [result addAttributes:@{ NSStrokeWidthAttributeName : @5,
                                     NSStrokeColorAttributeName : colors[card.color]}
                            range:NSMakeRange(0, [result length])];
        }
        
        if ([card.shading isEqualToString:@"striped"]) {
            UIColor *tmp = colors[card.color];
            const CGFloat * rgbComp = CGColorGetComponents(tmp.CGColor);
            
            UIColor *shadedColor = [UIColor colorWithRed:rgbComp[0]
                                                   green:rgbComp[1]
                                                    blue:rgbComp[2]
                                                   alpha:0.5];
            
            [result setAttributes:@{ NSForegroundColorAttributeName : shadedColor}
                            range:NSMakeRange(0, [result length])];
        }
        
        [cardButton setAttributedTitle:result forState:UIControlStateNormal];
    }
}
@end
