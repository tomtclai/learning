//
//  main.cpp
//  binary files
//
//  Created by Tsz Chun Lai on 9/12/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "std_lib_facilities.h"
#include <fstream>
#include "Punct_stream.h"
using namespace std;
int main(int argc, const char * argv[]) {
    // Open an instream for binary input from a file:
    cout << "please enter input file name\n";
    string iname;
    cin >> iname;
    ifstream ifs {iname,ios_base::binary};  //Note: stream mode
        //binary tells the stream not to try anything clever with the bytes
    if (!ifs) throw runtime_error("can't open input file" + iname);
    
    //open an ostream for binary output to a file:
    cout << "please enter output file name\n";
    string oname;
    cin >> oname;
    ofstream ofs {oname, ios_base::binary}; //Note: stream mode
        //binary tells the stream not to try anything cleve with the bytes
    if(!ofs) throw runtime_error("can't open output file" + oname);
    
    vector<int> v;
    
    //read from binary file:
    for(int x ; ifs.read(as_bytes(x),sizeof(int));)//Note: reading bytes
        v.push_back(x);
    
    //do something with v
    //....
    
    //write to binary file:
    for(int x: v)
        ofs.write(as_bytes(x), sizeof(int));
    return 0;
}
void positioning_in_files(string name)
{
    fstream fs {name};
    if(!fs) error("can't open ", name);
    
    fs.seekg(5);    //move reading position (g for "get") to 5 (the 6th char)
    char ch;
    fs >> ch;   //read and increment reading position
    cout << "character[5] is " << ch << '(' << int(ch) << ")\n";
    fs.seekp(1);    //move writing position(p for "put") to 1
    fs << 'y';      //write and increment wrting position
}
double str_to_double(string s)
//if possible convert characters in s to floating point value
//usage:
//  double d1 = str_to_double("12.4");
//  double d2 = str_to_double("1.34e-3");
//  double d3 = str_to_double("twelve point three"); //will call error()
{
    istringstream is {s}; //make a stream so that we can read from s
    double d;
    is >> d;
    if ( !is ) error("double format error: ",s);
    return d;
}
//void ostringstream_user(string label, Temperature temp)
//{
//    ostringstream os;
//    os <<stew(8) << label <<": "
//    <<fixed << setprecision(5) << temp.temp << temp.unit;
//    
//    someobject.display(Point(100,100), os.str().c_str());
//}
//void another_example()
//{
//    int seq_no = get_next_number();
//    ostringstream name;
//    name << "myfile" << seq_no << ".log";
//    ofstream logfile{name.str()};
//}
//a simple use of ostringstream is to construct strings by concatentation.
void getline_user()
{
    string name;
    getline(cin,name);  //input: dennis ritchie
    cout << name << '\n';//output: dennis ritchie
    
    string first_name, second_name;
    stringstream ss{name};
    ss >> first_name >> second_name;
}
void getline_example()
{
    string command;
    getline(cin, command);
    stringstream ss{command};
    vector<string> words;
    for ( string s ; ss >> s; )
    {
        words.push_back(s);//extract individual words
    }
}
void tokenizing_an_expression()
{
    for(char ch; cin.get(ch);)
    {
        if(isspace(ch))
        {
            //whitespace, do nothing
        }
        if(isdigit(ch))
        {
            //read a number
        }
        else if(isalpha(ch))
        {
            //read an identifier
        }
        else {
            //deal with opeartors
        }
    }
}
void make_punctuations_space()
{
    string line;
    getline(cin, line);
    for (char & ch: line)
    {
        switch (ch) {
            case ';': case '.': case '?': case '|':
                ch = ' ';
                break;
                
            default:
                break;
        }
    }
    stringstream ss(line);
    vector<string> vs;
    for (string word; ss >> word;)
    {
        vs.push_back(word);
    }
}
void punct_stream_user()
{
    Punct_stream ps{cin};
    ps.whitespace(";:,.?!()\"*{}<>/&$@#%^*|~");  //note \" means "
    ps.case_sensitive(false);
    
    cout << "please enter words \n";
    vector<string> vs;
    for (string word; ps >> word; )
        vs.push_back(word);
    
    sort(vs.begin(),vs.end());
    for(int i = 0 ; i < vs.size(); ++i)
        if(i == 0 || vs[i]!=vs[i-1]) cout << vs[i] << endl;
}