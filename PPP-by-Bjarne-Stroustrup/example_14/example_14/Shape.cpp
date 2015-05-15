//
//  Shape.cpp
//  example_14
//
//  Created by Tsz C. Lai on 9/19/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "Shape.h"
#include "std_lib_facilities.h"
#include "Graph.h"
#include "fltk.h"

Shape::Shape(initializer_list<Graph_lib::Point> lst)
{
    for(Graph_lib::Point p: lst) add(p);
}

void Shape::set_color(Graph_lib::Color col)
{
    lcolor = col;
}
Graph_lib::Color Shape::color() const
{
    Graph_lib::Color test = lcolor;
    return test;
}
void Shape::set_point(int i, Graph_lib::Point p) // not used
{
    points[i] = p;
}
Graph_lib::Point Shape::point(int i) const
{
    return points[i];
}
int Shape:: number_of_points() const
{
    return points.size();
}
void Shape::draw() const
{
    F1_Color oldc = fl_color();
    
    
}
// derived ckass member functions
//void Lines::draw_lines() const
//{
//    for (int i = 1; i < number_of_points(); i+= 2)
//        fl_line(point(i-1).x,point(i-1).y,
//                point(i).x  ,point(i).y  );
//}