/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Applicative Functors

Many functors also support other operations aside from `map`. For example, the
parsers from Chapter 12 weren't only functors, but they also defined the
following operation:

``` swift-example
func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) 
    -> Parser<B> {
```

The `<*>` operator sequences two parsers: the first parser returns a function,
and the second parser returns an argument for this function. The choice for this
operator is no coincidence. Any type constructor for which we can define
appropriate `pure` and `<*>` operations is called an *applicative functor*. To
be more precise, a functor `F` is applicative when it supports the following
operations:

``` swift-example
func pure<A>(_ value: A) -> F<A>
func <*><A, B>(f: F<A -> B>, x: F<A>) -> F<B>
```

We didn't define `pure` for `Parser`, but it's very easy to do so yourself.
Applicative functors have been lurking in the background throughout this book.
For example, the `Region` struct defined above is also an applicative functor:

*/

// --- (Hidden code block) ---
struct Position {
    var x: Double
    var y: Double
}

struct Region<T> {
    let value: (Position) -> T
}
// ---------------------------
precedencegroup Apply { associativity: left }
infix operator <*>: Apply

func pure<A>(_ value: A) -> Region<A> {
    return Region { pos in value }
}

func <*><A, B>(regionF: Region<(A) -> B>, regionX: Region<A>) -> Region<B> {
    return Region { pos in regionF.value(pos)(regionX.value(pos)) }
}

/*:
Now the `pure` function always returns a constant value for every region. The
`<*>` operator distributes the position to both its region arguments, which
yields a function of type `A -> B` and a value of type `A`. It then combines
these in the obvious manner, by applying the resulting function to the argument.

Many of the functions defined on regions can be described succinctly using these
two basic building blocks. Here are a few example functions — inspired by
Chapter 2 — written in applicative style:

*/

func everywhere() -> Region<Bool> {
    return pure(true)
}

func invert(region: Region<Bool>) -> Region<Bool> {
    return pure(!) <*> region
}

func intersection(region1: Region<Bool>, region2: Region<Bool>)
    -> Region<Bool>
{
    let and: (Bool, Bool) -> Bool = { $0 && $1 }
    return pure(curry(and)) <*> region1 <*> region2
}

/*:
This shows how the applicative instance for the `Region` type can be used to
define pointwise operations on regions.

Applicative functors aren't limited to regions and parsers. Swift's built-in
optional type is another example of an applicative functor. The corresponding
definitions are fairly straightforward:

*/

func pure<A>(_ value: A) -> A? {
    return value
}

func <*><A, B>(optionalTransform: ((A) -> B)?, optionalValue: A?) -> B? {
    guard let transform = optionalTransform,
          let value = optionalValue else { return nil }
    return transform(value)
}

/*:
The `pure` function wraps a value into an optional. This is usually handled
implicitly by the Swift compiler, so it's not very useful to define ourselves.
The `<*>` operator is more interesting: given a (possibly `nil`) function and a
(possibly `nil`) argument, it returns the result of applying the function to the
argument when both exist. If either argument is `nil`, the whole function
returns `nil`. We can give similar definitions for `pure` and `<*>` for the
`Result` type from Chapter 8.

By themselves, these definitions may not be very interesting, so let's revisit
some of our previous examples. You may want to recall the `addOptionals`
function, which tried to add two possibly `nil` integers:

``` swift-example
func addOptionals(optionalX: Int?, optionalY: Int?) -> Int? {
    guard let x = optionalX, y = optionalY else { return nil }
    return x + y
}
```

Using the definitions above, we can give a short alternative definition of
`addOptionals` using a single `return` statement:

*/

// --- (Hidden code block) ---
func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}
// ---------------------------
func addOptionals(optionalX: Int?, optionalY: Int?) -> Int? {
    return pure(curry(+)) <*> optionalX <*> optionalY
}

/*:
Once you understand the control flow that operators like `<*>` encapsulate, it
becomes much easier to assemble complex computations in this fashion.

There's one other example from the optionals chapter that we'd like to revisit:

``` swift-example
func populationOfCapital(country: String) -> Int? {
    guard let capital = capitals[country], population = cities[capital]
        else { return nil }
    return population * 1000
}
```

Here we consulted one dictionary, `capitals`, to retrieve the capital city of a
given country. We then consulted another dictionary, `cities`, to determine each
city's population. Despite the obvious similarity to the previous `addOptionals`
example, this function *cannot* be written in applicative style. Here's what
happens when we try to do so:

``` swift-example
func populationOfCapital(country: String) -> Int? {
    return { pop in pop * 1000 } <*> capitals[country] <*> cities[...]
}
```

The problem is that the *result* of the first lookup, which was bound to the
`capital` variable in the original version, is needed in the second lookup.
Using only the applicative operations, we quickly get stuck: there's no way for
the result of one applicative computation (`capitals[country]`) to influence
another (the lookup in the `cities` dictionary). To deal with this, we need yet
another interface.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
