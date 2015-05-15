//
//  Date943.h
//  Date
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Date_Date943_h
#define Date_Date943_h
enum class Month{
    jan = 1, feb, mar, apr, may, jun ,
    jul, aug, sep, oct, nov, dec};
class Day{
public:
    Day(int d):d{d} {
    }
    bool operator < (int a){
        return d < a;
    }
    bool operator > (int a){
        return d > a;
    }
    int d;
};
class Year{
public:
    Year(int y):y{y}{
    }
    bool operator < (int a){
        return y < a;
    }
    bool operator > (int a){
        return y > a;
    }
private:
    int y;
};
//simple Date(use Month)
class Date {
public:
    class Invalid{};
    const int days_in_a_year = 365;
    const int days_in_a_month = 31;
    const int months_in_a_year = 12;
    void ensure_validity(Year y, Month m,Day d)
    {
        if(d > days_in_a_month ) throw Invalid();
        if( (int)m > months_in_a_year)  throw Invalid();
        if(d < 0 || (int)m < 0 || y < 0)  throw Invalid();
    }
    Date(Day d, Month m, Year y) // check for valid day and initialize
    :dd{d}, mm{m}, yy{y}
    {
        ensure_validity(y,m,d);
    }
    void add_day(int n)
    {
        dd.d += n;
    }
private:
    Year yy;
    Month mm;
    Day dd;
};

#endif
