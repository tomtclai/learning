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
template<typename T, typename A>
Vector<T,A>::Vector(int s)                           //constructor
:sz{s},                                         //initialize sz
elem{new T[s]}                             //initialize elem
{
    for (int i = 0 ; i < s; ++ i) elem[i] = 0;  //initialize elements
}
template<typename T, typename A>
void copyChain(T* a, T* b)
{
    while (a!= nullptr)
    {
        *b = *a;
        a++;
        b++;
    }
}
template<typename T, typename A>
Vector<T,A>::Vector(const Vector& arg)
:sz(arg.sz),elem(new T[arg.sz])
{
    copyChain(arg.elem,elem);
}
template<typename T, typename A>
Vector<T,A>::~Vector()                               //destructor
{
    delete[] elem;                              //free memory
}
template<typename T, typename A>
int Vector<T,A>::size() const
{
    return sz;
}
template<typename T, typename A>
Vector<T,A>::Vector(initializer_list<T> lst)
:sz{static_cast<int>(lst.size())}, elem{new T[sz]}
{
    copy(lst.begin(),lst.end(),elem);
}
template<typename T, typename A>
Vector<T,A>& Vector<T,A>::operator=(const Vector & a)
{
    if (this== &a) //self assignment
        return *this;
    if (a.sz <= space) //enough space
    {
        for (int i = 0; i < a.sz; ++i)
            elem[i] = a.elem[i];
        sz = a.sz;
        return *this;
    }
    
    T* p = new T[a.sz];//allocate new space because not enough space
    for (int i = 0; i < a.sz; ++i)
        p[i] = a.elem[i];
    delete[] elem;
    elem = p;
    space = sz = a.sz;
    return *this;
}
template<typename T, typename A>
Vector<T,A>:: Vector(Vector&& a)
:sz{a.sz}, elem{a.elem}
{
    a.sz = 0;
    a.elem = nullptr;
}
template<typename T, typename A>
Vector<T,A>& Vector<T,A>::operator=(Vector&&a)
{
    delete [] elem;
    elem = a.elem;
    sz = a.sz;
    a.elem = nullptr;
    a.sz = 0;
    return *this;
}
template<typename T, typename A>
T& Vector<T,A>::operator[](int n)
{
    std::cout <<"non-const[]"<<std::endl;
    return elem[n];
}
template<typename T, typename A>
const T& Vector<T,A>::operator[](int n) const
{
    std::cout<<"const[]" <<std::endl;
    return elem[n];
}
template<typename T, typename A>
T& Vector<T,A>:: at(int n)
{
    if (n<0||sz<= n) throw out_of_range();
    return elem;
}
template<typename T, typename A>
void Vector<T,A>::reserve(int newalloc)
{
    //don't decrease
    if (newalloc <= space)
        return;
    //new space
    T*p = new T[newalloc];
    //copy old elements
    for (int i = 0 ; i< sz; ++i)
        p[i] = elem[i];
    //delete old elements
    delete[] elem;
    //update elem pointer
    elem = p;
    //update space;
    space = newalloc;
}
template<typename T, typename A>
int Vector<T,A>::capacity() const
{
    return space;
}
template<typename T, typename A>
void Vector<T,A>::resize(int newsize, T def)
{
    //n > space
    //n > size && n < space
    //n == size
    //n < size
    reserve(newsize);
    for (int i = sz; i < newsize; ++i)
        elem[i] = 0;
    sz = newsize;
}
template<typename T, typename A>
void Vector<T,A>::push_back(T d)
{
    if (space == 0)
        reserve(8);
    else if (sz == space)
        reserve(2*space);
    elem[sz] = d;
    ++sz;
}


