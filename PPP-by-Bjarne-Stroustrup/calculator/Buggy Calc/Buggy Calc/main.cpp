

/*
	calculator08buggy.cpp
 
	Helpful comments removed.
 
	We have inserted 3 bugs that the compiler will catch and 3 that it won't.
 
 1/3 bugs that the compiler will catch
 3/3 that it won't
 */

#include "std_lib_facilities.h"

struct Token {
    char kind;      //kind of token represented by a char
    double value;   //value, for kind is a floating point number
    string name;    //name, for kind is a variable
    //Constructor for operators, operators represents themselves
    Token(char ch) :kind(ch), value(0) { }
    //Constructor for floating point numbers
    Token(char ch, double val) :kind(ch), value(val) { }
    //Constructor for variables
    Token(char ch, string n) : kind(ch), name(n) {}
};

class Token_stream {
    bool full;      //is there already a token in the buffer
    Token buffer;
public:
    //construct new Token_stream with empty buffer
    Token_stream() :full(0), buffer(0) { }
    //get the next token
    Token get();
    //put t into buffer
    void putback(Token t) { buffer=t; full=true; }
    //ignore until the next time char a occur
    void ignore(char a);
};

const char let = 'L';
const char quit = 'Q';
const char print = ';';
const char number = '8';
const char name = 'a';

Token Token_stream::get()
{
    //look in buffer before getting any tokens
    if (full) { full=false; return buffer; }
    char ch;
    cin >> ch;
    switch (ch) {
            //operators
        case '(':
        case ')':
        case '+':
        case '-':
        case '*':
        case '/':
        case '%':
        case ';':
        case '=':
            return Token(ch); //operators represent themselves
            
            //floating point literals
        case '.':   // floating point numbers can begin with a dot
        case '0': case '1': case '2': case '3': case '4':
        case '5': case '6': case '7': case '8': case '9':
        {	cin.unget();
            double val;
            cin >> val;
            return Token(number,val);
        }
        default:
            if (isalpha(ch)) {
                string s;
                s += ch;
                while(cin.get(ch) && (isalpha(ch) || isdigit(ch))) s+=ch;
                if (s == "let") return Token(let);
                if (s == "quit") return Token(quit);
                cin.unget();
                return Token(name,s);
            }
            error("Bad token");
    }
    throw runtime_error("");
}

void Token_stream::ignore(char c)
{
    if (full && c==buffer.kind) {
        full = false;
        return;
    }
    full = false;
    
    char ch;
    while (cin>>ch)
        if (ch==c) return;
}

struct Variable {
    string name;
    double value;
    Variable(string n, double v) :name(n), value(v) { }
};

vector<Variable> names;

double get_value(string s)
{
    for (int i = 0; i<names.size(); ++i)
        if (names[i].name == s) return names[i].value;
    error("get: undefined name ",s);
    throw runtime_error("");
}

void set_value(string s, double d)
{
    for (int i = 0; i<=names.size(); ++i)
        if (names[i].name == s) {
            names[i].value = d;
            return;
        }
    error("set: undefined name ",s);
}

bool is_declared(string s)
{
    for (int i = 0; i<names.size(); ++i)
        if (names[i].name == s) return true;
    return false;
}

Token_stream ts;

double expression();

double primary()
{
    Token t = ts.get();
    switch (t.kind) {
        case '(':
        {	double d = expression();
            t = ts.get();
            if (t.kind != ')') error("'(' expected");
        }
        case '-':
            return - primary();
        case number:
            return t.value;
        case name:
            return get_value(t.name);
        default:
            error("primary expected");
    }
    throw runtime_error("");
}

double term()
{
    double left = primary();
    while(true) {
        Token t = ts.get();
        switch(t.kind) {
            case '*':
                left *= primary();
                break;
            case '/':
            {	double d = primary();
                if (d == 0) error("divide by zero");
                left /= d;
                break;
            }
            default:
                ts.putback(t);
                return left;
        }
    }
}

double expression()
{
    double left = term();
    while(true) {
        Token t = ts.get();
        switch(t.kind) {
            case '+':
                left += term();
                break;
            case '-':
                left -= term();
                break;
            default:
                ts.putback(t);
                return left;
        }
    }
}

double declaration()
{
    Token t = ts.get();
    if (t.kind != name) error ("name expected in declaration");
    string name = t.name;
    if (is_declared(name)) error(name, " declared twice");
    Token t2 = ts.get();
    if (t2.kind != '=') error("= missing in declaration of " ,name);
    double d = expression();
    names.push_back(Variable(name,d));
    return d;
}

double statement()
{
    Token t = ts.get();
    switch(t.kind) {
        case let:
            return declaration();
        default:
            ts.putback(t);
            return expression();
    }
}

void clean_up_mess()
{
    ts.ignore(print);
}

const string prompt = "> ";
const string result = "= ";

void calculate()
{
    while(true) try {
        cout << prompt;
        Token t = ts.get();
        while (t.kind == print) t=ts.get();
        if (t.kind == quit) return;
        ts.putback(t);
        cout << result << statement() << endl;
    }
    catch(runtime_error& e) {
        cerr << e.what() << endl;
        clean_up_mess();
    }
}
int main()
{
    try{
        calculate();
        return 0;
    }
    catch (exception& e)
    {
        cerr << "exception: " << e.what() << endl;
        char c;
        while (cin >>c&& c!=';') ;
        return 1;
    }
    catch (...)
    {
        cerr << "exception\n";
        char c;
        while (cin>>c && c!=';');
        return 2;
    }
}