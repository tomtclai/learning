/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The M-Word

In Chapter 5, we gave the following alternative definition of
`populationOfCapital`:

``` swift-example
func populationOfCapital3(country: String) -> Int? {
    return capitals[country].flatMap { capital in
        return cities[capital]
    }.flatMap { population in
        return population * 1000
    }
}
```

Here we used the built-in `flatMap` function to combine optional computations.
How is this different from the applicative interface? The types are subtly
different. In the applicative `<*>` operation, *both* arguments are optionals.
In the `flatMap` function, on the other hand, the second argument is a
*function* that returns an optional value. Consequently, we can pass the result
of the first dictionary lookup on to the second.

The `flatMap` function is impossible to define in terms of the applicative
functions. In fact, the `flatMap` function is one of the two functions supported
by *monads*. More generally, a type constructor `F` is a monad if it defines the
following two functions:

``` swift-example
func pure<A>(_ value: A) -> F<A>

func flatMap<A, B>(x: F<A>)(_ f: (A) -> F<B>) -> F<B>
```

The `flatMap` function is sometimes defined as an operator, `>>=`. This operator
is pronounced "bind," as it binds the result of the first argument to the
parameter of its second argument.

In addition to Swift's optional type, the `Result` enumeration defined in
Chapter 8 is also a monad. This insight makes it possible to chain together
computations that may return an `Error`. For example, we could define a function
that copies the contents of one file to another as follows:

``` swift-example
func copyFile(sourcePath: String, targetPath: String, encoding: Encoding)
    -> Result<()>
{
    return readFile(sourcePath, encoding).flatMap { contents in
        writeFile(contents, targetPath, encoding)
    }
}
```

If the call to either `readFile` or `writeFile` fails, the `Error` will be
logged in the result. This may not be quite as nice as Swift's optional binding
mechanism, but it's still pretty close.

There are many other applications of monads aside from handling errors. For
example, arrays are also a monad. In the standard library, `flatMap` is already
defined, but you could implement it like this:

*/

func pure<A>(_ value: A) -> [A] {
    return [value]
}

extension Array {
    func flatMap<B>(_ f: (Element) -> [B]) -> [B] {
        return map(f).reduce([]) { result, xs in result + xs }
    }
}

/*:
What have we gained from these definitions? The monad structure of arrays
provides a convenient way to define various combinatorial functions or solve
search problems. For example, suppose we need to compute the *cartesian product*
of two arrays, `xs` and `ys`. The cartesian product consists of a new array of
tuples, where the first component of the tuple is drawn from `xs`, and the
second component is drawn from `ys`. Using a `for` loop directly, we might write
this:

*/

func cartesianProduct1<A, B>(xs: [A], ys: [B]) -> [(A, B)] {
    var result: [(A, B)] = []
    for x in xs {
        for y in ys {
            result += [(x, y)]
        }
    }
    return result
}

/*:
We can now rewrite `cartesianProduct` to use `flatMap` instead of `for` loops:

*/

func cartesianProduct2<A, B>(xs: [A], ys: [B]) -> [(A, B)] {
    return xs.flatMap { x in ys.flatMap { y in [(x, y)] } }
}

/*:
The `flatMap` function allows us to take an element `x` from the first array,
`xs`; next, we take an element `y` from `ys`. For each pair of `x` and `y`, we
return the array `[(x, y)]`. The `flatMap` function handles combining all these
arrays into one large result.

While this example may seem a bit contrived, the `flatMap` function on arrays
has many important applications. Languages like Haskell and Python support
special syntactic sugar for defining lists, which are called *list
comprehensions*. These list comprehensions allow you to draw elements from
existing lists and check that these elements satisfy certain properties. They
can all be de-sugared into a combination of maps, filters, and `flatMap`. List
comprehensions are very similar to optional binding in Swift, except they work
on lists instead of optionals.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
