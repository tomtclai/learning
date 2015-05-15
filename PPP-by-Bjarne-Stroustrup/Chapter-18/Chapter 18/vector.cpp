//
//  vector.cpp
//  example_17
//
//  Created by Tsz Chun Lai on 9/18/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.

using namespace std;
#include <algorithm>
#include "vector.h"
#include <iostream>
Vector::Vector(int s)                           //constructor
:sz{s},                                         //initialize sz
elem{new double[s]}                             //initialize elem
{
    for (int i = 0 ; i < s; ++ i) elem[i] = 0;  //initialize elements
}
void copyChain(double* a, double* b)
{
    while (a!= nullptr)
    {
        *b = *a;
        a++;
        b++;
    }
}

Vector::Vector(const Vector& arg)
:sz(arg.sz),elem(new double[arg.sz])
{
    copyChain(arg.elem,elem);
}
Vector::~Vector()                               //destructor
{
    delete[] elem;                              //free memory
}
int Vector::size() const
{
    return sz;
}
Vector::Vector(initializer_list<double> lst)
:sz{static_cast<int>(lst.size())}, elem{new double[sz]}
{
    copy(lst.begin(),lst.end(),elem);
}
Vector& Vector::operator=(const Vector & a)
{
    if (this == &a) return (*this);
    double* p = new double[a.sz];
    copy(a.elem,a.elem+a.sz, p);
    delete elem;
    elem = p;
    sz = a.sz;
    return *this;
}
Vector:: Vector(Vector&& a)
:sz{a.sz}, elem{a.elem}
{
    a.sz = 0;
    a.elem = nullptr;
}
Vector& Vector::operator=(Vector&&a)
{
    delete [] elem;
    elem = a.elem;
    sz = a.sz;
    a.elem = nullptr;
    a.sz = 0;
    return *this;
}
double& Vector::operator[](int n)
{
    std::cout <<"non-const[]"<<std::endl;
    return elem[n];
}
const double& Vector::operator[](int n) const
{
    std::cout<<"const[]" <<std::endl;
    return elem[n];
}