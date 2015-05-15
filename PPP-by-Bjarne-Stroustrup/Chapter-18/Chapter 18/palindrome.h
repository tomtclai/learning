//
//  palindrome.h
//  Chapter 18
//
//  Created by Tsz Chun Lai on 12/11/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//
#include <iostream>
#ifndef Chapter_18_palindrome_h
#define Chapter_18_palindrome_h
//using string
bool is_palindrome(const string& s)
{
    int first = 0;
    int last = s.length()-1;
    while (first < last)
    {
        if (s[first]!=s[last])
            return false;
        ++first;
        --last;
    }
    return true;
}
//using arrays
bool is_palindrome(const char s[], int n)
{
    int first = 0;
    int last = n-1;
    while (first < last)
    {
        if(s[first] !=s[last]) return false;
        ++first;
        --last;
    }
    return true;
}

istream& read_word(istream& is, char* buffer, int max)
{
    is.width(max);
    is >> buffer;
    return is;
}
//using pointers
bool is_palindrome(const char* first, const char* last)
{
    while (first < last)
    {
        if (*first!= *last)
            return false;
        ++first;
        --last;
    }
    return true;
}
#endif
