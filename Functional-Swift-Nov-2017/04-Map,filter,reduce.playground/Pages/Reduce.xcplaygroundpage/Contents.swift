/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Reduce

Once again, we'll consider a few simple functions before defining a generic
function that captures a more general pattern.

It's straightforward to define a function that sums all the integers in an
array:

*/

func sum(integers: [Int]) -> Int {
    var result: Int = 0
    for x in integers {
        result += x
    }
    return result
}

/*:
We can use this `sum` function like so:

*/

sum(integers: [1, 2, 3, 4])

/*:
We can also define a `product` function that computes the product of all the
integers in an array using a similar `for` loop as `sum`:

*/

func product(integers: [Int]) -> Int {
    var result: Int = 1
    for x in integers {
        result = x * result
    }
    return result
}

/*:
Similarly, we may want to concatenate all the strings in an array:

*/

func concatenate(strings: [String]) -> String {
    var result: String = ""
    for string in strings {
        result += string
    }
    return result
}

/*:
Or, we can choose to concatenate all the strings in an array, inserting a
separate header line and newline characters after every element:

*/

func prettyPrint(strings: [String]) -> String {
    var result: String = "Entries in the array xs:\n"
    for string in strings {
        result = "  " + result + string + "\n"
    }
    return result
}

/*:
What do all these functions have in common? They all initialize a variable,
`result`, with some value. They proceed by iterating over all the elements of
the input array, updating the result somehow. To define a generic function that
can capture this pattern, there are two pieces of information we need to
abstract over: the initial value assigned to the `result` variable, and the
*function* used to update the `result` in every iteration.

We can capture this pattern with the following definition of the `reduce`
function:

*/

extension Array {
    func reduce<T>(_ initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}

/*:
This function is generic in two ways: for any *input array* of type `[Element]`,
it'll compute a result of type `T`. To do this, it needs an initial value of
type `T` (to assign to the `result` variable), and a function, `combine: (T,
Element) -> T`, which is used to update the result variable in the body of the
`for` loop. In some functional languages, such as OCaml and Haskell, `reduce`
functions are called `fold` or `fold_left`.

We can define every function we've seen in this chapter thus far using `reduce`.
Here are a few examples:

*/

func sumUsingReduce(integers: [Int]) -> Int {
    return integers.reduce(0) { result, x in result + x }
}

/*:
Instead of writing a closure, we could've also written just the operator as the
last argument. This makes the code even shorter, as illustrated by the following
two functions:

*/

func productUsingReduce(integers: [Int]) -> Int {
    return integers.reduce(1, combine: *)
}

func concatUsingReduce(strings: [String]) -> String {
    return strings.reduce("", combine: +)
}

/*:
Once again, defining `reduce` ourselves is just an exercise. Swift's standard
library already provides the `reduce` function for arrays.

We can use `reduce` to define new generic functions. For example, suppose we
have an array of arrays that we want to flatten into a single array. We could
write a function that uses a `for` loop:

*/

func flatten<T>(_ xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        result += xs
    }
    return result
}

/*:
Using `reduce`, however, we can write this function as follows:

*/

func flattenUsingReduce<T>(_ xss: [[T]]) -> [T] {
    return xss.reduce([]) { result, xs in result + xs }
}

/*:
In fact, we can even redefine `map` and `filter` using reduce:

*/

extension Array {
    func mapUsingReduce<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) { result, x in
            return result + [transform(x)]
        }
    }

    func filterUsingReduce(_ includeElement: (Element) -> Bool) -> [Element] {
        return reduce([]) { result, x in
            return includeElement(x) ? result + [x] : result
        }
    }
}

/*:
The fact that we're able to express all these other functions using `reduce`
shows how `reduce` captures a very common programming pattern in a generic way:
iterating over an array to compute a result.

> Please note: while defining everything in terms of `reduce` is an interesting
> exercise, in practice it's often a bad idea. The reason for this is that your
> code will end up making lots of copies of the resulting array during runtime,
> i.e. it has to allocate, deallocate, and copy the contents of a lot of memory.
> For example, writing `map` with a mutable result array is vastly more
> efficient than the implementation on top of `reduce`. In theory, the compiler
> could optimize the above code to be as fast as the version with the mutable
> result array, but Swift doesn't do this (yet). For more details, check out our
> [Advanced Swift](https://objc.io/books/advanced-swift) book.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
