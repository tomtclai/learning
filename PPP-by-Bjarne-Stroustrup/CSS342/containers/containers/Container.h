//
//  Container.h
//  containers
//
//  Created by Tsz Chun Lai on 9/26/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __containers__Container__
#define __containers__Container__

#include <stdio.h>
class Container {
public:
    virtual double& operator[] (int) = 0;
    virtual int size() const = 0;
    virtual ~Container() {}
};

#endif /* defined(__containers__Container__) */
