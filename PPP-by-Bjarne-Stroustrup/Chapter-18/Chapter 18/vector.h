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
class Vector {
    int sz;
    double* elem;   //pointer to first double
public:
    //explict constructor so vector v = 1 remain illegal
    explicit Vector(int);
    //copy constructor
    Vector(const Vector&);
    //initilizer list constructor
    Vector(initializer_list<double> lst);
    //move constructor
    Vector(Vector&& a);
    //move assignment
    Vector& operator=(Vector&&a);
    Vector& operator=(const Vector&);
    //destructor
    ~Vector();
    //current size
    int size() const;
    //reference of element
    double& operator[](int n);
    //return element but promise not to change Vector
    //can return const double& as well but double is small enough
    const double& operator[](int n) const;

};

#endif /* defined(__example_17__vector__) */
