//
//  Date974.h
//  Date
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Date_Date974_h
#define Date_Date974_h
#include <iostream>
class Date{
public:
    enum class Month{
        jan = 1, feb, mar, apr, may, jun ,
        jul, aug, sep, oct, nov, dec};
private:
    int y;
    Month m;
    int d;

public:
    class Invalid{};
    const int days_in_a_year = 365;
    const int days_in_a_month = 31;
    const int months_in_a_year = 12;
    void ensure_validity(int y, Month m,int d)
    {
        if(d > days_in_a_month ) throw Invalid();
        if( (int)m > months_in_a_year)  throw Invalid();
        if(d < 0 || (int)m < 0 || y < 0)  throw Invalid();
    }
    Date(int dd, Month mm, int yy)
    :d{dd}, m{mm}, y{yy}
    {
        ensure_validity(y,m,d);
    }
    //...
    int day() const;
    Month month() const;
    int year() const;
    
    void add_day(int n)
    {
        d += n;
        
//        add_year(d/days_in_a_year);
        d %= days_in_a_year;
        
        add_month(d/days_in_a_month);
        d %= days_in_a_month;
        
    }
    void add_month(int n)
    {
        int m_int = (int) m;
        m_int += n;
        
//        add_year(m_int/months_in_a_year);
        m_int%= months_in_a_year;
        
        m = Month(m_int);
    }
//    void add_year(int n)
//    {
//        y += n;
//    }
//    std::ostream& operator << (std::ostream& os)
//    {
//        return os << '(' << y
//        << ',' << (int) m
//        << ',' << d <<')';
//    }

};
#endif
