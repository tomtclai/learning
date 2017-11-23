/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Why Optionals?

What's the point of introducing an explicit optional type? For programmers used
to Objective-C, working with optional types may seem strange at first. The Swift
type system is rather rigid: whenever we have an optional type, we have to deal
with the possibility of it being `nil`. We've had to write new functions like
`map` to manipulate optional values. In Objective-C, you have more flexibility.
For instance, when translating the example above to Objective-C, there's no
compiler error:

``` objc
- (int)populationOfCapital:(NSString *)country
{
    return [self.cities[self.capitals[country]] intValue] * 1000;
}
```

We can pass in `nil` for the name of a country, and we get back a result of `0`.
Everything is fine. In many languages without optionals, null pointers are a
source of danger. Much less so in Objective-C. In Objective-C, you can safely
send messages to `nil`, and depending on the return type, you either get
`nil`, 0, or similar "zero-like" values. Why change this behavior in Swift?

The choice for an explicit optional type fits with the increased static safety
of Swift. A strong type system catches errors before code is executed, and an
explicit optional type helps protect you from unexpected crashes arising from
missing values.

The default zero-like behavior employed by Objective-C has its drawbacks. You
may want to distinguish a failed dictionary lookup (a key isn't in the
dictionary) from a successful lookup returning `nil` (a key is in the
dictionary, but associated with `nil`). To do that in Objective-C, you have to
use `NSNull`.

While it's safe in Objective-C to send messages to `nil`, it's often not safe to
use them.

Let's say we want to create an attributed string. If we pass in `nil` as the
argument for `country`, the `capital` will also be `nil`, but
`NSAttributedString` will crash when trying to initialize it with a `nil` value:

``` objc
- (NSAttributedString *)attributedCapital:(NSString *)country
{
    NSString *capital = self.capitals[country];
    NSDictionary *attr = @{ }; // ... 
    return [[NSAttributedString alloc] initWithString:capital attributes:attr];
}
```

While crashes like the above don't happen too often, almost every developer has
had code like this crash. Most of the time, these crashes are detected during
debugging, but it's very possible to ship code without noticing that, in some
cases, a variable might unexpectedly be `nil`. Therefore, many programmers use
asserts to explicitly document this behavior. For example, we can add an
`NSParameterAssert` to make sure we crash quickly when the `country` is `nil`:

``` objc
- (NSAttributedString *)attributedCapital:(NSString *)country
{
    NSParameterAssert(country);
    NSString *capital = self.capitals[country];
    NSDictionary *attr = @{ }; // ... 
    return [[NSAttributedString alloc] initWithString:capital attributes:attr];
}
```

But what if we pass in a `country` value that doesn't have a matching key in
`self.capitals`? This is much more likely, especially when `country` comes from
user input. In such a case, `capital` will be `nil` and our code will still
crash. Of course, this can be fixed easily enough. The point is, however, that
it's easier to write *robust* code using `nil` in Swift than in Objective-C.

Finally, using these assertions is inherently non-modular. Suppose we implement
a `checkCountry` method that checks that a non-empty `NSString *` is supported.
We can incorporate this check easily enough:

``` objc
- (NSAttributedString *)attributedCapital:(NSString*)country
{
    NSParameterAssert(country);
    if (checkCountry(country)) {
        // ...
    }
}
```

Now the question arises: should the `checkCountry` function also assert that its
argument is non-`nil`? On one hand, it shouldn't — we've just performed the
check in the `attributedCapital` method. On the other hand, if the
`checkCountry` function only works on non-`nil` values, we should duplicate the
assertion. We're forced to choose between exposing an unsafe interface or
duplicating assertions. It's also possible to add a `nonnull` attribute to the
signature, which will emit a warning when the method is called with a value that
could be `nil`, but this isn't common practice in most Objective-C codebases.

In Swift, things are better: function signatures using optionals explicitly
state which values may be `nil`. This is invaluable information when working
with other people's code. A signature like the following provides a lot of
information:

``` swift-example
func attributedCapital(country: String) -> NSAttributedString?
```

Not only are we warned about the possibility of failure, but we know that we
must pass a `String` as argument — and not a `nil` value. A crash like the one
we described above won't happen. Furthermore, this is information *checked* by
the compiler. Documentation goes out of date easily, but you can always trust
function signatures.

When dealing with scalar values, optionality is even more tricky in Objective-C.
Consider the following sample, which tries to find mentions of a specific
keyword in a string:

``` objc
NSString *someString = ...;
if ([someString rangeOfString:@"swift"].location != NSNotFound) {
    NSLog(@"Someone mentioned swift!");
}
```

It looks innocent enough: if `rangeOfString:` doesn't find the string, then the
location will be set to `NSNotFound`. `NSNotFound` is defined as `NSIntegerMax`.
This code is almost correct, and the problem is hard to see at first sight: when
`someString` is `nil`, then `rangeOfString:` will return a structure filled with
zeroes, and the `location` will return 0. The check will then succeed, and the
code inside the if-statement will be executed.

With optionals, this can't happen. If we wanted to port this code to Swift, we'd
need to make some structural changes. The above code would be rejected by the
compiler, and the type system wouldn't allow you to run `rangeOfString:` on a
`nil` value. Instead, you first need to unwrap it:

``` swift-example
if let someString = ..., 
    someString.rangeOfString("swift").location != NSNotFound {
        print("Found")
    }
}
```

The type system will help in catching subtle errors for you. Some of these
errors would've been easily detected during development, but others might
accidentally end up in production code. By using optionals consistently, this
class of errors can be eliminated automatically.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
