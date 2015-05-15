//
//  Array.h
//  Chapter 19
//
//  Created by Tsz Chun Lai on 12/15/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Chapter_19_Array_h
#define Chapter_19_Array_h
template <typename T, int N> struct Array
{
    T elem[N];
    
    T& operator[] (int n );
    const T& operator[] (int n) const;
    T* data() {return elem;}
    const T* data() const {return elem;}
    int size() const {return N;}
};

//legal use
Array<int,256> gb;
Array<double,6> ad = {0.0, 0.2,0.1,0.3,402.1,20.1}
const int max = 1024;
void some_fct(int n )
{
    Array<char,max> loc;
    // illegal: value of n not known
    Array<char,n> error;
}
//compiler can deduce template arguments from function arguments
template< class T, int N> void fill(Array<T,N>& b, const T& val)
{
    for (int i = 0 ; i<N; ++i) b[i] = val;
}
Array<char,1024> buf;
Array<double,10> b2;
void f()
{
    //same as fill<char,1024>(buf,'x')
    fill(buf,'x');//buf has T is char and N is 1024
    //same as fill<double,10>(b2,0.0)
    fill(b2,0.0);//b2 has T is double and N is 10
}
#endif
