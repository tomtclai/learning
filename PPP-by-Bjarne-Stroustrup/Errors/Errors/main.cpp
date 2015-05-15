//
//  main.cpp
//  Errors
//
//  Created by Tsz Chun Lai on 8/14/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include "std_lib_facilities.h"
class Bad_area{};
int area(int length, int width)
{
    return length*width;
}
const int frame_width = 2;
int framed_area(int length, int width)
{
    if(length-frame_width < 0 || width-frame_width <0 )
        error("non-positive area() argument called by framed area()");
    return area(length-2,width-2);
}
void bad_argument() {
    try {
        int x = -1;
        int y = 2;
        int z = 4;
        
        int area1 = area(x,y);
        int area2 = framed_area(1,z);
        int area3 = framed_area(y,z);
        double ratio = double(area1)/area3;
    } catch (Bad_area) {
        cout <<"bad argument to area()\n";
    }
    
}
void test_last_input(){
    double d = 0;
    cin >> d;
    if (cin){
        //all is well, can try reading again
    }
    else {
        //last read didn't succeed
    }
}
int catch_error()
{
    try {
        //our program
        return 0; //success
    } catch (runtime_error& e) {
        cerr << "runtime error: " << e.what() << '\n';
        keep_window_open();
        return 1; //failure
    } catch (...) {
        cerr << "unknown exception!\n";
        keep_window_open();
        return 2;
    }
}
void uncaught(){
    error("");
}
int uncaught_main()
{
    //uncaught();
    int x1 = narrow_cast<int>(2.9);
    return 0;
}
int try_catch()
{
    try {
        vector<int> v;
        int x;
        while (cin >> x ) {
            v.push_back(x);
        }
        for ( int i = 0 ; i <= v.size(); ++i)
            cout<< "v[" <<i<<"] == " << v[i] << endl;
    } catch (out_of_range) {
        cerr << "Oops! Range error \n";
        return 1;
    } catch (...) {
        cerr <<"Exception: something went wrong \n";
        return 2;
    }
    return 0;
}
void find_error()
{
//    int res = 7;
//    vector<int> v(10);
//    v[5]= res;
//    cout <<"Success!\n";
//    
//    vector<int> v(10);
//    v[5] = 7;
//    if(v[5]==7)
//        cout << "Sucess!\n";
//
//    if(true) cout<< "Success!\n";
//    else cout<< "Fail!\n";
//
//    bool c = false;
//    if(!c)
//        cout <<"Success!\n";
//
//    string s = "ape";
//    bool c =true;
//    if (c) cout << "Success!\n";
//    
//    string s= "ape";
//    if( s == "ape") cout << "Success!\n";
//
//    vector<char> v(5);
//    for(int i = 0; i < v.size(); ++i);
//    cout << "Success\n";
//
    string s = "Success!\n";
//    for ( int i = 0 ; i < s.size(); ++i)
//        cout <<s[i];
//
//    vector<int> v(5);
//    for(int i= 0; i < v.size(); ++i);
//    cout << s;
//
//    int i = 0;
//    int j = 9;
//    while (i<10) {
//        ++i;
//        if(j<i) cout << s;

//}
//    
//    int x = 4;
//    double d = 5/(x-2);
//    if(d==2*x+0.5)
//        cout << s;

//    cout << s;
}

int error_main()
try {
    find_error();
    keep_window_open();
    return 0;
}
catch(exception& e){
    cerr << "error: " << e.what() << '\n';
    keep_window_open();
    return 1;
}
catch (...){
    cerr << "unknown exception \n";
    keep_window_open();
    return 2;
}