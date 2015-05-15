//
//  Link.h
//  Chapter 17
//
//  Created by Tsz Chun Lai on 11/15/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#ifndef __Chapter_17__Link__
#define __Chapter_17__Link__
#include <string>
using namespace::std;
class Link {
public:
    string value;
    Link(const string &v, Link *p = nullptr, Link *s = nullptr)
    :value{v}, prev{p}, succ{s} {};
    Link* insert(Link *n);
    Link* add(Link *n);
    Link* erase();
    Link* find(const string &s);
    const Link* find(const string &s) const;
    Link* advance(int n) const;
    Link* next() const {return succ;}
    Link* previous() const {return prev;}
private:
    Link* prev;
    Link* succ;
};

#endif /* defined(__Chapter_17__Link__) */
