//
//  main.cpp
//  Reading a strcutured file
//
//  Created by Tsz Chun Lai on 9/6/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include "Year.h"


void print_year(ofstream& ofs, Year y)
{
    ofs << y;
}
int main(int argc, const char * argv[])
{
//open input & output file
    cout << "enter input file name followed by output name\n";
    string iname, oname;
    cin >> iname >> oname;
    ifstream ifs {iname};
    ofstream ofs {oname};
    if(!ifs) error("can't open file", iname);
    ifs.exceptions(ifs.exceptions()|ios_base::badbit);
    if(!ofs) error("can't open file", oname);
    ofs.exceptions(ofs.exceptions()|ios_base::badbit);
    
//read an arbitrary number of years:
    vector<Year> ys;
    while(true) {
        Year y; //initilize year each time
        if(!(ifs >> y)) break;
        ys.push_back(y);
    }
    
    cout <<"read " << ys.size() << "years of readings \n";
    for(Year& y : ys) print_year(ofs,y);
}

