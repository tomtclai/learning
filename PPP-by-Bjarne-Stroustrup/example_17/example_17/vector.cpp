//
//  vector.cpp
//  example_17
//
//  Created by Tsz Chun Lai on 9/18/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "vector.h"
vector::vector(int s)                           //constructor
:sz{s},                                         //initialize sz
elem{new double[s]}                             //initialize elem
{
    for (int i = 0 ; i < s; ++ i) elem[i] = 0;  //initialize elements
}
vector::~vector()                               //destructor
{
    delete[] elem;                              //free memory
}
int vector::size() const
{
    return sz;
}