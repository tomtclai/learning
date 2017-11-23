/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Overloading with Generic Constraints

You'll often encounter overloading in conjunction with generic code when the
same operation can be expressed with multiple algorithms that each require
different constraints on their generic parameters. Suppose we want to determine
if all the entries in one array are also contained in another. In other words,
we want to find out if the first array is a *subset* of the second (keeping in
mind that the element order is inconsequential). The standard library provides a
method named `isSubset(of:)` that does this, but only for types that conform to
the `SetAlgebra` protocol, such as `Set`.

If we wanted to write a version of `isSubset(of:)` that works with a broader set
of types, it'd look something like this:

*/

extension Sequence where Element: Equatable {
    /// Returns true iff all elements in `self` are also in `other`.
    func isSubset(of other: [Element]) -> Bool {
        for element in self {
            guard other.contains(element) else {
                return false
            }
        }
        return true
    }
}

let oneToThree = [1,2,3]
let fiveToOne = [5,4,3,2,1]
oneToThree.isSubset(of: fiveToOne)

/*:
`isSubset` is defined as an extension on the `Sequence` protocol, where the
elements of the sequence are `Equatable`. It takes an array of the same type to
check against, and it returns `true` if every single element in the receiver is
also a member of the argument array. The method doesn't care about what the
elements are, just so long as they conform to `Equatable`, because only
equatable types can be used with `contains`. The element type can be an `Int`, a
`String`, or your own custom user-defined class, just so long as it's equatable.

This version of `isSubset` comes with a big downside, which is performance. The
algorithm has performance characteristics of `O(nm)`, where *n* and *m* are the
element counts of the two arrays. That is, as the input sizes grow, the
worst-case time the function takes to run grows quadratically. This is because
`contains` runs in linear time on arrays, i.e. `O(m)`. This makes sense if you
think about what it needs to do: loop over the contents of the source sequence,
checking if they match a given element. But our algorithm calls `contains`
inside another loop — the one over the receiver's elements — which *also* runs
in linear time in a similar fashion. And running an `O(m)` loop inside an `O(n)`
loop results in an `O(nm)` function.

We can write a better-performing version by tightening the constraints on the
sequence's element type. If we require the elements to conform to `Hashable`, we
can convert the `other` array into a `Set`, taking advantage of the fact that a
set performs lookups in constant time:

*/

extension Sequence where Element: Hashable {
    /// Returns true iff all elements in `self` are also in `other`.
    func isSubset(of other: [Element]) -> Bool {
        let otherSet = Set(other)
        for element in self {
            guard otherSet.contains(element) else {
                return false
            }
        }
        return true
    }
}

/*:
With the `contains` check taking `O(1)` time (assuming a uniform distribution of
the hashes), the entire `for` loop now becomes `O(n)` — the time required grows
linearly with the number of elements in the receiver. The additional cost of
converting `other` into a set is `O(m)`, but we incur it only once, outside the
loop. Thus, the total cost becomes `O(n+m)`, which is much better than the
`O(nm)` for the `Equatable` version — if both arrays have 1,000 elements, it's
the difference between 2,000 and one million iterations.

So now we have two versions of the algorithm, none of which is clearly better
than the other — one is faster, and the other works with a wider range of types.
The good news is that you don't have to pick one of these options. You can
implement both overloads of `isSubset` and let the compiler select the most
appropriate one based on the argument types. Swift is very flexible about
overloading — you can overload not just by input type or return type, but also
based on different constraints on a generic placeholder, as seen in this
example.

The general rule that the type checker will pick the most specific overload it
can find also applies here. Both versions of `isSubset` are generic, so the rule
that non-generic variants are favored over generic ones is no help. But the
version that requires the elements to be `Hashable` is more specific, because
`Hashable` extends `Equatable`, and thus it imposes more constraints. Given that
these constraints are probably there to make the algorithm more efficient — as
they are in the case of `isSubset` — the compiler works on the assumption that
the more specific function is the better choice.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
