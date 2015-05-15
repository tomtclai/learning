//
//  Hand.h
//  Casino
//
//  Created by Tsz Chun Lai on 9/24/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __Casino__Hand__
#define __Casino__Hand__
const int CARDS_IN_LARGEST_HAND = 7 ;
#include <stdio.h>
#include "Card.h"
class Hand {
public:
    Hand();
    ~Hand();
private:
    Card hand[CARDS_IN_LARGEST_HAND];
};
#endif /* defined(__Casino__Hand__) */
