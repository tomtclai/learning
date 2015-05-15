//
//  Token_stream.cpp
//  calculator
//
//  Created by Tsz Chun Lai on 8/20/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//
#include "Token.h"
#include "Token_stream.h"
#include "std_lib_facilities.h"
const char number ='8';         //number token
const char print = ';';         //print token
const char quit = 'q';          //quit token
const char let = 'L';           //declaration token
const char name = 'a';          //name token
const string declkey = "let";   //declaration keyword
Token_stream::Token_stream()
:full(false) , buffer(0)
{
}

void Token_stream::putback(Token t)
{
    if (full) error ( "putback() into a full buffer");
    buffer = t;
    full = true;
}

Token Token_stream::get()
{
    if (full) // do we already have a token?
    {
        full = false;
        return buffer;
    }
    
    char ch;
    cin >> ch;
    
    switch (ch) {
            //operator cases
        case print:
        case quit:
        case '(': case ')':
        case '+': case '-':
        case '*': case '/':
        case '=':
            return Token(ch);//each character represents itself
            break;
            
        case '.':   //floating point literal can start with '.'
            //nummeric literal
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
        {
            cin.putback(ch);
            double val;
            cin >> val;
            return Token(number,val);
            break;
        }
        default:
            if(isalpha(ch)){
                string s;
                s += ch;
                //cin's get() reads a character into ch
                while (cin.get(ch) && isalnum(ch))
                    s += ch;
                cin.putback(ch);//put back because it is the first character
                                //that is not alphanumeric, notice the test
                                //have cin.get(ch) before isalnum()
                if ( s == declkey)
                    return Token(let);
                return Token{name,s};
            }
            error("Bad Token");
            break;
    }
    throw runtime_error("");
}
void Token_stream::ignore(char c)
{
    //c represents the kind of token
    // discard any c in buffer
    if(full && c == buffer.kind){
        full = false;
        return;
    }
    full = false;
    
    //discard until the next c:
    char ch = 0;
    while (cin >> ch)
        if(ch == c) return;
}
