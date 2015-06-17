//
//  main.cpp
//  InterviewBit
//
//  Created by Tom Lai on 6/16/15.
//  Copyright © 2015 tom. All rights reserved.
//

#include <iostream>
#include <vector>
using namespace std;
vector<vector<int> > prettyPrint(int A) {
    vector< vector<int> > result;
    if (A<=0) return result;
    int y = A-1; // y is 0 at center row
    int row = 0;
    for(int x = -A+1; x < A; x++) // x is 0 at center column
    {
        // abs(abs(y)-abs(x)) == 0: print 1
        // abs(abs(y)-abs(x)) == 1: print 2
        // abs(abs(y)-abs(x)) == offset: print offset+1
        result[row].push_back(std::abs(std::abs(y)-std::abs(x))+1);
        y--;
        row++;
    }
    return result;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    prettyPrint(1);
    
    return 0;
}
