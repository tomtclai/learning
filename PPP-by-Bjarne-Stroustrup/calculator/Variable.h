//
//  Variable.h
//  calculator
//
//  Created by Tsz Chun Lai on 8/21/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __calculator__Variable__
#define __calculator__Variable__

#include <stdio.h>
#include "std_lib_facilities.h"

class Variable {
public:
    string name;
    double value;
    Variable(string var, double val)
    :name(var), value(val){};
};

#endif /* defined(__calculator__Variable__) */
