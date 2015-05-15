//
//  drills.h
//  Chapter 18
//
//  Created by Tsz Chun Lai on 12/11/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef Chapter_18_drills_h
#define Chapter_18_drills_h
#include <iostream>
int ga[10]= {1,2,4,8,16,
    32,64,128,256,512};
void f(int iArr[], int n)
{
    //a
    int la[10];
    //b
    for (int i = 0; i < n; i++)
        la[i] = ga[i];
    //c
    for (int i = 0; i < n; i++)
        cout << la[i] << " " ;
    cout << endl;
    //d
    int* p = new int[n];
    //e
    for (int i = 0; i < n; i++)
        p[i] = iArr[i];
    //f
    for (int i = 0; i < n; i++)
        cout << p[i] << " " ;
    cout << endl;
    delete p;
}
vector<int> gv = {1,2,4,8,16,
    32,64,128,256,512};
void f(vector<int> vector1)
{
    //a
    vector<int> lv (vector1);
    //b
    lv=gv;
    //c
    for (int i = 0 ; i < lv.size(); i++)
        cout << lv.at(i) << " ";
    cout << endl;
    //d
    vector<int> lv2 (vector1);
    //e
    for (int i = 0 ; i < lv2.size(); i++)
        cout << lv2.at(i) << " ";
    cout << endl;
}
#endif
