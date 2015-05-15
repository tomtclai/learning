//
//  Date.cpp
//  User_defined_types
//
//  Created by Tsz Chun Lai on 8/28/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "Date.h"
#include "std_lib_facilities.h"
#include "Year.h"

Date::Month operator++(Date::Month& m)
{
    m = (m==Date::Dec)? Date::Jan : Date::Month(m+1);
    //m becomes Jan if it is currently Dec because the months
    //wrap around after december
    return m;
}
Date::Month operator--(Date::Month& m)
{
    m = (m==Date::Jan)? Date::Dec : Date::Month(m-1);
    //m becomes Dec if it is currently Jan because the months
    //wrap around after janurary
    return m;
}
enum Day {
    //monday == 0 and sunday == 6
    monday, tuesday, wednesday, thursday,
    friday, saturday, sunday
};

Date::Date(Year yy, Date::Month mm, int dd)
:y(yy), m(mm), d(dd)
{
    if (!check()) throw Invalid();
}
Date::Date()
:y(default_date().year()),
m(default_date().month()),
d(default_date().day())
{

}
Date::Month to_month(int x)
{
    if ( x < Date::Jan || Date::Dec < x)
        error("bad month");
    return Date::Month(x);
}
void f (int m )
{
    Date::Month mm = to_month(m);
    //...
}
enum Traffic_sign { red, yellow, green};
int var = red;  //note, not Traffic_sign::red
bool Date::check()
{
    if (m < 1 || 12 < m) return false;
    return true;
}

void Date::add_day(int n)
{
    
}

vector<string> month_tbl;
//pre: month_tbl has been initilized so that month_tbl[Mar] is "March" or some other suitable name for that month
//post: output the representation of that month to ostream
ostream& operator << ( ostream& os, Date::Month m)
{
    return  os << month_tbl[m];
}