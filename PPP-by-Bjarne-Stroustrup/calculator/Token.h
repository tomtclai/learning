//
//  Token.h
//  calculator
//
//  Created by Tsz Chun Lai on 8/20/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __calculator__Token__
#define __calculator__Token__
#include "std_lib_facilities.h"
#include <iostream>
class Token {
public:
    char kind;              //kinds of token
    double value;           //value for numbers
    string name;            //name of a variable
    Token(char ch)          //construct Token from a char
    :kind(ch), value(0) {}
    Token(char ch, double val)//construct Token from a char & a double
    :kind(ch), value(val) {}
    Token(char ch, string var)//initialize kind and name
    :kind(ch), name(var){}
};
#endif /* defined(__calculator__Token__) */
