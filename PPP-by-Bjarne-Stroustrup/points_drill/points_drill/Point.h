//
//  Point.h
//  points_drill
//
//  Created by Tsz Chun Lai on 9/8/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __points_drill__Point__
#define __points_drill__Point__

#include <stdio.h>
struct Point {
    double x;
    double y;
    Point (double xx, double yy)
    : x{xx} ,y{yy}
    {
        
    };
    Point ()
    : x{0}, y{0}
    {
        
    }
};

#endif /* defined(__points_drill__Point__) */
