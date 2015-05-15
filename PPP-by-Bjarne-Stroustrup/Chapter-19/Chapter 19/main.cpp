//
//  main.cpp
//  Chapter 19
//
//  Created by Tsz Chun Lai on 12/11/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include "vector.h"
#include <vector>
#include "drill.h"
vector<int> make_vec()
{
    vector<int> res;
    return res;//move constructor
}
int main(int argc, const char * argv[]) {
//    int myInt;
//    myInt = 0xFFFFFFE2;
//    printf("%d\n",myInt);
    
    S<int> si(0);
    S<char> sch('a');
    S<double> sd(1);
    S<vector<int>> sv({1,2});
    
    cout << si.get() << sch.get() << sd.get();
    for (int i = 0 ;  i < sv.get().size(); i++) cout << sv.get()[i];
    return 0;
    
}
