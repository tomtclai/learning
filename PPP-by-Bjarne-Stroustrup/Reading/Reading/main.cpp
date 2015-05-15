//
//  main.cpp
//  Reading
//
//  Created by Tsz Chun Lai on 9/2/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include "Reading.h"
#include <stdlib.h>
#include <vector>
#include <fstream>
#include "std_lib_facilities.h"
using namespace std;
ifstream get_ifstream()
{
    cout << "Please enter input file name: ";
    string iname;
    cin >> iname;
    ifstream ist {iname};
    if ( !ist) error ("can't open input file", iname);
    return ist;
}
ofstream get_ofstream()
{
    string oname;
    cout << "Please enter name of output file: ";
    cin >> oname;
    ofstream ost {oname};
    if(!ost) error("can't open output file", oname);
    return ost;
}
void cin_error_handle(istream& in)
{
    
    char terminator = '*';
//    if(cin.bad()) {
//        //the stream has corrupted
//        //this is already handled in caller.
//        //in.exceptions(in.exceptions()|ios_base::badbit);
//    }
    if(cin.eof())
    {
        //there is no more input so exit
        return;
    }
    if(cin.fail())
    {
        //stream encountered something unexpected
        
        cin.clear(); //get out of the fail() state
        //look at characters again, attempt to recover
        char c;
        in >> c;
        if ( c != terminator)
        {
            //this is not an error that we can handle
            //so put it back
            in.unget();
            //go back into the fail() state
            in.clear(ios_base::failbit);
        }
    }
}
void file_example()
{
    //get input file
    ifstream ist = get_ifstream();
    //get output file
    ofstream ost = get_ofstream();
    
    vector<Reading> temps;
    int hour;
    double temperature;
    while(ist >> hour >> temperature){
        if(hour < 0 || hour > 23) error("hour out of range");
        temps.push_back(Reading{hour,temperature});
    }
    
    for(int i = 0; i < temps.size(); ++i)
        ost << '(' << temps[i].hour << ','
        << temps[i].temperature << ")\n";
    
    int i = 0;
    cin >> i;
    if(!cin) {
        //"cin is not good"
        //The state of cin is not good()
        //an input operation has failed
        cin_error_handle(cin);
    }

}
void read_single_value()
{
    cout << "Please enter an integer in the range 1 to 10 inclusive :\n";
    int n = 0 ;
    while ( cin >> n)                   //read
    {
        if( 1 <= n && n <= 10 ) break;  //check range
        cout << "Sorry " << n
             << " is not in the [1:10] range; please try again\n";
    }
}

int main(int argc, const char * argv[]) {
    
}
void skip_to_int()
{
    if(cin.fail()) {
        //got a non integer
        cin.clear();
        for ( char ch; cin >> ch;)
        {//throw away non-digits
            if(isdigit(ch) || ch == '-')
            {
                cin.unget(); //put the digit back
                             //to read the number
                return;
            }
        }
    }
    error("no input");
}

void handle_both_error()
//This is messy and not recommended
{
    cout << "Please enter an integer in the range 1 to 10 inclusive:\n";
    int n = 0;
    while (true)
    {
        cin >> n;
        if ( cin ) {
            //got an integer, now test the range
            if( 1 <= n && n <= 10) break;
            cout << "sorry "<< n
            << "is not in the [1:10] range; please try again \n";
            
        }
        else if (cin.fail())
        {
            //got a non-integer
            //set state back to good to look at characters
            cin.clear();
            cout << "Sorry that was not a number, please try again\n";
            for(char ch; cin >> ch && !isdigit(ch);){} // throw away non digits
            if (!cin) error("no inpit");
            cin.unget(); //put the digit back for reading
        }
        else
        {
            error("no inpit");
        }
    }
    //if we get here n is in [1:10]
}
void cleaner_error_handling()
{
    cout << "please enter an interger in the range 1 to 10 inclusive.";
    int n = 0;
    while (true) {
        if (cin >> n ) {
            if (1 <= n && n <= 10 ) break;
            cout << "Sorry" << n
            << "is not in the [1:10] range; please try again\n";
        }
        else {
            cout << "Sorry, that was not a number, please try again\n";
            skip_to_int();
        }
    }
}
//stubborly keeps reading until it finds some digits that it can interpret as an integer
int get_int(){
    int n = 0;
    while(true)
    {
        if(cin >> n) return n;
        //if we get here the character isn't an int
        cout << "Sorry, that was not a number; please try again\n";
        skip_to_int();
    }
}
int get_int(int low, int high)
{
    cout << "Please enter an integer in the range"
    << low << " to " << high << " (inclusive): \n";
    while (true)
    {
        int n = get_int();
        if (low <= n && high >= n) return n;
        cout << "Sorry"
        << n << "is not in the [" << low << ':' << high
        << "] range; please try again\n";
    }
}
void cleaner_error_handling_1(){
    int n = get_int(1,10);
    cout << "n: " << n << '\n';
}
int get_int1 (int low, int high, const string& greeting, const string& try_again)
{
    cout << greeting << ":[" << low << ':' << "]\n";
    while (true)
    {
        int n = get_int();
        if (low <= n && high >= n) return n;
        cout << try_again << low << ':' << high << "]\n";
    }
}
void cleaner_error_handling_2(){
    int strength = get_int1(1,10,"enter stringth", "Not in range, try again");
    cout << "strength: " << strength << '\n';
    int altitude = get_int1(1,10,"enter strength", "Not in range, try again");
    cout << "altitude: " << altitude << "f above sea level\n";
}

void fill_vector(istream& ist, vector<int>& v, char terminator)
//read integers from ist into v until we reach eof() or terminator
{
    //it is understood that getting more data from istream in the bad() state is unlikely. Most callers won't bother
    //TO make life easier we can tell the istream to throw the error instead of doing it ourselves
    //The notation may seem odd but the effect is that from that statement onward ist will throw the standard library exception ios_base::failure if it goes bad()
    ist.exceptions(ist.exceptions()|ios_base::badbit);
    for( int i; ist >> i; ) {
        v.push_back(i);
        cin_error_handle(ist);}
}

