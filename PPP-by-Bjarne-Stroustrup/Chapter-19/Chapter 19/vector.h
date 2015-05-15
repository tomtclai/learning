//
//  vector.h
//  example_17
//
//  Created by Tsz Chun Lai on 9/18/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __example_17__vector__
#define __example_17__vector__

using namespace std;
#include <initializer_list>
template<typename T, typename A = allocator<T>>
class Vector {
    /*
     invariant:
     if 0<=n<sz, elem[n] is element n
     sz<=space;
     if sz<space there is space for (space–sz) Ts after elem[sz–1]
     */
    int sz;
    T* elem;   //pointer to first T
    int space;
    A alloc;
public:
    //explict constructor so vector v = 1 remain illegal
    explicit Vector(int);
    //copy constructor
    Vector(const Vector&);
    //initilizer list constructor
    Vector(initializer_list<T> lst);
    //move constructor
    Vector(Vector&& a);
    //move assignment
    Vector& operator=(Vector&&a);
    //assignment
    Vector& operator=(const Vector&);
    //destructor
    ~Vector();
    //current size
    int size() const;
    //unchecked access
    //  reference of element
    T& operator[](int n);
    //  return element but promise not to change Vector
    //  can return const T& as well but T is small enough
    const T& operator[](int n) const;
    //checked access
    T& at(int n);
    const T& at(int n) const;
    //add space
    void reserve(int newalloc);
    //return space
    int capacity() const;
    void resize(int n, T def = T());
    void push_back(T d);
    struct out_of_range{};
};

#endif /* defined(__example_17__vector__) */
