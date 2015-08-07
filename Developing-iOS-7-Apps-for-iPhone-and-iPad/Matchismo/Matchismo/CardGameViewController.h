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
@class CardMatchingGame;
@interface CardGameVIewController : UIViewController
// protected
// for subclasses
- (Deck *)createDeck; // abstract
- (void)updateUI;
@property (nonatomic, strong) CardMatchingGame *game;
@end

