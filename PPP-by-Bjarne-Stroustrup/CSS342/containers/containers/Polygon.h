//
//  Polygon.h
//  containers
//
//  Created by Tsz Chun Lai on 9/26/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __containers__Polygon__
#define __containers__Polygon__

#include <iostream>
using namespace::std;

class Polygon{
protected:
    int width, height;
public:
    Polygon(int a, int b): width(a),height(b)
    {
    }
};

class Output{
public:
    static void print(int i);
};

void Output::print(int i )
{
    cout << i << endl;
}

class Rectangle: public Polygon, public Output{
public:
    Rectangle (int a, int b) : Polygon(a,b) {}
    int area()
    {
        return width*height;
    }
};

class Triangle: public Polygon, public Output{
public:
    Triangle(int a, int b):Polygon(a,b) {}
    int area()
    {
        return width*height/2;
    }
};

int main() {
    Rectangle rect (4,5);
    Triangle trgl (4,5);
    rect.print (rect.area());
    Triangle::print(trgl.area());
}
#endif /* defined(__containers__Polygon__) */
