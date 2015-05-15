//
//  main.cpp
//  functions
//
//  Created by Tsz Chun Lai on 8/24/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "std_lib_facilities.h"
//
//int f(int);
//
//int main(int argc, const char * argv[]) {
//    int i = 7;
//    cout << f(i) << endl;
//}
///*
// double expression();
// 
// double primary()
// {
//    //...
//    expressions();
//    //...
// }
// 
// double term()
// {
//    //...
//    primary();
//    //...
// }
// 
// double expression()
// {
//    //...
//    term();
//    //...
// }
// */
//
//int a; //no initializer
//double d = 7; // initializer useing the = syntax
//vector<int> vi(10); //initializer using the () syntax
//const int x = 7;
//const int x2(9);
////const int y; // error: no initializer
//
//void print (const vector<double>& v)
//{
//    cout << "{" ;
//    for (int i = 0 ; i < v.size(); ++i) {
//        cout << v[i];
//        if ( i!= v.size() - 1) cout << ",";
//    }
//    cout << "}\n";
//}
///*
// & means reference, const means print can't modify the vector.
// a const reference is useful because we can't accidentally modify the object passed.
// */
//
//// pass-by-const-referece: no copy, read-only access
//int my_find(const vector<string>& vs, const string& s);
//
//void init(vector<double>& v)
//{
//    for(int i = 0; i < v.size(); ++i) v[i] = i;
//}
//
//void g(int x)
//{
//    vector<double> vd1(10);
//    vector<double> vd2(10000);
//    vector<double> vd3(x);
//
//    init(vd1);
//    init(vd2);
//    init(vd3);
//}
int f(int x) {
    return x;
}

int g(int x) {
    return x;
}

int main() {

int x = 1;
int y = 1;
vector< vector<double> > v; // vector of vector of double
double& var = v[f(x)][g(y)]; // var is a reference to v[f(x)][g(x)]; read and write
var = var /2 + sqrt( var);
//
//int test = 0;
//int& testref = test;

}