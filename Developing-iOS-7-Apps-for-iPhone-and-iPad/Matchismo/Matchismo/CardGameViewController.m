//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Martin Mandl on 02.11.13.
//  Copyright (c) 2013 m2m server software gmbh. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import "GameSettings.h"
#import "Grid.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) GameResult *gameResult;
@property (strong, nonatomic) GameSettings *gameSettings;

@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (weak, nonatomic) IBOutlet UIView *gridView;

@property (weak, nonatomic) IBOutlet UIButton *addCardsButton;
@property (strong, nonatomic) UIDynamicAnimator *pileAnimator;
@end

@implementation CardGameViewController
#define ANIMATION_SPEED 0.3
- (NSMutableArray *)cardViews
{
    if (!_cardViews) _cardViews = [NSMutableArray arrayWithCapacity:self.numberOfStartingCards];
    return _cardViews;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        self.pileAnimator = nil;
        self.grid.size = self.gridView.bounds.size;
        [self updateUI];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (Grid *)grid
{
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.cellAspectRatio = self.maxCardSize.width / self.maxCardSize.height;
        _grid.minimumNumberOfCells = self.numberOfStartingCards;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    return _grid;
}

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    _gameResult.gameType = self.gameType;
    return _gameResult;
}

- (GameSettings *)gameSettings
{
    if (!_gameSettings) _gameSettings = [[GameSettings alloc] init];
    return _gameSettings;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfStartingCards
                                                  usingDeck:[self createDeck]];
        _game.matchBonus = self.gameSettings.matchBonus;
        _game.mismatchPenalty = self.gameSettings.mismatchPenalty;
        _game.flipCost = self.gameSettings.flipCost;
    }
    return _game;
}

- (Deck *)createDeck // abstract
{
    return nil;
}

// Make sure there are no old card view on screen
- (IBAction)touchDealButton:(UIButton *)sender {
    self.pileAnimator = nil;
    NSUInteger changedViews = 0;
    for (UIView *subView in self.cardViews) {
        [UIView animateWithDuration: ANIMATION_SPEED
                              delay:self.animationDelayBetweenCards * changedViews++ / [self.cardViews count]
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             subView.frame = CGRectMake(subView.frame.origin.x,
                                                        self.gridView.frame.size.height + self.grid.cellSize.height,
                                                        self.grid.cellSize.width * 1,
                                                        self.grid.cellSize.height * 1);
                         } completion:^(BOOL finished) {
                             [subView removeFromSuperview];
                         }];
    }
    self.game = nil;
    self.gameResult = nil;
    self.cardViews = nil;
    self.grid = nil;
    self.addCardsButton.enabled = YES;
    self.addCardsButton.alpha = 1.0;

    [self updateUI];
}
// When the button is touched add 3 cards to the game (in the tag)
// if the deck is empty afterwards, disable the button
- (IBAction)touchAddCardsButton:(UIButton *)sender {
    self.pileAnimator = nil;
    for (int i = 0; i < sender.tag; i++) {
        [self.game drawNewCard];
    }
    
    if (self.game.deckIsEmpty) {
        sender.enabled = NO;
        sender.alpha = 0.5;
    }
    
    [self updateUI];
}
- (UIView *)createViewForCard:(Card *)card
{
    UIView *view = [[UIView alloc] init];
    [self updateView:view forCard:card];
    return view;
}

- (void)updateView:(UIView *)view forCard:(Card *)card
{
    view.backgroundColor = [UIColor blueColor];
}

- (void)touchCard:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self updateUI];
        [self.game chooseCardAtIndex:gesture.view.tag];
        Card *card = [self.game cardAtIndex:gesture.view.tag];
        if (!card.matched && !self.pileAnimator)
        {
            [UIView transitionWithView:gesture.view
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            card.chosen = !card.chosen;
                            [self.game chooseCardAtIndex:gesture.view.tag];
                        } completion:^(BOOL finished) {
                            card.chosen = !card.chosen;
                            [self.game chooseCardAtIndex:gesture.view.tag];
                            [self updateUI];
                        }];
        } else {
            self.pileAnimator = nil;
            [[self.game cardAtIndex:gesture.view.tag] setChosen:NO];
        }
    }
}

#define RESISTANCE_TO_PILING 40.0

- (IBAction)gatherCardsIntoPile:(UIPinchGestureRecognizer *)gesture {
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint center = [gesture locationInView:self.gridView];
    
    
        if (!self.pileAnimator) {
            self.pileAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.gridView];
            UIDynamicItemBehavior *item = [[UIDynamicItemBehavior alloc] initWithItems:self.cardViews];
            
            item.resistance = RESISTANCE_TO_PILING;
            [self.pileAnimator addBehavior:item];
            
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:center];
                [self.pileAnimator addBehavior:snap];
            }
        }
    }
}

- (IBAction)panPile:(UIPanGestureRecognizer *)gesture {
    if (self.pileAnimator) {
        CGPoint gesturePoint = [gesture locationInView:self.gridView];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            for (UIView *cardView in self.cardViews) {
                UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:gesturePoint];
                [self.pileAnimator addBehavior:attachment];
            }
            for (UIDynamicBehavior *behavior in self.pileAnimator.behaviors) {
                if ([behavior isKindOfClass:[UISnapBehavior class]]) {
                    [self.pileAnimator removeBehavior:behavior];
                }
            }
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            for (UIDynamicBehavior *behavior in self.pileAnimator.behaviors) {
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
                    ((UIAttachmentBehavior *)behavior).anchorPoint = gesturePoint;
                }
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            for (UIDynamicBehavior *behavior in self.pileAnimator.behaviors) {
                if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
                    [self.pileAnimator removeBehavior:behavior];
                }
            }
            for (UIView *cardView in self.cardViews) {
                UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:cardView snapToPoint:gesturePoint];
                [self.pileAnimator addBehavior:snap];
            }
        }
    }
}
#define CARDSPACINGINPERCENT 0.08

- (void)updateUI
{
    for (NSUInteger cardIndex = 0;
         cardIndex < self.game.numberOfDealtCards;
         cardIndex++) {
        Card *card = [self.game cardAtIndex:cardIndex];
        
        NSUInteger viewIndex = [self.cardViews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[UIView class]]) {
                if (((UIView *)obj).tag == cardIndex) return YES;
            }
            return NO;
        }];
        UIView *cardView;
        if (viewIndex == NSNotFound) {
            if (!card.matched) {
                cardView = [self createViewForCard:card];
                cardView.tag = cardIndex;
                
                cardView.frame = CGRectMake((self.gridView.bounds.size.width /2.0 - self.grid.cellSize.width) ,
                                            (self.gridView.bounds.size.height - self.grid.cellSize.height),
                                            self.grid.cellSize.width* 2.0,
                                            self.grid.cellSize.height* 2.0);

                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(touchCard:)];
                [cardView addGestureRecognizer:tap];
                [self.cardViews addObject:cardView];
                viewIndex = [self.cardViews indexOfObject:cardView];
                [self.gridView addSubview:cardView];
            }
        } else {
            cardView = self.cardViews[viewIndex];
            if (!card.matched) {
                [self updateView:cardView forCard:card];
            } else {
                if (self.removeMatchingCards) {
                    [self.cardViews removeObject:cardView];
                    [UIView animateWithDuration:ANIMATION_SPEED
                                     animations:^{
                                         cardView.frame = CGRectMake(0.0,
                                                                     self.gridView.bounds.size.height,
                                                                     self.grid.cellSize.width,
                                                                     self.grid.cellSize.height);
                                         cardView.alpha = 0.0;
                                     } completion:^(BOOL finished) {
                                         [cardView removeFromSuperview];
                                     }];
                } else {
                    cardView.alpha = card.matched? 0.6 : 1.0;
                }
            }
        }
    }
    self.grid.minimumNumberOfCells = [self.cardViews count];
    
        NSUInteger changedViews = 0;
        for (NSUInteger viewIndex = 0; viewIndex < [self.cardViews count]; viewIndex++)
        {
            CGRect frame = [self.grid frameOfCellAtRow:viewIndex / self.grid.columnCount
                                              inColumn:viewIndex % self.grid.columnCount];
            frame = CGRectInset(frame, frame.size.width * CARDSPACINGINPERCENT, frame.size.height * CARDSPACINGINPERCENT);
            
            UIView *cardView = (UIView *)self.cardViews[viewIndex];
            if (![self frame:frame equalToFrame:cardView.frame]) {
                [UIView animateWithDuration:ANIMATION_SPEED
                                      delay:self.animationDelayBetweenCards * changedViews++ / [self.cardViews count]
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     cardView.frame = frame;
                                     cardView.alpha = 1.0;
                                 } completion: NULL];
            }
        }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.gameResult.score = self.game.score;
}

#define FRAMEROUNDINGERROR 0.01

- (BOOL)frame:(CGRect)frame1 equalToFrame:(CGRect)frame2
{
    if (fabs(frame1.size.width - frame2.size.width) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.size.height - frame2.size.height) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.x - frame2.origin.x) > FRAMEROUNDINGERROR) return NO;
    if (fabs(frame1.origin.y - frame2.origin.y) > FRAMEROUNDINGERROR) return NO;
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.game.matchBonus = self.gameSettings.matchBonus;
    self.game.mismatchPenalty = self.gameSettings.mismatchPenalty;
    self.game.flipCost = self.gameSettings.flipCost;
}

- (void)viewWillLayoutSubviews
{
    self.grid.size = self.gridView.bounds.size;
    [self updateUI];
}

@end
