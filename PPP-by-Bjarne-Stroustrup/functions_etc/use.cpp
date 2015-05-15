//
//  use.cpp
//  functions_etc
//
//  Created by Tsz Chun Lai on 8/28/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//


#include "my.h"
#include "std_lib_facilities.h"
int foo;
void swap_v(int,int);
void swap_r(int&,int&);
void swap_cr(const int&, const int&);
int main();
//-------------------------------------------------------

int main()
{
//    foo = 7;
//    print_foo();
//    print(99);
    int x = 7;
    int y = 9;
    cout <<"x " << x << " y " << y << endl;
    swap_r(x, y);   //swap_r succesfully swapped the two because it used reference
    cout <<"x " << x << " y " << y << endl;
    
    
    swap_v(x, y);   //swap_v failed to swap the two because it did not use reference,
                    //the value 7 and 9 were passed to the function instead
    cout <<"x " << x << " y " << y << endl;
//    swap_r(7, 9); notice & only works on variable, not literals
    const int cx = 7;
    const int cy = 9;
    cout <<"cx " << cx << " cy " << cy << endl;
//    swap_r(cx, cy); notice & only works on variable, not constants
//    swap_r(7.7, 9.9); notice & only works on variable, not literals
    
    swap_v(cx, cy); //swap_v failed to swap the two because it did not use reference,
                    //the value 7 and 9 were passed to the function instead.
                    //other than that, cx, cy is constant and would raise an error
                    //had they been passed to the function by reference.
    cout <<"cx " << cx << " cy " << cy << endl;
    
    double dx = 7.7;
    double dy = 9.9;
    
    cout <<"dx " << dx << " dy " << dy << endl;
    
    swap_v(dx, dy);
    
    cout <<"dx " << dx << " dy " << dy << endl;
    //swap_r(dx, dy); //notice & only works on int variable, not doubles
    swap_cr(dx, dy);
    
    cout <<"dx " << dx << " dy " << dy << endl;
}

void swap_v(int a, int b)
{
    int temp;
    temp = a;
    a = b;
    b = temp;
}

void swap_r(int& a, int& b)
{
    int temp;
    temp = a;
    a = b;
    b = temp;
}

void swap_cr(const int& a, const int& b)
//notice that you can't assign anything to a constant, a constant is read-only
{
    int temp;
    temp = a;
//    a = b;
//    b = temp;
}
