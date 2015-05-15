//
//  Punct_stream.cpp
//  binary files
//
//  Created by Tsz Chun Lai on 9/14/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "Punct_stream.h"
Punct_stream& Punct_stream::operator>>(string& s)
{
    while (!(buffer >> s ))
    {
        if (buffer.bad() || !source.good())
        {
            //handle source states here instead of after getline
            return *this;
        }
        buffer.clear();
        
        //refill buffer
        string line;
        getline(source,line);   //get a line from source
        
        //do character replacement as needed:
        for( char& ch : line)
        {
            if (is_whitespace(ch))
                ch = ' ';   //to space
            else if (!sensitive)
                ch = tolower(ch);    //to lowercase
        }
        buffer.str(line);
    }
    return *this;
}
bool Punct_stream::is_whitespace(char c)
{
    for( char w : white)
        if ( c == w ) return  true;
    return false;
}
Punct_stream::operator bool()
{
    return !(source.fail() || source.bad()) && source.good();
}