//
//  main.cpp
//  Chapter 20
//
//  Created by Tsz Chun Lai on 2/7/15.
//  Copyright (c) 2015 Tsz Chun Lai. All rights reserved.
//

#include <iostream>
#include <string>
#include <list>
using namespace std;
struct Date{};
class Employee {
public:
    void print() const;
    string full_name() const{
        return first_name+ ' '+ middle_initial+ ' '+ family_name;
    }
private:
    string first_name, family_name;
    char middle_initial;
    Date hiring_date;
    short department;
    // ...
};
class Manager : public Employee {
public:
    void print() const;
    Employee emp; // manager’s employee record
    list<Employee*> group; // people managed
    short level;
    // ...
};



void g(Manager m, Employee e)
{
    Employee *pe = &m;  //Manager is an employee
//    Manager *pm = &e; //Error!
    
//    pm->level = 2; // disaster
    
    Manager *pm = static_cast<Manager*>(pe);//brute force converting employee to
                                            //Manager
    
    pm->level = 2;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
