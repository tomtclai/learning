//
//  main.cpp
//  HelloWorld
//
//  Created by Tsz Chun Lai on 8/6/14.
//  Copyright (c) 2014 Tsz Chun Lai. All rights reserved.
//

#include "std_lib_facilities.h"
//This is an '#include directive.' It instructs the computer to make available(" to include ") facilities from a file called std_lib_facilities.h. We wrote that file to simplify the use of the facilities available in all implementations of C++(standard library)


void names_and_age()
{
    cout << "Please enter your first name and age \n";  //prompt for name
    string first_name = "???";   //first_name is a variable of type string
    double age = -1;
    cin >> first_name >> age;   //read characters into first_name
    cout <<"you are " << first_name << " and you are " << age << " years old\n";   //output name
    //a string read using >> is terminated by whitespace.
    
    /*
     A function has four parts
     A return type, here int
     a name, here main
     a parameter list enclosed in parenthenses, here empty, ()
     a function body {}
     */
}

void operators(){
    cout << "Please enter a floating-point value:";
    double n;
    cin >> n;
    cout << "n == " << n
    << "\nn+1 == " << n+1
    << "\nthree times n == " << 3*n
    << "\ntwice n == " << n+n
    << "\nn squared == " << n*n
    << "\nhalf n == " << n/2
    << "\nsquare root of n == " << sqrt(n)
    <<endl;
    
}
void first_last_name()
{
    cout<<"Please enter first name and last name"<< endl;
    string first_name;
    string last_name;
    cin >> first_name >> last_name; //read 2 strings
    string full_name = first_name +' '+ last_name;
    cout << full_name << endl;
}
void compare_names(){
    cout<<"Please enter 2 distinct names"<< endl;
    string first_name;
    string second_name;
    cin >> first_name >> second_name; //read 2 strings
    if(first_name == second_name)
        cout << "they're the same! " << endl;
    if(first_name < second_name)
        cout << "Alphabetically, " << first_name
        << " comes before " << second_name << endl;
    if(first_name > second_name)
        cout << "Alphabetically, " << first_name
        << " comes after " << second_name << endl;
}
void count_repeated_words()
{
    cout << "this program count repeated words" << endl;
    string previous = " ";
    string current;
    int counter = 0 ;
    while(cin >> current)
    {
        if(previous == current)
        {
            cout <<  ++counter << " repeated word(s): " << current<< '\n';
        }
        previous=current;
    }
}
void good_bye()
{
    string s ( "Goodbye, cruel world!");
    cout << s << '\n';
}
void undefined ()
{
    double x;
    double y = x;
    double z = 2.0 + x;
    cout << y << z << endl;
    
}
//void safe_conversions()
//{
//    char c = 'x';
//    int i1 = c;
//    int i2 = 'x';
//    //both i1 and i2 get 120, the value for x in ASCII, simple and safe.
//    char c2 = i1;
//    cout << c << ' ' << i1 << ' ' << c2 << endl;
//}
void unsafe_conversions()
{
    int a = 20000;
    char c = a; // putting large int into a small char results in data loss
    int b = c;
    cout << a << ' ' << b << endl;
}
void experiment_conversions()
{
    /*
     All of the conversions are accepted even when they are unsafe.22
     double to int 
     double to char
     double to bool
     int to bool
     char to bool
     */
    cout << "experiment conversions" << endl;
    double d = 0;
    while (cin >> d)
    {
        int i = d;
        char c = i;
        int i2 = c;
        cout << "d " << d << endl
            << "i " << i << endl
            << "i2 " << i2 << endl
            << "c " << c << endl;
    }
}
string get_first_name ()
{
    cout << "Tell me the first name of the recepient"<<endl;
    string first_name;
    cin >> first_name;
    return first_name;
}

string get_friend_name()
{
    cout << "Tell me a mutual friend's name you want to ask about"<<endl;
    string friend_name;
    cin >> friend_name;
    return friend_name;
}
string get_friend_sex()
{
    cout << "And this friend's gender(m/f)"<<endl;
    string friend_sex;
    cin >> friend_sex;
    if (friend_sex =="m")
        friend_sex ="him";
    else if (friend_sex =="f")
        friend_sex = "her";
    else friend_sex = "them";
    return friend_sex;
}
int get_recepient_age()
{
    cout << "How old is the recepient? (digits please)" <<endl;
    int age;
    cin >> age;
    if( age < 1 || age > 110 )
        error("you're kidding");
    return age;
}
string get_age_comment(int age)
{
    string comment;
    if (age < 12) comment = "Next year you will be " + to_string(age+1) ;
    else if (age == 17 ) comment = "Next year you will be able to vote. ";
    else if (age > 70) comment = "I hope you're enjoying retirement. ";
    else comment ="";
    return comment;
}
string get_author_name()
{
    string name;
    cout << "What's your name?" << endl;
    cin >> name;
    return name;
}
void letter_drill()
{
    cout << "This program generates a letter to your friend"<<endl;
    string content ="";
    string author_name = get_author_name();
    string first_name = get_first_name();
    int age = get_recepient_age();
    string friend_name = get_friend_name();
    string friend_sex = get_friend_sex();
    string age_comment = get_age_comment(age);
    content += "Dear " + first_name + ", \n";
    content += "    How are you? I am fine. I miss you. \n";
    content += "Have you seen " + friend_name + " lately? ";
    content += "If you see " + friend_name + " please ask " + friend_sex + " to call me. \n";
    content += "    I hear you just had a birthday and you are " + to_string(age) + " years old. " ;
    content += age_comment + "\n";
    content += "\nYours sincerely, \n\n\n" + author_name + "\n";
    cout<< content << endl;
}
double mi_to_km(double num_miles)
{
    const double km_in_mile = 1.609;
    double num_km = num_miles * km_in_mile;
    return num_km;
}
void illegal_names()
{
//    the compiler complains about these which makes sense:
//    int double =0;
//    int if =0;
//    int void = 0;
//    int int = 0;
//    int while =0;
//    string int = "hello";
//    
//    however, these are legal:
    double string = 0.0;
    cout << string<< endl;
    double vector = 0.0;
    cout << vector << endl;
}
void two_values()
{
    double val1,val2;
    cout << "Enter two disctinct values separated by a space" << endl;
    cin >> val1 >> val2 ;
    double smallest, largest, sum, difference, product, ratio;
    
    difference = val1 - val2;
    
    if (difference > 0) {
        largest = val1;
        smallest = val2;
    }
    else{
        smallest = val1;
        largest = val2;
    }
    
    sum = val1+val2;
    
    product = val1*val2;
    
    ratio = val1/val2;
    
    cout << "smallest " << smallest <<endl
    <<"largest " << largest <<endl
    <<"sum " << sum << endl
    <<"difference " << difference << endl
    <<"product " << product << endl
    <<"ratio(first value over second) " << ratio << endl;
}
void num_sequence()
{
    cout << "This program return values in ascending order" << endl;
    int val[3];
    cout << "Enter three comma separated values" << endl;
    cin >> val[1] >> val[2] >> val[3];
    
    
}
template <typename any_type>
void swap(int a, int b, vector<any_type>& vals)
{
    any_type temp = vals[a];
    vals[a] = vals[b];
    vals[b] = temp;
}
template <typename any_type>
void selection_sort(vector<any_type>& vals)
{
    int min_index;
    int length = (int)vals.size();
    for(int i = 0 ; i < length ; i++)
    {
        min_index = i;
        for(int j= i+1 ; j < length ; j ++)
        {
            if (vals[min_index] > vals[j])
                min_index = j;
        }
        if( min_index != i)
        {
            swap(i,min_index,vals);
        }
    }
}
template <typename any_type>
int find_min_index(vector<any_type> vals)
{
    int min_index = -1;
    for(int i =0 ; i != vals.size() ; ++i)
    {
        if(vals[i-1] > vals[i])
            min_index = i;
    }
    return min_index;
}
template <typename any_type>
void sort_three()
{
    vector<any_type> values (3);
    cin >> values[0]>> values[1] >> values[2];
    selection_sort(values);
    cout << values[0];
    for(int i = 1 ; i != values.size(); ++i)
        cout << ", " << values[i];
    cout<< endl;
}
void sort_three_int()
{
    cout <<"This program sort 3 integers ascendingly, enter 3 space separated \
values" <<endl;
    sort_three<int>();
}
void sort_three_string()
{
    cout <<"This program sort 3 strings ascendingly, enter 3 space separated \
values" <<endl;
    sort_three<string>();
}
bool is_odd (int val)
{
    return val%2 == 1;
}
void odd_even(int val)
{
    string output = "The value " + to_string(val) + " is an ";
    if(is_odd(val))
        output += "odd";
    else
        output += "even";
    output += " number";
    cout << output << endl;
}
int english_to_digits(string number)
{
    if (number == "zero" || number == "Zero") {
        return 0;
    }
    else if (number == "one" || number == "One") {
        return 1;
    }
    else if (number == "two" || number == "Two") {
        return 2;
    }
    else if (number == "three" || number == "Three") {
        return 3;
    }
    else if (number == "four" || number == "Four") {
        return 4;
    }
    else return -1;
}
void translate_eng_dig()
{
    cout << "this program translates spelled-out numbers 0-4 into romen numerals" << endl;
    string spelled_out_number;
    int number = -1;
    
    while (cin >> spelled_out_number){
        number = english_to_digits(spelled_out_number);
        if (number == -1) cout << "Not a number I know" << endl;
        else cout << number << endl;
    }
}
#include <math.h>
double do_arithmetics (string a, double first_operand, double second_operand)
{
    if (a=="+"||a=="plus") return first_operand + second_operand;
    else if (a=="-"||a=="minus") return first_operand - second_operand;
    else if (a=="/"||a=="div") return first_operand / second_operand;
    else if (a=="*"||a=="mul") return first_operand * second_operand;
    else if (a=="%"||a=="mod") return fmod(first_operand, second_operand);
    else throw std::invalid_argument(a+" is not an operator");
}
void two_operands()
{
    cout << "this program takes an operation followed by 2 operands and output \
the result" << endl;
    string operation;
    double first_operand;
    double second_operand;
    while (cin >> operation >> first_operand >> second_operand) {
        cout << "= " << do_arithmetics(operation, first_operand, second_operand)
        << endl;
    }
}
int get_value(int pennies,int nickels,int dimes,int quarters,int half_dollars,int one_dollars){
    //pre: the number of each type of coins
    //post: the total value in cents
    return pennies + nickels * 5 + dimes * 10 + quarters * 25 + half_dollars * 50 + one_dollars * 100;
    
}
void add_coins()
{
    int pennies_amount, nickels_amount, dimes_amount, quarters_amount, half_dollars_amount, one_dollars_amount, cent_value;
    string pennies, nickels, dimes, quarters, half_dollars, one_dollars;
    cout << "This program prompts you to enter some number of pennies, nickels, dimes, quarters, half-dollars, and one-dollar coins and return the total value of coins in dollars. " << endl;
    cout << "How many pennies do you have?" << endl;
    cin >> pennies_amount;
    cout << "How many nickels do you have?" << endl;
    cin >> nickels_amount;
    cout << "How many dimes do you have?" << endl;
    cin >> dimes_amount;
    cout << "How many quarters do you have?" << endl;
    cin >> quarters_amount;
    cout << "How many half dollars do you have?" << endl;
    cin >> half_dollars_amount;
    cout << "How many one dollars do you have?" << endl;
    cin >> one_dollars_amount;

    pennies = (pennies_amount == 1)? "penny" : "pennies";
    nickels = (nickels_amount == 1)? "nickel" : "nickels";
    dimes  = (dimes_amount == 1)? "dime" : "dimes";
    quarters  = (quarters_amount == 1)? "quarter" : "quarters";
    half_dollars  = (half_dollars_amount == 1)? "half dollar" : "half dollars";
    one_dollars  = (one_dollars_amount == 1)? "one dollar" : "one dollars";
    #include <iomanip>
    
    cout << "You have " << std::setw(30) << pennies_amount <<" " << \
pennies<< endl
    << "You have " << std::setw(30) << nickels_amount << " " << \
nickels<< endl
    << "You have " << std::setw(30) << dimes_amount << " " << \
dimes<< endl
    << "You have " << std::setw(30) << quarters_amount << " " << \
quarters << endl
    << "You have " << std::setw(30) << half_dollars_amount << " " << \
half_dollars << endl
    << "You have " << std::setw(30) << one_dollars_amount << " " << \
one_dollars << endl;
    cent_value = get_value(pennies_amount, nickels_amount,
                            dimes_amount, quarters_amount,
                            half_dollars_amount, one_dollars_amount);
    double dollar_value = double(cent_value)/100;
    cout << "The value of all your coins is "<< "$" << std::setw(5) << dollar_value << endl;

}
double inch_to_cm(double inch)
{
    const double cm_per_inch = 2.54;
    double cm = inch*cm_per_inch;
    return cm;
}
double cm_to_inch(double cm){
    const double cm_per_inch = 2.54;
    double inch = cm / cm_per_inch;
    return inch;
}
void convert_cm_inch()
{
    cout << "This program converts inches to centimeters and vice versa" << endl;
    int length = 0;
    string unit = "";
    cout << "Please enter a length followed by a unit (cm or in): " << endl;
    cin >> length >> unit;
    
    if (unit == "in")
        cout << length << " in == " << inch_to_cm(length) << "cm" << endl;
    else if( unit == "cm")
        cout << length << " cm == " << cm_to_inch(length) << "in" << endl;
    else
        cout << "I don't know the unit \"" << unit <<"\"" << endl;
}
void conver_cm_inch_switch()
{
    cout << "This program converts inches to centimeters and vice versa" << endl;
    int length = 0;
    char unit = ' ';
    cout << "Please enter a length followed by a unit (c or i): " << endl;
    cin >> length >> unit;
    
    switch (unit) {
        case 'i':
            cout << length << " in == " << inch_to_cm(length) << "cm" << endl;
            break;
        case 'c':
            cout << length << " cm == " << cm_to_inch(length) << "in" << endl;
            break;
        default:
            cout << "I don't know the unit \"" << unit <<"\"" << endl;
    }
}
int old_square(int x)
{
    int out = 0;
    for (int i = 0 ; i < x; ++i)
        out += x;
    return out;
}
int square(int i)
{
    return i * i;
}
void loop_experiment()
{
    int i = 0;
    while ( i < 100)
    {
        cout << i << "\t" << old_square(i) <<"\t" << square(i)<< endl;
        ++i;
    }
}
void loop_ascii_table()
{
    int i = '!';
    while ( i <= '~')
    {
        cout << i << "\t" << char(i) << "\n";
        ++i;
    }
    cout << endl;
}
template<typename E>
void cin_vector(vector<E>& any_vector)
{
    E element;
    while ( cin >> element )
        any_vector.push_back(element);
}
double sum_doubles(vector<double>& doubles)
{
    double sum = 0.0;
    for ( int i = 0 ; i < doubles.size(); ++i)
        sum += doubles[i];
    return sum;
}
double average(double a, double b)
{
    return (a+b)/2;
}
double median(vector<double>& doubles)
{
    int size = doubles.size();
    
    if(size%2 == 0)
    {
        if(size==1) return doubles[0];
        int mid_left = size/2 - 1;
        int mid_right = size/2;
        double a = doubles[mid_left];
        double b = doubles[mid_right];
        return average(a,b);
    }
    else
    {
        return doubles[size/2];
    }
}
void temps()
{
    vector<double> temps;
    cout << "This program receives a series of temperatures and respond with the average and median" << endl;
    cin_vector(temps);
    double sum = sum_doubles(temps);
    double average_temp = sum/temps.size();
    cout << "Average temperature : "<< average_temp << endl;
    sort(temps.begin(),temps.end()); // sorts temps from end to end
    double median_temp = median(temps);
    cout << "Median temperature : "<< median_temp << endl;
}
void words()
{
    vector<string> words;
    cout<< "This program recevies a series of words and respond with a list of them sorted" << endl;
    cin_vector(words);
    cout << "Number of words: " << words.size() << endl;
    sort(words.begin(), words.end());
    
    for ( int i = 0; i < words.size() ; ++i)
    {
        bool is_new_word = (i==0 || words[i-1]!= words[i]);
        if(is_new_word) cout << words[i] << "\n";
    }
}
void read_two_doubles()
{
    double biggest,smallest,temp;
    cout<<":" <<endl;
    cin >> temp;
    biggest = smallest = temp;
    cout << temp <<"(first number)"<< endl;
    while(cin >> temp)
    {
        if(biggest < temp)
        {
            biggest= temp;
            cout <<temp << "(biggest so far)";
        }
        else if(smallest > temp)
        {
            smallest = temp;
            cout<< temp << "(smallest so far)";
        }
        else
            cout << temp;
        cout << endl;
    }
}
double to_m(double length, string unit)
{
    const double cm_over_m = 100;
    const double cm_over_in = 2.54;
    const double in_over_ft = 12;
    const double cm_over_ft = cm_over_in*in_over_ft/cm_over_m;
    if (unit == "in") return length*cm_over_in/cm_over_m;
    else if(unit == "ft") return length*cm_over_ft/cm_over_m;
    else if(unit == "m") return length;
    else if(unit == "cm") return length/cm_over_m;
    else throw invalid_argument("Unssuported unit \"" + unit + "\"");
}
void read_two_lengths()
{
    double biggest,smallest,length;
    vector<double> length_m(0);
    //this program converts everything to m to compare
    string unit;
    cout<<":" <<endl;
    cin >> length >> unit;
    try
    {
    biggest = smallest = to_m(length,unit);
    length_m.push_back(to_m(length,unit));
    }
    catch(invalid_argument)
    {
        cout << "Unit rejected: "<<unit << endl;
        exit(0);
    }
    cout << length << " " << unit
    <<"(first number)"<< endl;
    while(cin >> length >> unit)
    {
        try
        {
            length_m.push_back(to_m(length,unit));
        }
        catch(invalid_argument)
        {
            cout << "Unit rejected: "<<unit << endl;
            exit(0);
        }
        if(biggest < length_m.back())
        {
            biggest= length_m.back();
            cout << length << " "
            << unit << "(biggest so far)";
        }
        else if(smallest > length_m.back())
        {
            smallest = length_m.back();
            cout << length << " "
            << unit << "(smallest so far)";
        }
        else
            cout << length << " " << unit;
        cout << endl;
    }
    //sort
    sort(length_m.begin(),length_m.end());
    //print all of vector
    for ( vector<double>::const_iterator i = length_m.begin();
         i != length_m.end(); ++i)
        cout << *i << ' ';
    cout << endl;
}
string identify_operation(string operation)
{
    if(operation=="+") return "sum";
    else if(operation=="-") return "difference";
    else if(operation=="/") return "quotient";
    else if(operation=="*") return "product";
    else if(operation=="%") return "remainder";
    else throw invalid_argument(operation+" is not an operator");
}
void calculator(){
    string operation, type_result;
    double first_operand, second_operand,result;
    cout << "This program does simple calculations (+-*/%) with two operands. Please input two operands and then the operator, e.g. 35.6 24.1 +";
    cin >> first_operand >> second_operand >> operation;
    result = do_arithmetics(operation, first_operand, second_operand);
    type_result = identify_operation(operation);
    cout<< "The "<< type_result << " of " << first_operand << " and " << second_operand <<" is " << result << endl;
}
int main() {    //C++ programs start by executing the function main
    read_two_lengths();
}