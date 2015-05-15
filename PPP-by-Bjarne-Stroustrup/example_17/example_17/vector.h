//
//  vector.h
//  example_17
//
//  Created by Tsz Chun Lai on 9/18/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __example_17__vector__
#define __example_17__vector__

#include <stdio.h>

class vector {
    int sz;
    double* elem;   //pointer to first double
public:
    vector(int);    //constructor
    ~vector();      //destructor
    int size() const;                   //current size
    
};

#endif /* defined(__example_17__vector__) */
