//
//  Year.h
//  Reading a strcutured file
//
//  Created by Tsz Chun Lai on 9/6/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//
//  represent a year as a vector of 12 Months
//  a Month as a vector of about 30 Days
//  a Day as 24 temperatures( one per hour)
// {year 1990}
// {year 1991 {month jun}}
// {year 1992 {month jan ( 1 0 61.5 )} { month feb (1 1 64) (2 2 65.2)}}
// {year 2000
//      {month feb (1 1 68) (2 3 66.66) ( 1 0 67.2)}
//      {month dec (15 15 -9.2) (15 14 -8.8) (14 0 -2)}
// }

#ifndef __Reading_a_strcutured_file__Year__
#define __Reading_a_strcutured_file__Year__

#include <iostream>
#include <stdlib.h>
#include <vector>
#include "std_lib_facilities.h"
using namespace std;

vector<string> month_input_tbl {
    "jan", "feb", "mar", "apr", "may", "jun", "jul",
    "aug", "sep", "oct", "nov", "dec"
};
vector<string> month_print_tbl {
    "January", "February", "March", "April", "May",
    "June", "August", "September", "October",
    "November", "December"
};
const int not_a_reading = -7777; // less than absolute zero
const int not_a_month = -1;
/*----------------------------------------------------------------------------*/
//  declarations

/* Magic constant alert */
struct Day {
    //a Day has 24 hours , each initialized to not a reading
    
    vector<double> hour {vector<double> (24, not_a_reading)};
    //    is the same as
    //    vector<double> hour0 = vector<double> (24, not_a_reading);
    //    is not the same as
    //    vector<double> hour1 {24, not_a_reading};


};

struct Month {              //a month of temperature readings
    int month{not_a_month}; //[0:11] January is 0
    vector<Day> day {32};   //[1:31] one vector of readings per day, one based.
    
};

struct Year {               //a year of temperature readings
    int year;               //positive == A.D.
    vector<Month> month{12};//[0:11] january is 0
};

struct Reading {
    int day;
    int hour;
    double temperature;
};
/*----------------------------------------------------------------------------*/
//  input operations

//read a temperature reading formatted ( 3 4 9.7 ) from is into r
//check format only
istream& operator>> (istream& is, Reading& r)
{
    char ch0;
    if( is >> ch0 && ch0!='(') {
        //if we get here the format was wrong
        is.unget();
        is.clear(ios_base::failbit);//because input has failed
        return is;
    }
    char ch1;
    int day, hour;
    double temperature;
    is >> day >> hour >> temperature >> ch1;
    //test for the last parentheses
    if ( !is || ch1 != ')') error("bad reading");
    r.day = day;
    r.hour = hour;
    r.temperature = temperature;
    return is;
}
//helper functions for the function below

//converts symbolic notation (e.g. jun) to a number in the [0:11] range
int month_to_int(const string& a)
{
    for(int i = 0; i < 12; ++i) if (month_input_tbl[i]==a) return i;
    return -1;
    
};
//converts integer months[0:11] to string months (e.g. August)
string int_to_month(const int i)
{
    if(i<0 || i >= 12) error("bad month index");
    return month_print_tbl[i];
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
constexpr int implausible_min = -200;
constexpr int implausiple_max = 200;
bool is_valid(const Reading& r)
{
    if(r.day < 1 || r.day > 31) return false;
    if(r.hour < 0 || r.hour > 23) return false;
    if(r.temperature< implausible_min || r.temperature < implausiple_max)
        return false;
    return true;
}
//read a month from is into m
//format: {month feb ....}
istream& operator>>(istream& is, Month& m)
{
    char ch = 0;
    if( is >> ch && ch != '{') {
        //if we get here the format was wrong
        is.unget();
        //clear current state and put in failbit
        is.clear(ios_base::failbit);
        return is;
    }
    //after "{" there should be the word "month"
    string month_marker;
    //then a symbol for a month, e.g. "feb"
    string mm;
    is >> month_marker >> mm ;
    if (!(is && month_marker=="month")) error("bad start of month");
    m.month = month_to_int(mm);
    int duplicates = 0;
    int invalids = 0;
    for (Reading r; is >> r;)
    {
        if(is_valid(r)) {
            if(m.day[r.day].hour[r.hour]!= not_a_reading)
            {
                //There should not be more than one reading
                //at this hour in this day in this month
                ++duplicates;
            }
            m.day[r.day].hour[r.hour] = r.temperature;
        }
        else
            ++invalids;
    }
    if(invalids) error("invalid readings in month", invalids);
    if(duplicates) error("duplicate readings in month", duplicates);
    end_of_loop(is,'}',"bad end of month");
    return is;
    
}
//read a year from is into y
//format: {year 1972 ...}
istream& operator>> (istream& is, Year& y)
{
    char ch;
    is >> ch;
    if(ch != '{'){
        is.unget();
        is.clear(ios::failbit);
        return is;
    }
    
    string year_maker;
    int yy;
    is >> year_maker >> yy;
    if(!is || year_maker !="year") error("bad start of year");


    for(Month m; is >> m;)
    {
        y.month[m.month] = m;
        m = Month{};//reinitialize m? why not put it in the head of this loop
        if(!(is>>m)) break;
    }
    
    end_of_loop(is, '}', "bad end of year");
    return is;

}
/*----------------------------------------------------------------------------*/
//  output functions


//output readings in all 24 hours given a day
ostream& operator << (ostream &ofs, Day d)
{
    for(int i; i < d.hour.size(); i++)
        ofs << d.hour[i] << ' ';
    return ofs;
}
//output readings in all 31 days given a month
ostream& operator << (ostream &ofs, Month m)
{
    
    for(int i; i < m.day.size(); i++)
        ofs << m.day[i] << ' ' ;
    return ofs;
}
//output readings in all 12 months given a year
ostream& operator << (ostream &ofs, Year y)
{
    for(int i; i < y.month.size(); i++)
        ofs << y.month[i] << ' ' ;
    return ofs;
}


#endif /* defined(__Reading_a_strcutured_file__Year__) */
