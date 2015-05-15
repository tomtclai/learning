// friend functions
#include <iostream>
using namespace std;

class Rectangle {
    int width, height;
public:
    Rectangle() {}
    Rectangle (int x, int y) : width(x), height(y) {}
    int area() {return width * height;}
    friend Rectangle copyOf (const Rectangle&);
};
//The function duplicate is not a member of the class Rectangle.
Rectangle copyOf (const Rectangle& param)
{
    Rectangle res;
    res.width = param.width*2;
    res.height = param.height*2;
    return res;
}

int main () {
    Rectangle foo;
    Rectangle bar (2,3);
    foo = copyOf (bar);
    cout << foo.area() << '\n';
    return 0;
}
