

//
//  Deck.h
//  Casino
//
//  Created by Tsz Chun Lai on 9/24/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __Casino__Deck__
#define __Casino__Deck__
enum Suit {Diamond, Spade, Heart, Club};
#include <stdio.h>
#include "Card.h"
#include "Hand.h"
class Deck
{
public:
    Deck();
    Card DealSingleCard();
    
    bool isEmpty();
    bool isComplete();
    void Shuffle();
    void Cut();
    
    int CountRemainingCards();
    
    void ReturnHand(Hand theHand);
    void ReturnCard(Card theCard);
    
    int CountValueRemaining(int val);
    int CountSuitsRemaining(Suit suit);
private:
    Card deck[52];
};
#endif /* defined(__Casino__Deck__) */
