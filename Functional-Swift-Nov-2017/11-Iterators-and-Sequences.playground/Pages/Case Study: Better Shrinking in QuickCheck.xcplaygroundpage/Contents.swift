/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Case Study: Better Shrinking in QuickCheck

In this section, we'll provide a somewhat larger case study of defining
sequences by improving the `Smaller` protocol we implemented in the QuickCheck
chapter. Originally, the protocol was defined as follows:

``` swift-example
protocol Smaller {
    func smaller() -> Self?
}
```

We used the `Smaller` protocol to try and shrink counterexamples that our
testing uncovered. The `smaller` function is repeatedly called to generate a
smaller value; if this value still fails the test, it's considered a 'better'
counterexample than the original one. The `Smaller` instance we defined for
arrays simply tried to repeatedly strip off the first element:

``` swift-example
extension Array: Smaller {
    func smaller() -> [T]? {
        guard !self.isEmpty else { return nil }
        return Array(dropFirst())
    }
}
```

While this will certainly help shrink counterexamples in *some* cases, there are
many different ways to shrink an array. Computing all possible subarrays is an
expensive operation. For an array of length `n`, there are `2^n` possible
subarrays that may or may not be interesting counterexamples — generating and
testing them isn't a good idea.

Instead, we'll show how to use an iterator to produce a series of smaller
values. We can then adapt our QuickCheck library to use the following protocol:

*/

protocol Smaller {
    func smaller() -> AnyIterator<Self>
}

/*:
When QuickCheck finds a counterexample, we can then rerun our tests on the
series of smaller values until we've found a suitably small counterexample. The
only thing we still have to do is write a `smaller` function for arrays (and any
other type we might want to shrink).

Instead of removing just the first element of the array, we'll compute a series
of arrays where each new array has one element removed. This won't produce all
possible subarrays, but rather only a sequence of arrays in which each array is
one element shorter than the original array. Using `AnyIterator`, we can define
such a function as follows:

*/

extension Array {
    func smaller() -> AnyIterator<[Element]> {
        var i = 0
        return AnyIterator {
            guard i < self.endIndex else { return nil }
            var result = self
            result.remove(at: i)
            i += 1
            return result
        }
    }
}

/*:
The iterator returned by `smaller` keeps track of a variable, `i`. When asked
for the next element, it checks whether or not `i` is less than the length of
the array. If so, it computes a new array, `result`, and increments `i`. If
we've reached the end of our original array, we return `nil`.

There's an `Array` initializer that takes a `Sequence` as argument. Using that
initializer, we can test our iterator as follows:

*/

Array([1, 2, 3].smaller())

/*:
We could go even further; instead of just removing elements, we may also want to
try and shrink the elements themselves if they conform to the `Smaller`
protocol.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
