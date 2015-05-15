//
//  Year.h
//  User_defined_types
//
//  Created by Tsz Chun Lai on 8/30/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef User_defined_types_Year_h
#define User_defined_types_Year_h


class Year{ //year in range [min:max]
    static const int min = 1800;
    static const int max = 2200;
public:
    class Invalid{};
    Year(int x) : y(x) {
        if (x < min || max < x) throw Invalid();}
    int year() { return y;}
    bool operator ==(const Year&a)
    {
        return y == a.y;
    }
    
private:
    int y;
};

#endif
