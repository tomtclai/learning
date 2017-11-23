/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Generics vs. the `Any` Type

Aside from generics, Swift also supports an `Any` type that can represent
[values of any
type](https://developer.apple.com/library/prerelease/mac/documentation/Swift/Conceptual/Swift_Programming_Language/TypeCasting.html).
On the surface, this may seem similar to generics. Both the `Any` type and
generics can be used to define functions accepting different types of arguments.
However, it's very important to understand the difference: generics can be used
to define flexible functions, the types of which are still checked by the
compiler; the `Any` type can be used to dodge Swift's type system (and should be
avoided whenever possible).

Let's consider the simplest possible example, which is a function that does
nothing but return its argument. Using generics, we might write the following:

*/

func noOp<T>(_ x: T) -> T {
    return x
}

/*:
Using the `Any` type, we might write the following:

*/

func noOpAny(_ x: Any) -> Any {
    return x
}

/*:
Both `noOp` and `noOpAny` will accept any argument. The crucial difference is
what we know about the value being returned. In the definition of `noOp`, we can
clearly see that the return value is the same as the input value. This isn't the
case for `noOpAny`, which may return a value of any type — even a type different
from the original input. We might also give the following erroneous definition
of `noOpAny`:

*/

func noOpAnyWrong(_ x: Any) -> Any {
    return 0
}

/*:
Using the `Any` type evades Swift's type system. However, trying to return `0`
in the body of the `noOp` function defined using generics will cause a type
error. Furthermore, any function that calls `noOpAny` doesn't know to which type
the result must be cast. There are all kinds of possible runtime exceptions that
may be raised as a result.

Finally, the *type* of a generic function is extremely informative. Consider the
following generic version of the function composition operator, `>>>`, that we
defined in the chapter Wrapping Core Image:

*/

infix operator >>>
func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> (A) -> C {
    return { x in g(f(x)) }
}

/*:
The type of this function is so generic that it completely determines how the
*function itself* is defined. We'll try to give an informal argument for this
here.

We need to produce a value of type `C`. As there's nothing else we know about
`C`, there's no value that we can return immediately. If we knew that `C` was
some concrete type, like `Int` or `Bool`, we could potentially return a value of
that type, such as `5` or `true`, respectively. But as our function must work
*for any* type `C`, we can't do this. The only argument to the `>>>` operator
that refers to `C` is the function `g: (B) -> C`. Therefore, the only way to get
our hands on a value of type `C` is by applying the function `g` to a value of
type `B`.

Similarly, the only way to produce a `B` is by applying `f` to a value of type
`A`. The only value of type `A` that we have is the final argument to our
operator. Therefore, this definition of function composition is the only
possible function that has this generic type.

In the same way, we can define a generic function that curries any function
expecting a tuple of two arguments, thereby producing the corresponding curried
version:

*/

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}

/*:
We no longer need to define two different versions of the same function, the
curried and the uncurried, as we did in the last chapter. Instead, generic
functions such as `curry` can be used to transform *functions* — computing the
curried version from the uncurried. Once again, the type of this function is so
generic that it (almost) gives a complete specification: there really is only
one sensible implementation.

Using generics allows you to write flexible functions without compromising type
safety; if you use the `Any` type, you're pretty much on your own.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
