//
//  main.cpp
//  functions_etc
//
//  Created by Tsz Chun Lai on 8/28/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "std_lib_facilities.h"
#include "main.h"

namespace X {
    int var;
    void print();
    
    void print(){cout << "X " << var << endl;}
}

namespace Y {
    int var;
    void print();
    
    void print(){cout << "Y " << var << endl;}
}

namespace Z {
    int var;
    void print();
    
    void print(){cout << "Z " << var << endl;}
}

int main()
{
    X::var = 7;
    X:: print();
    using namespace Y;
    var = 9;
    print();
    {
        using Z::var;
        using Z::print;
        var = 11;
        print();
    }
    print();
    X::print();
}