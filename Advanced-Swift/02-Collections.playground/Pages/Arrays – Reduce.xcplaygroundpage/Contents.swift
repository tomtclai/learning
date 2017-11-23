/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Reduce

Both `map` and `filter` take an array and produce a new, modified array.
Sometimes, however, you want to combine all elements into a new value. For
example, to sum up all the elements, we could write the following code:

*/

let fibs = [0, 1, 1, 2, 3, 5]
var total = 0
for num in fibs {
    total = total + num
}
total

/*:
The `reduce` method takes this pattern and abstracts two parts: the initial
value (in this case, zero), and the function for combining the intermediate
value (`total`) and the element (`num`). Using reduce, we can write the same
example like this:

*/

let sum = fibs.reduce(0) { total, num in total + num }

/*:
Operators are functions too, so we could've also written the same example like
this:

*/

fibs.reduce(0, +)

/*:
The output type of reduce doesn't have to be the same as the element type. For
example, if we want to convert a list of integers into a string, with each
number followed by a space, we can do the following:

*/

fibs.reduce("") { str, num in str + "\(num), " }

/*:
Here's the implementation for `reduce`:

*/

extension Array {
    func reduce_sample_impl<Result>(_ initialResult: Result, 
        _ nextPartialResult: (Result, Element) -> Result) -> Result 
    {
        var result = initialResult
        for x in self {
            result = nextPartialResult(result, x)
        }
        return result
    }
}

/*:
Another performance tip: `reduce` is very flexible, and it's common to see it
used to build arrays and perform other operations. For example, you can
implement `map` and `filter` using only `reduce`:

*/

extension Array {
    func map_sample_impl2<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) {
            $0 + [transform($1)]
        }
    }

    func filter_sample_impl2(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) {
            isIncluded($1) ? $0 + [$1] : $0
        }
    }
}

/*:
This is kind of beautiful and has the benefit of not needing those icky
imperative `for` loops. But Swift isn't Haskell, and Swift arrays aren't lists.
What's happening here is that every time, through the combine function, a brand
new array is being created by appending the transformed or included element to
the previous one. This means that both these implementations are `O(n^2)`, not
`O(n)` — as the length of the array increases, the time these functions take
increases quadratically.

*/


/*:
There's a second version of `reduce`, which has a different type. Specifically,
the function for combining an intermediate result and an element now takes
`Result` as an `inout` parameter:

``` swift-example
public func reduce<Result>(into initialResult: Result,
    _ updateAccumulatingResult:
        (_ partialResult: inout Result, Element) throws -> ()
  ) rethrows -> Result
```

We discuss `inout` parameters in detail in the chapter on structs and classes,
but for now, think of the `inout Result` parameter as a mutable parameter: we
can modify it within the function. This allows us to write `filter` in a much
more efficient way:

*/

extension Array {
    func filter_sample_impl3(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce(into: []) { result, element in
            if isIncluded(element) {
                result.append(element)
            }
        }
    }
}

/*:
When using `inout`, the compiler doesn't have to create a new array each time,
so this version of `filter` is again `O(n)`. When the call to `reduce(into:_:)`
is inlined by the compiler, the generated code is often the same as when using a
`for` loop.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
