//
//  Chrono.cpp
//  User_defined_types
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <stdio.h>
#include "Chrono.h"
namespace Chrono{
    Date::Date(int yy, Month mm, int dd)
    : y{yy}, m{mm}, d{dd}
    {
        if(!is_date(yy,mm,dd)) throw Invalid{};
    }
    
    const Date& default_date()
    {
        static Date start_of_21st_century {2001, Month::jan, 1};
        return start_of_21st_century;
    }
    Date::Date()
    :y{default_date().year()},
    m{default_date().month()},
    d{default_date().day()}
    {
    }
    
    void Date::add_day(int n)
    {
        //...
    }
    
    void Date::add_month(int n)
    {
        //...
    }
    
    void Date::add_year(int n)
    {
        if(m==Month::feb && d == 29 && !leapyear(y+n)) {
            //this is a leap year
            m = Month::mar;
            d = 1;
        } else if (m==Month::mar && d ==1 && leapyear(y+n))
        {
            m = Month::feb;
            d = 29;
        }
        y += n;
    }
    
    //helper functions
    bool is_date(int y, Month m, int d)
    {
        //assume that y is valid
        if (d <= 0 ) return false;
        if ( m<Month::jan || Month:: dec < m) return false;
        int days_in_month =31; //mostly
        switch (m) {
            case Month::feb:
                days_in_month = (leapyear(y))? 29: 28;
                break;
            case Month::apr: case Month::jun:
            case Month::sep: case Month::nov:
                days_in_month = 30;
                break;
                
            default:
                break;
        }
        if (days_in_month<d) return false;
        return true;
    }
    
    bool leapyear(int y)
    {
        //...
        return false;
    }
    bool operator==(const Date&a, const Date&b)
    {
        return a.year() == b.year()
        && a.month() == b.month()
        && a.day() == b.day();
    }
    
    bool operator!= (const Date&a, const Date&b)
    {
        return !(a==b);
    }
    
//    ostream& operator << (ostream& os, const Date&d)
//    {
//        return os << '(' << d.year()
//                  << ',' << (int) d.month()
//                  << ',' << d.day() <<')';
//    }
//    
//    istream& operator >> (istream& is, Date& dd)
//    {
//        int y,m,d;
//        char c1,c2,c3,c4;
//        is >> c1 >> y >> c2 >> m >> c3 >>d >>c4;
//        if(!is) return is;
//        if(c1 != '(' || c2 !=',' || c3 != ',' || c4 != ')' )
//        {
//            is.clear(ios_base::failbit);
//            return is;
//        }
//        
//        dd = Date(y, Month(m), d);
//        
//        return is;
//    }
    enum class Day{
        sunday, monday, tuesday, wednesday, thursday, friday, saturday
    };
    
//    Day day_of_week(const Date& d)
//    {
//        //...
//    }
//    Day next_Sunday (const Date& d)
//    {
//        //...
//    }
//    Day next_weekday (const Date& d)
//    {
//        //...
//    }
}