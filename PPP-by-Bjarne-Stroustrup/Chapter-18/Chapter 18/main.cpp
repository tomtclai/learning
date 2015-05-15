//
//  main.cpp
//  Chapter 18
//
//  Created by Tsz Chun Lai on 11/15/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include <vector>
//using namespace std;
#include "vector.h"
#include "drills.h"
struct X
{
    int val;
    void out (const string& s, int nv)
    {
        cerr<<this << "->" << s << ":" << val << "(" << nv<< ")\n";
    }
    //default constructor
    X()
    {
        out("default constructor",0);
        val =0;
    }
    X(int v)
    {
        val = v;
        out("default constructor", v);
    }
    //copy constructor
    X(const X& x)
    {
        val = x.val;
        out("copy constructor", x.val);
    }
    //copy assignment
    X& operator= (const X&a)
    {
        out("copy assignment",a.val);
        val=a.val;
        return *this;
    }
    //destructor
    ~X()
    {
        out("destructor",0);
    }
};
//
//X glob(2); // a global variable
X copy(X a)
{
    return a;
}
X copy2(X a)
{
    X aa = a;
    return aa;
}
X& ref_to(X& a)
{
    return a;
}
X* make(int i)
{
    X a(i);
    return new X(a);
}
struct XX
{
    X a;
    X b;
};
void constructors()
{
    std::cout <<"main" <<std::endl;
    std::cout <<"X loc{4};"<<std::endl;
    X loc{4};
    std::cout <<"X loc2{loc};" << std::endl;
    X loc2{loc};
    std::cout <<"loc = X{5};" << std::endl;
    loc = X{5};
    std::cout <<"loc2 = copy2(loc);" << std::endl;
    loc2 = copy2(loc);
    std::cout <<"X loc3{6};" <<std::endl;
    X loc3{6};
    std::cout <<"X&r = ref_to(loc);" <<std::endl;
    X& r = ref_to(loc);
    std::cout <<"delete make(7);"<<std::endl;
    delete make(7);
    std::cout <<"delete make(8);"<<std::endl;
    delete make(8);
    std::cout <<"vector<X> v(4);"<<std::endl;
    std::vector<X> v(4);
    std::cout <<"XX loc4;"<<std::endl;
    XX loc4;
    std::cout <<"X* p = new X{9};" <<std::endl;
    X* p = new X{9};
    std::cout <<"delete p;" << std::endl;
    delete p;
    std::cout <<"X* pp = new X[5];"<<std::endl;
    X* pp = new X[5];
    std::cout <<"delete []pp;" <<std::endl;
    delete []pp;
    std::cout <<"return 0" << std::endl;
}
void ff(const Vector& cv, Vector& v)
{
    double d = cv[1];//const[]
    double dd = v[1];//non-const[]
    v[1] = 2.0;//non-const[]
}
void f2()
{
    char lac[20];//local array lives until the end of scope
    lac[7] = 'a';
    *lac = 'b'; // lac[0] = b
//    lac[-2] = 'b';//no
//    lac[200] = 'c';//no
    
}
int StrLen(const char* p)
{
    int count = 0;
    while (*p)
    {
        ++count;
        ++p;
    }
    return count;
}
void copyArray()
{
    int x[100];
    int y[100];
//    for (int i = 0; i < 100; ++i)
//        x[i] = y[i];
//    memcpy(x, y, 100*sizeof(int));

    copy(y,y+100,x);
    for (int i = 0 ; i < 100; i++)
    {
        cout << x[i] <<" ";
    }
    cout << endl;
    for (int i = 0 ; i < 100; i++)
    {
        cout << y[i] <<" ";
    }
    
}
int factorial(int i)
{
    if(i==0)
        return 1;
    return i * factorial(i-1);
}
int main(int argc, const char * argv[]) {
//    Vector v(10);
//    for (int i = 0; i < v.size(); ++i)
//    {
//        v[i] = i;
//        cout << v[i];
//    }
//    ff(v,v);
    //p907
//    int ad[10];
//    int* p = &ad[5];
//    *p =7;
//    p[2] = 6;
//    p[-3] = 9;

//    for ( int* pi = &ad[0]; pi < &ad[10]; ++pi)
//        cout << *pi <<" ";
//    cout << endl;
//    char ch[1000];
//    cout << sizeof(ch)<<endl;
//    copyArray();
//    ch = new char[20]; // errror: no assignment to array
//    &ch[0] = new char[20]; // no assignment to pointer value
    //p913
//    string ac = "Beorn";
//    cout << ac <<endl;
//    cout << strlen(&ac[0]) <<endl;
//    cout << sizeof(ac) << endl;
    f(ga,sizeof(ga)/sizeof(int));
    int aa[10];
    for (int i = 0; i < 10; i++)
        aa[i] = factorial(i+1); // don't want factorial(0) in array
    f(aa,sizeof(aa)/sizeof(int));
    cout <<endl;
    
    f(gv);
    vector<int> vv(10);
    for (int i = 0; i < 10; i++)
        vv.at(i) = factorial(i+1); // don't want factorial(0) in array
    f(vv);
    return 0;
}
