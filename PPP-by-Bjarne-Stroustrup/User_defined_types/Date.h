//
//  Date.h
//  User_defined_types
//
//  Created by Tsz Chun Lai on 8/28/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef User_defined_types_Date_h
#define User_defined_types_Date_h
#include "Year.h"
class Date{
public:
    //to be used as exception
    class Invalid {};
    
    //check for valid date and initilize
    Date(Year y, Month m, int d);
    //construct default date
    Date& default_date(){static Date dd(Year(2001),Date::Jan,1); return dd;}
    //return default date
    Date();
    //add n days to a date
    void add_day(int n);
    void add_month(int n);
    void add_year(int n);
    
    Date::Month month() const {return m;}
    int day() const {return d;}
    Year year() const {return y;}
private:
    Year y;  //year
    Date::Month m;  //month in a year
    int d;  //day of month
    bool check();

};

#endif
