/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Algebra of Data Types

As we mentioned previously, enumerations are often referred to as sum types.
This may be a confusing name, as enumerations seem to have no relation to
numbers. Yet if you dig a little deeper, you may find that enumerations and
tuples have mathematical structure, very similar to arithmetic.

Before we explore this structure, we need to consider the question of when two
types are the same. This may seem like a very strange question to ask — isn't it
obvious that `String` and `String` are equal, but `String` and `Int` are not?
However, as soon as you add generics, enumerations, structs, and functions to
the mix, the answer isn't so obvious. Such a simple question is still the
subject of active research exploring the [very foundations of
mathematics](http://homotopytypetheory.org). For the purpose of this subsection,
we'll study when two types are *isomorphic*.

Intuitively, the two types `A` and `B` are isomorphic if we can convert between
them without losing any information. We need to have two functions, `f: (A) ->
B` and `g: (B) -> A`, which are the inverse of one another. More specifically,
for all `x: A`, the result of calling `g(f(x))` must be equal to `x`; similarly,
for all `y: B`, the result of `f(g(y))` must be equal to `y`. This definition
crystallizes the intuition we stated above: we can convert freely between the
types `A` and `B` using `f` and `g` without ever losing information (as we can
always undo `f` using `g`, and vice versa). This definition isn't precise enough
for most programming purposes — 64 bits can be used to represent integers or
memory addresses, even if these are two very different concepts. They'll be
useful, however, as we study the algebraic structure of types.

To begin with, consider the following enumeration:

*/

enum Add<T, U> {
    case inLeft(T)
    case inRight(U)
}

/*:
Given two types, `T` and `U`, the enumeration `Add<T, U>` consists of either a
value of type `T` or a value of type `U`. As its name suggests, the `Add`
enumeration adds together the cases from the types `T` and `U`: if `T` has three
cases and `U` has seven, `Add<T, U>` will have ten possible cases. This
observation provides further insight into why enumerations are called sum types.

In arithmetic, zero is the unit of addition, i.e., `x + 0` is the same as using
just `x` for any number `x`. Can we find an enumeration that behaves like zero?
Interestingly, Swift allows us to define the following enumeration:

*/

enum Zero { }

/*:
This enumeration is empty — it doesn't have any cases. As we hoped, it behaves
exactly like the zero of arithmetic: for any type `T`, the types `Add<T, Zero>`
and `T` are isomorphic. It's fairly easy to prove this. We can use `inLeft` to
define a function converting `T` to `Add<T,Zero>`, and the conversion in the
other direction can be done by pattern matching.

> In Swift 3, a `Never` type was added to the standard library. `Never` has
> exactly the same definition as `Zero`: it can be used as a return type for
> functions that never return. In functional languages, this is also sometimes
> called the *bottom* type.

So much for addition — let's now consider multiplication. If we have an
enumeration, `T`, with three cases, and another enumeration, `U`, with two
cases, how can we define a compound type, `Times<T, U>`, with six cases? To do
this, the `Times<T, U>` type should allow us to choose *both* a case of `T` and
a case of `U`. In other words, it should correspond to a pair of two values of
type `T` and `U` respectively:

*/

typealias Times<T, U> = (T, U)

/*:
Just as `Zero` was the unit of addition, the void type, `()`, is the unit of
`Times`:

*/

typealias One = ()

/*:
It's easy to check that many familiar laws from arithmetic are still valid when
read as isomorphisms between types:

  - `Times<One, T>` is isomorphic to `T`

  - `Times<Zero, T>`is isomorphic to `Zero`

  - `Times<T, U>` is isomorphic to `Times<U, T>`

Types defined using enumerations and structs are sometimes referred to as
*algebraic data types*, because they have this algebraic structure, similar to
natural numbers.

This correspondence between numbers and types runs much deeper than what we've
sketched here. Functions can be shown to correspond to exponentiation. There's
even [a notion of differentiation](http://strictlypositive.org/calculus) that
can be defined on types\!

This observation may not be of much practical value. Rather it shows how
enumerations, like many of Swift's features, aren't new, but instead draw on
years of research in mathematics and program language design.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
