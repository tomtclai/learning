//
//  main.cpp
//  Date9.4.1
//
//  Created by Tsz Chun Lai on 9/1/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

//“ For each version define a Date called today initialized to June 25, 1978. Then, define a Date called tomorrow and give it a value by copying today into it and increasing its day by one using add_day(). Finally, output today and tomorrow using a << defined as in §9.8.
//Your check for a valid date may be very simple. Feel free to ignore leap years. However, don’t accept a month that is not in the [1,12] range or day of the month that is not in the [1,31] range. Test each version with at least one invalid date (e.g., 2004, 13, –5).”
//
//Excerpt From: Bjarne Stroustrup. “Programming: Principles and Practice Using C++ (2nd Edition).” iBooks. https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewBook?id=1BFCF52B9673964402238C93ACA88C94
#include <iostream>
#include "Date974.h"
std::ostream& operator <<  (std:: ostream& os,  Date::Month& m)
{
    return os << (int) m;
}
std::ostream& operator << (std::ostream& os, Date& d)
{
    return os <<'(' << d.year()
    <<',' << d.month()
    <<',' << d.day() << ')';
}
int main(int argc, const char * argv[]) {
    Date today(25, Date::Month(6), 1978);
    today.add_day(1);
    std::cout << today;
//    Date tomorrow = today;
    Date invalid(15,Date::Month(-5),2004);
}
