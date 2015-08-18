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
// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (void)updateUI;
- (History *) log;
@property (nonatomic) NSUInteger numCards;//must be set in subclass
@end

