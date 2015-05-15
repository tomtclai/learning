
//
//  Card.h
//  Casino
//
//  Created by Tsz Chun Lai on 9/24/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __Casino__Card__
#define __Casino__Card__
#include "Deck.h"
class Card{
public:
    Card();
    ~Card();
private:
    int value;
    Suit suit;
};
#endif /* defined(__Casino__Card__) */
