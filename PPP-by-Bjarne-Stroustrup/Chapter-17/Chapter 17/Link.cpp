//
//  Link.cpp
//  Chapter 17
//
//  Created by Tsz Chun Lai on 11/15/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "Link.h"
Link* Link::insert(Link *n)
{
    if (n == nullptr) return this;
    if (this == nullptr) return n;
    n-> succ = this;//n links to p
    if (prev)
        prev->succ = n; //p's previos node now link to n
    n->prev = prev;//n links back to p's previous node
    prev = n;//p links back to n
    return n;
}