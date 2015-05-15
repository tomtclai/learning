/*
  user.cpp
  calculator

  Created by Tsz Chun Lai on 8/20/14.
  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.

    Gammar for input is listed below
     Statement:
        Expression
        Print
        Quit
     Print:
        ;  
     Quit:
        q
     Number:
        any floating-point-literal
     Primary:
        Number
        (Expression)
        -Primary
        +Primary
     Term:
        Primary
        Term * Primary
        Term / Primary
        Term % Primary
     Expression:
        Term
        Expression + Term
        Expression - Term
     
     Input comes from cin through the Token_stream called ts.
 */
#include "std_lib_facilities.h"
#include "user.h"
#include "Token.h"
#include "Token_stream.h"
#include "Variable.h"
const char number ='8'; //number token
const char print = ';'; //print token
const char quit = 'q';  //quit token
const char let = 'L';   //declaration token
const char name = 'a';  //name token
const string prompt ="> ";
const string result ="= ";

vector<Variable> var_table;
/*
 Calculation:
    Statement
    Print
    Quit
    Calculation Statement
 Statement:
    Declaration
    Expression
 Declaration:
    "let" Name "=" Expression
 */
double get_value(string s)
{
    // return the value of the variable named s
    for( const Variable& v : var_table)
        if(v.name == s) return v.value;
    error("get: undefined variable ", s);
    throw runtime_error("");
}
void set_value(string s, double d)
{
    for ( Variable&v: var_table)
        if(v.name == s)
        {
            v.value = d;
            return;
        }
    error("set: undefined variable ",s);
    throw runtime_error("");
}
bool is_declared(string var)
// is var already in var_table?
{
    for(const Variable& v : var_table)
        if( v.name == var) return true;
    return false;
}
double define_name(string var, double val)
// add (var,val) to var_table
{
    if( is_declared(var)) error(var," declared twice");
    var_table.push_back((Variable(var,val)));
    return val;
}
double expression(Token_stream ts);
double declaration(Token_stream ts){
    //assime we have seen "let"
    //handel name = expression
    //declare a variable called "name" with the
    //initial value "expression"
    Token t = ts.get();
    if(t.kind != name) error("name expected in declaration");
    string var_name = t.name;
    Token t2 = ts.get();
    if (t2.kind != '=') {
        error("= missing in declaration of ", var_name);
    }
    double d = expression(ts);
    define_name(var_name, d);
    return d;
}
double statement(Token_stream ts)
{
    Token t= ts.get();
    switch (t.kind) {
        case let:
            return declaration(ts);
            break;
            
        default:
            ts.putback(t);
            return expression(ts);
            break;
    }
}

double primary(Token_stream ts)
{
    Token t = ts.get();
    switch (t.kind) {
        case '(':
        {
            double d = expression(ts);
            t = ts.get();
            if ( t.kind != ')') error ("')' expected");
            return d;
        }
        case number:
            return t.value;
        case '-':
            return -primary(ts);
        case '+':
            return primary(ts);
        case name:
            return get_value(t.name);
        default:
            error("primary expected");
    }
    throw runtime_error("");
}

double term(Token_stream ts)
{
    double left = primary(ts);
    Token t = ts.get();
    
    while(true)
    {
        switch (t.kind) {
            case '*':
                left *= primary(ts);
                t = ts.get();
                break;
            case '/':
            {
                double d = primary(ts);
                if ( d==0) error("divide by zero");
                left /= d;
                t = ts.get();
                break;
            }
            case '%':
            {
                double d= primary(ts);
                if ( d==0 ) error ( "divide by zero");
                left = fmod(left, d);
                t = ts.get();
                break;
            }
            default:
                ts.putback(t);
                return left;
                break;
        }
    }
}

double expression(Token_stream ts)
{
    double left = term(ts);
    Token t = ts.get();
    
    while(true)
    {
        switch (t.kind) {
            case '+':
                left += term(ts);
                t = ts.get();
                break;
            case '-':
                left -= term(ts);
                t = ts.get();
            default:
                ts.putback(t);
                return left;
                break;
        }
    }
}
void clean_up_mess(Token_stream ts)
{
    //skips until we find a print
    ts.ignore(print);
}
void calculate(Token_stream ts){
    while(cin){
        try {
            cout << prompt ;
            Token t = ts.get();
            while (t.kind ==';') t=ts.get(); // eat ;
            if(t.kind ==quit) return;
            ts.putback(t);
            cout << result << statement(ts) << endl;
            
        }
        catch (exception& e){
            cerr << e.what()  << endl;
            clean_up_mess(ts);
        }
    }
}

int main()
{
    try
    {
        Token_stream ts;
        #include <math.h>
        define_name("pi", M_PI);
        define_name("e", M_E);
        calculate(ts);
        keep_window_open();
        return 0;
    }
    catch (exception& e)
    {
        cerr << "error: " << e.what() << endl;
        keep_window_open("~~");
        return 1;
    }
    catch (...)
    {
        cerr << "unkown exception" << endl;
        keep_window_open();
        return 2;
    }
}