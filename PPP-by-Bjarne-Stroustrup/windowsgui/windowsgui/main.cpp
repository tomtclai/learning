//
//  main.cpp
//  windowsgui
//
//  Created by Tsz Chun Lai on 9/15/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
//For example 12_3
#include "Graph.h"
#include "Simple_window.h"
#include "std_lib_facilities.h"
void example12_3()
{

    Graph_lib::Point t1{100,100};   //to become top left corner of window
    Simple_window win {t1,600,400,"Canvas #8"};
    
    Graph_lib::Polygon poly;
    
    poly.add(Graph_lib::Point{300,200});
    poly.add(Graph_lib::Point{350,100});
    poly.add(Graph_lib::Point{400,200});
    poly.set_color(Graph_lib::Color::red);
    win.attach(poly);
    
    win.wait_for_button();
}
int example12_7()
{
    try {
        Graph_lib::Point t1 {100,100};
        Simple_window win {t1,600,400,"Canvas"};
            //t1 is top left corner
            //600 px wide
            //400 px tall
            //title: "Canvas"
        
        Graph_lib::Axis xa {Graph_lib::Axis::x, Graph_lib::Point {20,300},
            280,10,"x axis"};
            //axis is a shape
            //Axis::x - horizontal axis
            //starting at {20,300}
            //280 px long
            //10 notches
            //"x axis" - label
        xa.set_color(Graph_lib::Color::black);
        win.attach(xa);
        
        Graph_lib::Axis ya {Graph_lib::Axis::y,Graph_lib::Point{20,300}, 280,
            10 , "y axis"};
        ya.set_color(Graph_lib::Color::black);
        win.attach(ya);
        Graph_lib::Function sine {sin,0,100,Graph_lib::Point{20,150}, 1000,50,50};
        //plat sin() in the range [0,100) with (0,0) at (20,150)
        //using 1000 points, scale x values * 50, scale y values * 50
        sine.set_color(Graph_lib::Color::black);
        win.attach(sine);
        sine.set_color(Graph_lib::Color::blue);
        
        Graph_lib::Polygon poly;
        poly.add(Graph_lib::Point {300,200});
        poly.add(Graph_lib::Point {350,100});
        poly.add(Graph_lib::Point {400,200});
        poly.set_color(Graph_lib::Color::red);
        poly.set_style(Graph_lib::Line_style(Graph_lib::Line_style::dash,2));
        win.attach(poly);
        
        Graph_lib::Rectangle r {Graph_lib::Point{200,200}, 100, 50};
        r.set_color(Graph_lib::Color::black);
        r.set_fill_color(Graph_lib::Color::yellow);
        win.attach(r);
        
        Graph_lib::Closed_polyline poly_rect;
        poly_rect.add(Graph_lib::Point {100,50});
        poly_rect.add(Graph_lib::Point {200,50});
        poly_rect.add(Graph_lib::Point {200,100});
        poly_rect.add(Graph_lib::Point {100,100});
        poly_rect.add(Graph_lib::Point {50,75});
        poly_rect.set_color(Graph_lib::Color::black);
        poly_rect.set_style(Graph_lib::Line_style(Graph_lib::Line_style::dash,2));
        poly_rect.set_fill_color(Graph_lib::Color::green);
        win.attach(poly_rect);

        Graph_lib::Text t {Graph_lib::Point{150,150}, "hello world"};
        t.set_color(Graph_lib::Color::black);
        t.set_font(Graph_lib::Font::times_bold);
        t.set_font_size(20);
        win.attach(t);
        
        Graph_lib::Image ii {Graph_lib::Point {100,50},"stroustrup.jpg"};
        win.attach(ii);
        ii.move(100, 200);
        ii.set_mask(Graph_lib::Point(200,160), 200,150);  //display center of image
        
        Graph_lib::Circle c {Graph_lib::Point{100,200},50};
        c.set_color(Graph_lib::Color::black);
        win.attach(c);
        
        Graph_lib::Ellipse e {Graph_lib::Point{100,200},75,25};
        e.set_color(Graph_lib::Color::dark_red);
        win.attach(e);
        
        Graph_lib::Mark m {Graph_lib::Point{100,200},'x'};
        win.attach(m);
        ostringstream oss;
        oss << "screen size: " << Graph_lib::x_max() << "*" << Graph_lib::y_max()
        << "; window size: " << win.x_max() << "*" << win.y_max();
        
        Graph_lib::Text sizes {Graph_lib::Point{100,20}, oss.str()};
        sizes.set_color(Graph_lib::Color::black);
        win.attach(sizes);
        
        win.wait_for_button();
        return 0;
    } catch (exception& e) {
        return 1;
    } catch (...) {
        return 2;
    }
}
void example13_2()
{
    constexpr Graph_lib::Point x { 100,100 };
    Simple_window win1 {x, 600,400, "two lines"};
    
    Graph_lib::Line horizontal {x,Point{200,100}};
    Graph_lib::Line vertical {Point{150,50},Point{150,150}};
    
    win1.attach(horizontal);
    win1.attach(vertical);
    
    win1.wait_for_button();
}
int main(int argc, const char * argv[]) {
    return example12_7();
}
