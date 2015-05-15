//
//  drill.h
//  Chapter 19
//
//  Created by Tsz Chun Lai on 1/2/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#ifndef Chapter_19_drill_h
#define Chapter_19_drill_h

template<typename T> struct S{
private:
    T val;
public:
    S(T theVal){val = theVal;};
    T& get();
    void set(T& theVal){val = theVal;};
};

template<typename T>
T& S<T>::get()
{
    return val;
}
#endif
