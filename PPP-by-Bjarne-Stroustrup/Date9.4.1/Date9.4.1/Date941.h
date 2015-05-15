//
//  Date.h
//  Date9.4.1
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Date9_4_1_Date_h
#define Date9_4_1_Date_h

struct Date {
    class Invalid{};
    const int days_in_a_year = 365;
    const int days_in_a_month = 31;
    const int months_in_a_year = 12;
    void ensure_validity(int d, int m,int y)
    {
        if(d > days_in_a_month ) throw Invalid();
        if( m > months_in_a_year)  throw Invalid();
        if(d < 0 || m < 0 || y < 0)  throw Invalid();
    }
    Date(int mm,int dd,int yy)
    :d{dd},m{mm},y{yy}
    {
        ensure_validity(dd,mm,yy);
    }
    Date()
    {
        Date(01,01,2001);
        ensure_validity(d,m,y);
    }
    Date add_day(int n)
    {
        Date a(this->m,this->d,this->y);
        
        a.d++;
        
        return a;
    }
private:
    int y;
    int m;
    int d;
};

#endif
