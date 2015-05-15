//
//  main.cpp
//  User_defined_types
//
//  Created by Tsz Chun Lai on 9/4/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include "chrono.h"
#include "std_lib_facilities.h"
using namespace Chrono;
ostream& operator << ( ostream& os, const Date& d)
{
    return os <<'(' << d.year()
    << ',' << (int) d.month()
    << ',' << d.day() << ')';
}
istream& operator>>(istream& in_stream, Date& date_to_modify)
{
    //The ideal is for an operator>>() not to consume(throw away)
    //any characters that it didn't use, but that's too difficult
    //in this case: we might have read lots of characters before
    //we caught an error.
    int year,month,day;
    char left_parantheses,comma0,comma1,right_parantheses;
    
    in_stream >> left_parantheses >> year
    >> comma0 >> month
    >> comma1 >> day >> right_parantheses;
    if (left_parantheses!= '('
        || comma0!= ','
        || comma1!= ','
        || right_parantheses!=')')
    {
        //if we get here, the format is wrong
        in_stream.clear(ios_base::failbit);
        return in_stream;
    }
    date_to_modify = Date{year,Month(month),day};
    return in_stream;
}
class Any_type{
};

void user(istream &ist)
{
    //we can rarely recover from bad; dont try unless you have to
    //somewhere: make ist throw an execpetion if it goes bad:
    ist.exceptions(ist.exceptions()|ios_base::badbit);
    
}
void std_input_loop(istream &ist)
{
 
    const char terminator = '|';

    for(int var; ist >> var; ){//read until end of file
        //maybe check that var is valid
        //do something with var
    }

    if(ist.fail())
        //if we want to only accept the end of file as the end,
        //we simply delete the test before the call of error.
        //
        //However terminators are very useful when you read files
        //with nested constructs, such as a file of monthly readings
        //containing daily readings, hourly readins, etc. so we'll
        //keep considering the possibility of a terminating character
    {
        ist.clear();
        char ch;
        if(!(ist >> ch && ch == terminator)) {
            error("bad termination of input");
        }
    }
    //carry on because we found the end of file
}
void end_of_loop(istream& ist, char term, const string& error_message)
{
    if(ist.fail()) {
        //use term as terminator and/or separator
        ist.clear();
        char ch;
        if (ist >> ch && ch == term) return;
        error(error_message);
    }
}
void std_input_loop1(istream &ist)
{
    
    const char terminator = '|';
    
    for(int var; ist >> var; ){//read until end of file
                               //maybe check that var is valid
                               //do something with var
    }
    //it is tedious to repeat the terminator test if we read a lot of files
    //we put the terminator test in a function to deal with that
    //we consider that simple and general enough for many purposes
    end_of_loop(ist, terminator, "bad termination of file");
    //carry on because we found the end of file
}

int main()
{
    Date today (1000,Month::apr,30);
    Date tomorrow (1000,Month::may,31);
    
    cout << today;
    //is the same as
    operator<<(cout,today);
    
    cout << endl;
    
    cout << today << tomorrow;
    //is the same as
    operator<<(operator<< (cout,today), tomorrow);
    //is the same as
    operator<<(cout << today, tomorrow);
    //is the same as
    operator<<(cout, today) << tomorrow;
}