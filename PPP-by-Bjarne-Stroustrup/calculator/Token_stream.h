//
//  Token_stream.h
//  calculator
//
//  Created by Tsz Chun Lai on 8/20/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __calculator__Token_stream__
#define __calculator__Token_stream__

#include <iostream>
#include "Token.h"
class Token_stream{
public:
    Token_stream();         //construct a Token_stream that reads from cin
    Token get();            //get a Token
    void putback(Token t);  //put a token
    void ignore(char c);
private:
    bool full;
    Token buffer;
};

#endif /* defined(__calculator__Token_stream__) */
