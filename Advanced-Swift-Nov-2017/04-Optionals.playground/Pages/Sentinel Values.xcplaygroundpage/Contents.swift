/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Optionals 

## Sentinel Values

An extremely common pattern in programming is to have an operation that may or
may not return a value.

Perhaps not returning a value is an expected outcome when you've reached the end
of a file you were reading, as in the following C snippet:

``` c
int ch;
while ((ch = getchar()) != EOF) {
    printf("Read character %c\n", ch);
}
printf("Reached end-of-file\n");
```

`EOF` is just a `#define` for `-1`. As long as there are more characters in the
file, `getchar` returns them. But if the end of the file is reached, `getchar`
returns `-1`.

Or perhaps returning no value means "not found," as in this bit of C++:

``` cpp
auto vec = {1, 2, 3};
auto iterator = std::find(vec.begin(), vec.end(), someValue);
if (iterator != vec.end()) {
    std::cout << "vec contains " << *iterator << std::endl;
}
```

Here, `vec.end()` is the iterator "one past the end" of the container; it's a
special iterator you can check against the container's end but that you mustn't
ever actually use to access a value — similar to a collection's `endIndex` in
Swift. The `find` function uses it to indicate that no such value is present in
the container.

Or maybe the value can't be returned because something went wrong during the
function's processing. Probably the most notorious example is that of the null
pointer. This innocuous-looking piece of Java code will likely throw a
`NullPointerException`:

``` java
int i = Integer.getInteger("123")
```

It happens that `Integer.getInteger` doesn't parse strings into integers, but
rather gets the integer value of a system property named "123." This property
probably doesn't exist, in which case `getInteger` returns `null`. When the
`null` then gets unboxed into an `int`, Java throws an exception.

Or take this example in Objective-C:

``` objc
[[NSString alloc] initWithContentsOfURL:url 
    encoding:NSUTF8StringEncoding error:&e];
```

Here, the `NSString` might be `nil`, in which case — and only then — the error
pointer should be checked. There's no guarantee the error pointer is valid if
the result is non-`nil`.

In all of the above examples, the function returns a special "magic" value to
indicate that it hasn't returned a real value. Magic values like these are
called "[sentinel values](https://en.wikipedia.org/wiki/Sentinel_value)."

But this approach is problematic. The result returned looks and feels like a
real value. An `int` of `-1` is still a valid integer, but you don't ever want
to print it out. `v.end()` is an iterator, but the results are undefined if you
try to use it. And everyone loves seeing a stack dump when your Java program
throws a `NullPointerException`.

Unlike Java, Objective-C allows sending messages to `nil`. This is "safe" in so
far as the runtime guarantees that the return value from a message to `nil` will
always be the equivalent of zero, i.e. `nil` for object return types, `0` for
numeric types, and so on. If the message returns a struct, it'll have all its
members initialized to zero. With this in mind, consider the following snippet:

``` objc
NSString *someString = ...;
if ([someString rangeOfString:@"Swift"].location != NSNotFound) {
    NSLog(@"Someone mentioned Swift!");
}
```

If `someString` is `nil`, whether accidentally or on purpose, the
`rangeOfString:` message will return a zeroed `NSRange`. Hence, its `.location`
will be zero, and the inequality comparison against `NSNotFound` (which is
defined as `NSIntegerMax`) will succeed. Therefore, the body of the `if`
statement will be executed when it shouldn't be.

Null references cause so many problems that [Tony
Hoare](https://en.wikipedia.org/wiki/Tony_Hoare), credited with their creation
in 1965, calls them his "billion-dollar mistake":

> At that time, I was designing the first comprehensive type system for
> references in an object oriented language (ALGOL W). My goal was to ensure
> that all use of references should be absolutely safe, with checking performed
> automatically by the compiler. But I couldn't resist the temptation to put in
> a null reference, simply because it was so easy to implement. This has led to
> innumerable errors, vulnerabilities, and system crashes, which have probably
> caused a billion dollars of pain and damage in the last forty years.

We've seen that sentinel values are error-prone — you can forget to check the
sentinel value and accidentally use it. They also require prior knowledge.
Sometimes there's an idiom that's widely followed in a community, as with the
C++ `end` iterator or the error handling conventions in Objective-C. If such
rules don't exist or you're not aware of them, you have to refer to the
documentation. Moreover, there's no way for the function to indicate it *can't*
fail. If a call returns a pointer, that pointer might never be `nil`. But
there's no way to tell except by reading the documentation, and even then, the
documentation might be wrong.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
