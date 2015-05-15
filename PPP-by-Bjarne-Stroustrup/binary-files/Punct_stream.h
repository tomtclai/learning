//
//  Punct_stream.h
//  binary files
//
//  Created by Tsz Chun Lai on 9/14/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __binary_files__Punct_stream__
#define __binary_files__Punct_stream__

#include "std_lib_facilities.h"
class Punct_stream {
    //like an istream, but the user can add to the set of whitespace
    //characters
public:
    Punct_stream(istream& is)
    :source{is}, sensitive{true} {}
    
    void whitespace(const string& s)
    {
        white = s;
    }
    void add_white(char c) {white += c;}
    bool is_whitespace(char c);
    void case_sensitive(bool b) {sensitive = b;}
    bool is_case_sensitive (){ return sensitive;}
    Punct_stream& operator>>(string&s);
    operator bool();
private:
    istream& source;
    istringstream buffer;
    string white;
    bool sensitive;
};
//usage:
//Punct_stream ps {cin};
//ps.whitespace(";:/"); // semicolo, colo, and dot are also whitespace
//ps.case_sesnsitive(false);


#endif /* defined(__binary_files__Punct_stream__) */
