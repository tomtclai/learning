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

// Case 3: not pointer nor reference
template<typename T>
void f(T param);       // param is passed by value

int x = 27;
const int cx = x;
const int& rx = x;

f(x);       // T: int           param: int
f(cx);      // T: int           param: int
f(rx);      // T: int           param: int

const char* const ptr = "const pointer to const object"
f(ptr);     // char * const. ptr is copied so the
            // constness of the ptr itself is ignored

// Array arguments
const char name[] = "J. P. Briggs"; // names type is
                                    // const char[13]
f(name); // name is array but deduced as const char*

// there is no such thing as a function parameter that's an array
// although the syntax is legal
void myFunc(int param[]);
// it is treated as a pointer declaration
void myFunc(int * param);


// But functions can declare paramters that are *references* to arays

template<typename T>
void f(T& param);

f(name); // pass array to F, T is deduced to be const char [13]
         // f's paramter is const char(&)[13]

template<typename T, std::size_t N>
constexpr std::size_t arraySize(T (&)[N]) noexcept
{
    return N;
}

int keyVals[] = {1, 3, 7, 9, 11, 22, 35};
std::array<int, arraySize(keyVals)> mappedVals; //