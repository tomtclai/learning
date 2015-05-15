//
//  Date942.h
//  Date
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Date_Date942_h
#define Date_Date942_h

struct Date{
    class Invalid{};
    const int days_in_a_year = 365;
    const int days_in_a_month = 31;
    const int months_in_a_year = 12;
    void ensure_validity(int y, int m,int d)
    {
        if(d > days_in_a_month ) throw Invalid();
        if( m > months_in_a_year)  throw Invalid();
        if(d < 0 || m < 0 || y < 0)  throw Invalid();
    }
    Date(int m, int d, int y)  //check for valid date and initialize
    :y{y},m{m},d{d}
    {
        ensure_validity(y,m,d);
    }
    void add_day(int n)        //increase the Date by n days
    {
        if(n > days_in_a_year)
        {
            y = n / days_in_a_year;
            n %= days_in_a_year;
        }
        if(n > days_in_a_month)
        {
            m = n / days_in_a_month;
            n %= days_in_a_month;
        }
        d += n;
        
    }
private:
    int y,m,d;                  //year month day

};
#endif
