//
//  Chrono.h
//  User_defined_types
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef User_defined_types_Chrono_h
#define User_defined_types_Chrono_h

#include "std_lib_facilities.h"
namespace Chrono {
    enum class Month {
        //compiler give the months consecutive values
        //starting with 1
        jan = 1, feb, mar, apr, may, jun,
        jul, aug, sep, oct, nov, dec
        //Use month like this
        //Month m = feb;
        //int n = m;          //get numeric value of a month
        //Month mm = Month(7) //convert int to month
    };
    class Date{
    public:
        //to be used as exception
        class Invalid {};
        
        //check for valid date and initilize
        Date(int y, Month m, int d);
        //construct default date
        //return default date
        Date();
        
        Month month() const {return m;}
        int day() const {return d;}
        int year() const {return y;}
        
        //add n days to a date
        void add_day(int n);
        void add_month(int n);
        void add_year(int n);
    private:
        int y;  //year
        Month m;  //month in a year
        int d;  //day of month
        bool check();
    

    };
    
    bool is_date(int y, Month m, int d);
    bool leapyear(int y );
    bool operator == (const Date&a, const Date&b);
    bool operator !=(const Date&a, const Date&b);
    
//    ostream& operator << (ostream& os, const Date&d);
//    istream& operator >> (istream& is, Date & dd);
}

#endif
