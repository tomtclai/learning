//
//  CardGameVIewController.h
//  Matchismo
//
//  Created by Tom Lai on 8/5/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//
//  Abstract class. Must implement methods as described below

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "History.h"
@class CardMatchingGame;
@interface CardGameViewController : UIViewController
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) History * log;
@property (strong, nonatomic) NSString * buttonClass;
// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (void)updateUI;
- (History *) log;
- (IBAction)touchCardButton:(UIButton *)sender;
@property (nonatomic) NSUInteger numCards;//must be set in subclass
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons; // maybe accessed in subclass
@end

