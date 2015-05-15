//
//  Shape.h
//  example_14
//
//  Created by Tsz C. Lai on 9/19/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __example_14__Shape__
#define __example_14__Shape__

#include "Point.h"
#include "fltk.h"
#include "std_lib_facilities.h"
#include "Graph.h"
class Shape{
    //deals wi th color and style and holds sequence of lines
public:
    void draw() const;                  //deal with color and call draw lines
    virtual void move{int dx, int dy};  //move the shape += dx and += dy
    
    void set_color(Graph_lib::Color  col);
    Color color() const;
    
    void set_style(Line_style sty);
    Line_style style()const;
    
    void set_fill_color(Graph_lib::Color  col);
    Color fill_color() cont;
    
    Graph_lib::Point point(int i ) const;          //read only access to points
    int number_of_points() const;
    
    Shape(const Graph_lib::Point&) = delete;       //prevent copying
    Shape& operator= ( const Graph_lib::Point&) = delete;
    
    virtual ~Shape() {}
    
protected:
    /**
     The constructors are protected. They can only be used directly from classes derived from Shape(using the :Shape notation). In other words, Shape can only be used as a base for classes, such as Line, Open_polyline, different kinds of shape. The purpose of that protected is to ensure that we don't just make a generic Shape. 
     */
    Shape() {};
    Shape(initializer_list<Graph_lib::Point> lst); //add() the Points to this Shape
    
    virtual void draw_lines() const;    //draw the appropriate lines
    void add(Graph_lib::Point p);                  //add p to points
    void set_point(int i, Graph_lib::Point p);     //points[i] = p;+
    
private:
    vector<Graph_lib::Point> points;
    Graph_lib::Color lcolor{fl_color()};
    Line_style ls{0};
    Graph_lib::Color fcolor{Graph_lib::Color::invisible};
};

#endif /* defined(__example_14__Shape__) */
