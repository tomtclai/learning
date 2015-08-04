// Case 1: ParamType is a reference, not a Universal reference
// ParamType is a reference or pointer but not a universal reference
template<typename T>
void f(T& param);       // param is a reference

int x = 27;
const int cx = x;
const int& rx = x;

f(x);       // T: int           param: int&
f(cx);      // T: const int     param: const int&
f(rx);      // T: const int     param: const int&


// If we change the type of f's parameter...
template<typename T>
void f(const T& param);

int x = 27;
const int cx = x;
const int& rx = x;

// Because we're assuming that param is a reference-to-const
// there's no need for const to be part of T
f(x);       // T: int           param: const int&
f(cx);      // T: int           param: const int&
f(rx);      // T: int           param: const int&

// Case 2: ParamType is a Universal reference
template<typename T>
void f(T&& param);       // param is a universal reference

int x = 27;
const int cx = x;
const int& rx = x;

// Item 24 explain this
f(x);       // T: int&          param: int&
f(cx);      // T: const int&    param: const int&
f(rx);      // T: const int&    param: const int&
f(27);      // T: int           param: int&&
