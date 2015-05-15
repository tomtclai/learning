//
//  main.cpp
//  example_17
//
//  Created by Tsz Chun Lai on 9/18/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include "vector.h"
#include <stdlib.h>
//void v_user()
//{
//    vector<double> age(4); //a vector with 4 elements of type double
//    age[0] = 0.33;
//    age[1] = 22.0;
//    age[2] = 27.2;
//    age[3] = 54.2;
//}
void sizes()
{
    std::cout <<
    sizeof(char) << std::endl <<
    sizeof(int) << std::endl <<
    sizeof(int*) << std::endl;
}
void access_thru_pointers()
{
    double* p = new double[4];
    double x = *p;
    double y = p[2];
    double z = p[3];
    
    double a = 12.2;
    double *b = &a;
    double c = b[0];
    double d = *b;      //note c == d;
    
}
double* calc(int res_size, int max)
{
    double* p = new double[max];    //max uninitialized doubles
    double* res = new double[res_size];
    //use p to calculate results to be put in res
    
    //memory leak of p, how to fix? delete.
    delete [] p;
    return res;
}
int main(int argc, const char * argv[]) {
    sizes();
}
