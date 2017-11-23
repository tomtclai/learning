/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Introducing Generics

Suppose we need to write a function that, given an array of integers, computes a
new array, where every integer in the original array has been incremented by
one. Such a function is easy to write using a single `for` loop:

*/

func increment(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(x + 1)
    }
    return result
}

/*:
Now suppose we also need a function that computes a new array, where every
element in the argument array has been doubled. This is also easy to do using a
`for` loop:

*/

func double(array: [Int]) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(x * 2)
    }
    return result
}

/*:
Both of these functions share a lot of code. Can we abstract over the
differences and write a single, more general function that captures this
pattern? Such a function would need a second argument that takes a function,
which computes a new integer from an individual element of the array:

*/

func compute(array: [Int], transform: (Int) -> Int) -> [Int] {
    var result: [Int] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

/*:
Now we can pass different arguments, depending on how we want to compute a new
array from the old array. The `double` and `increment` functions become
one-liners that call `compute`:

*/

func double2(array: [Int]) -> [Int] {
    return compute(array: array) { $0 * 2 }
}

/*:
This code is still not as flexible as it could be. Suppose we want to compute a
new array of booleans, describing whether the numbers in the original array were
even or not. We might try to write something like this:

``` swift-example
func isEven(array: [Int]) -> [Bool] {
    compute(array: array) { $0 % 2 == 0 }
}
```

Unfortunately, this code gives a type error. The problem is that our
`computeIntArray` function takes an argument of type `(Int) -> Int`, that is, a
function that returns an integer. In the definition of `isEvenArray`, we're
passing an argument of type `(Int) -> Bool`, which causes the type error.

How should we solve this? One thing we *could* do is define a new overload of
`compute(array:transform:)` that takes a function argument of type `(Int) ->
Bool`. That might look something like this:

*/

func compute(array: [Int], transform: (Int) -> Bool) -> [Bool] {
    var result: [Bool] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

/*:
This doesn't scale very well though. What if we need to compute a `String` next?
Do we need to define yet another higher-order function, expecting an argument of
type `(Int) -> String`?

Luckily, there's a solution to this problem: we can use
[generics](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html).
The definitions of `computeBoolArray` and `computeIntArray` are identical; the
only difference is in the *type signature*. If we were to define another
version, `computeStringArray`, the body of the function would be the same again.
In fact, the same code will work for *any* type. What we really want to do is
write a single generic function that will work for every possible type:

*/

func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

/*:
The most interesting thing about this piece of code is its type signature. To
understand this type signature, it may help you to think of
`genericComputeArray<T>` as a family of functions. Each choice of the *type*
parameter `T` determines a new function. This function takes an array of
integers and a function of type `(Int) -> T` as arguments and returns an array
of type `[T]`.

There's no reason for this function to operate exclusively on input arrays of
type `[Int]`, so we generalize it even further:

*/

func map<Element, T>(_ array: [Element], transform: (Element) -> T) -> [T] {
    var result: [T] = []
    for x in array {
        result.append(transform(x))
    }
    return result
}

/*:
Here we've written a function, `map`, that's generic in two dimensions: for any
array of `Element`s and function `transform: (Element) -> T`, it'll produce a
new array of `T`s. This `map` function is even more generic than the
`genericCompute` function we saw earlier. In fact, we can define
`genericCompute` in terms of `map`:

*/

func genericCompute2<T>(array: [Int], transform: (Int) -> T) -> [T] {
    return map(array, transform: transform)
}

/*:
Once again, the definition of the function isn't that interesting: given two
arguments, `array` and `transform`, apply `map` to `(array, transform)` and
return the result. The types are the most interesting thing about this
definition. The `genericCompute2(array:transform:)` is an instance of the `map`
function, only it has a more specific type.

Instead of defining a top-level `map` function, it actually fits in better with
Swift's conventions to define `map` in an extension to `Array`:

*/

extension Array {
    func map_sample_impl<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

/*:
The `Element` type we use in the definition of the function's `transform`
argument comes from Swift's definition of `Array` being generic over `Element`.

Instead of writing `map(array, transform: transform)`, we can now call `Array`'s
`map` function by writing `array.map(transform)`:

*/

func genericCompute3<T>(array: [Int], transform: (Int) -> T) -> [T] {
    return array.map(transform)
}

/*:
You'll be glad to hear that you actually don't have to define the `map` function
yourself this way, because it's already part of Swift's standard library
(actually, it's defined on the `Sequence` protocol, but we'll get to that later
in the chapter about iterators and sequences). The point of this chapter is
*not* to argue that you should define `map` yourself; we want to show you that
there's no magic involved in the definition of `map` — you *could* have easily
defined it yourself\!

### Top-Level Functions vs. Extensions

You might have noticed that we've used two different styles of declaring
functions in this section: top-level functions, and extensions on the type they
operate on. As long as we were in the process of motivating the `map` function,
we showed examples as top-level functions for the sake of simplicity. However,
in the end, we've defined the final generic version of `map` as an extension on
`Array`, similar to how it's defined in Swift's standard library.

In the standard library's first iteration, top-level functions were still
pervasive, but with Swift 2, the language has clearly moved away from this
pattern. With protocol extensions, third-party developers now have a powerful
tool for defining their own extensions — not only on specific types like
`Array`, but also on protocols like `Sequence`.

We recommend following this convention and defining functions that operate on a
certain type as extensions to that type. This has the advantage of better
autocompletion, less ambiguous naming, and (often) more clearly structured code.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
