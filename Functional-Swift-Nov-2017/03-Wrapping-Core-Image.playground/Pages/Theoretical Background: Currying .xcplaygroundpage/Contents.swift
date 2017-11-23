/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Theoretical Background: Currying 

In this chapter, we've repeatedly written code like this:

``` swift-example
blur(radius: radius)(image)
```

First we call a function that returns a function (a `Filter` in this case), and
then we call this resulting function with another argument. We could've written
the same thing by simply passing two arguments to the `blur` function and
returning the image directly:

``` swift-example
let blurredImage = blur(image: image, radius: radius)
```

Why did we take the seemingly more complicated route and write a function that
returns a function, just to call the returned function again?

It turns out there are two equivalent ways to define a function that takes two
(or more) arguments. The first style is familiar to most programmers:

*/

func add1(_ x: Int, _ y: Int) -> Int {
    return x + y
}

/*:
The `add1` function takes two integer arguments and returns their sum. In Swift,
however, we can define another version of the same function:

*/

func add2(_ x: Int) -> ((Int) -> Int) {
    return { y in x + y }
}

/*:
The function `add2` takes one argument, `x`, and returns a *closure*, expecting
a second argument, `y`. This is exactly the same structure we used for our
filter functions.

Because the function arrow is *right-associative*, we can remove the parentheses
around the result function type. As a result, the function `add3` is exactly the
same as `add2`:

*/

func add3(_ x: Int) -> (Int) -> Int {
    return { y in x + y }
}

/*:
The difference between the two versions of `add` lies at the call site:

*/

add1(1, 2)
add2(1)(2)

/*:
In the first case, we pass both arguments to `add1` at the same time; in the
second case, we first pass the first argument, `1`, which returns a function,
which we then apply to the second argument, `2`. Both versions are equivalent:
we can define `add1` in terms of `add2`, and vice versa.

The `add1` and `add2` examples show how we can always transform a function that
expects multiple arguments into a series of functions that each expects one
argument. This process is referred to as *currying*, named after the logician
Haskell Curry; we say that `add2` is the *curried* version of `add1`.

So why is currying interesting? As we've seen in this book thus far, there are
scenarios where you want to pass functions as arguments to other functions. If
we have *uncurried* functions, like `add1`, we can only apply a function to
*both* its arguments at the same time. On the other hand, for a *curried*
function, like `add2`, we have a choice: we can apply it to one *or* two
arguments.

The functions for creating filters that we've defined in this chapter have all
been curried — they all expected an additional image argument. By writing our
filters in this style, we were able to compose them easily using the `>>>`
operator. Had we instead worked with *uncurried* versions of the same functions,
it still would've been possible to write the same filters. These filters,
however, would all have a slightly different type, depending on the arguments
they expect. As a result, it'd be much harder to define a single composition
operator for the many different types that our filters might have.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
