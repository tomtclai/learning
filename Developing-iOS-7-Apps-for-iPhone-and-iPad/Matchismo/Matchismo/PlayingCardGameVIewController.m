//
//  PlayingCardGameVIewController.m
//  Matchismo
//
//  Created by Tom Lai on 8/6/15.
//  Copyright (c) 2015 Lai. All rights reserved.
//

#import "PlayingCardGameVIewController.h"
#import "PlayingCardDeck.h"
@implementation PlayingCardGameVIewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
@end
