/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Parameterizing Behavior with Closures

The `isSubset` method is still not as general as it could be. What about
sequences where the elements aren't equatable? Arrays, for example, aren't
equatable, and if we use them as elements, it won't work with our current
implementation. Arrays do have an `==` operator, defined like this:

``` swift-example
/// Returns true if these arrays contain the same elements.
func ==<Element: Equatable>(lhs: [Element], rhs: [Element]) -> Bool
```

But that doesn't mean you can use them with `isSubset`:

*/

// --- (Hidden code block) ---
extension Sequence where Element: Equatable {
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Element == Element
    {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

extension Sequence where Element: Hashable {
    /// Returns true iff all elements in `self` are also in `other`.
    func isSubset<S: Sequence>(of other: S) -> Bool
        where S.Element == Element
    {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}
// ---------------------------
/*:
``` swift-example
// Error: Type of expression is ambiguous without more context
[[1,2]].isSubset(of: [[1,2], [3,4]])
```

This is because `Array` doesn't conform to `Equatable`. It can't, because the
type the array contains might not, itself, be equatable. Swift currently lacks
support for *conditional protocol conformance*, i.e. the ability to express the
idea that `Array` (or any `Sequence`) only conforms to a protocol when certain
constraints, such as `Element: Equatable`, are met. So `Array` *can* provide an
implementation of `==` for when the contained type is equatable, but it *can't*
conform to the protocol.

So how can we make `isSubset` work with non-equatable types? We can do this by
giving control of what equality means to the caller, requiring them to supply a
function to determine equality. For example, the standard library provides a
second version of `contains` that does this:

``` swift-example
extension Sequence {
    /// Returns a Boolean value indicating whether the sequence contains an
    /// element that satisfies the given predicate.
    func contains(where predicate: (Element) throws -> Bool)
        rethrows -> Bool
}
```

That is, it takes a function that takes an element of the sequence and performs
some check. It runs the check on each element, returning `true` as soon as the
check returns `true`. This version of `contains` is much more powerful. For
example, you can use it to check for any condition inside a sequence:

*/

let isEven = { $0 % 2 == 0 }
(0..<5).contains(where: isEven)
[1, 3, 99].contains(where: isEven)

/*:
We can leverage this more flexible version of `contains` to write a similarly
flexible version of `isSubset`:

*/

extension Sequence {
    func isSubset<S: Sequence>(of other: S, 
        by areEquivalent: (Element, S.Element) -> Bool) -> Bool 
    {
        for element in self {
            guard other.contains(where: { areEquivalent(element, $0) }) else {
                return false
            }
        }
        return true
    }
}

/*:
Now, we can use `isSubset` with arrays of arrays by supplying a closure
expression that compares the arrays using `==`. Unfortunately, if we import
Foundation, another performance optimization for the type checker [confuses the
compiler](https://bugs.swift.org/browse/SR-5944) so that it no longer knows
which version of `==` to use. So we need a type annotation somewhere in the
code:

*/

[[1,2]].isSubset(of: [[1,2] as [Int], [3,4]]) { $0 == $1 }

/*:
The two sequences' elements don't even have to be of the same type, so long as
the supplied closure handles the comparison:

*/

let ints = [1,2]
let strings = ["1","2","3"]
ints.isSubset(of: strings) { String($0) == $1 }


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
