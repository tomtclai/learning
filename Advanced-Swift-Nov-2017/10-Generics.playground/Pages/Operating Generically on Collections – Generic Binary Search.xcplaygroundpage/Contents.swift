/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Generic Binary Search

If you lift the requirement for an `Int` index, you'll hit several compiler
errors. The code needs some rewrites in order to be fully generic, so here's a
fully generic version:

*/

extension RandomAccessCollection {
    public func binarySearch(for value: Element,
        areInIncreasingOrder: (Element, Element) -> Bool) -> Index?
    {
        guard !isEmpty else { return nil }
        var left = startIndex
        var right = index(before: endIndex)
        while left <= right {
            let dist = distance(from: left, to: right)
            let mid = index(left, offsetBy: dist/2)
            let candidate = self[mid]
            if areInIncreasingOrder(candidate, value) {
                left = index(after: mid)
            } else if areInIncreasingOrder(value, candidate) {
                right = index(before: mid)
            } else {
                // If neither element comes before the other, they _must_ be
                // equal, per the strict ordering requirement of areInIncreasingOrder
                return mid
            }
        }
        // Not found
        return nil
    }
}

extension RandomAccessCollection where Element: Comparable {
    func binarySearch(for value: Element) -> Index? {
        return binarySearch(for: value, areInIncreasingOrder: <)
    }
}


/*:
The changes are small but significant. First, the `left` and `right` variables
have changed type to no longer be integers. Instead, we're using the start and
end index values. These might be integers, but they might also be opaque types
like `String`'s index type (or `Dictionary`'s or `Set`'s, not that these are
random access).

But secondly, the simple statement `(left + right) / 2` has been replaced by the
slightly uglier `index(left, offsetBy: dist/2)`, where `let dist =
distance(from: left, to: right)`. How come?

The key concept here is that there are actually two types involved in this
calculation: `Index` and `IndexDistance`. These are *not necessarily the same
thing*. When using integer indices, we happen to be able to use them
interchangeably. But loosening that requirement breaks this.

The distance is the number of times you'd need to call `index(after:)` to get
from one point in the collection to another. The end index must be "reachable"
from the start index — there's always a finite integer number of times you need
to call `index(after:)` to get to it. This means `IndexDistance` must be an
integer (though not necessarily an `Int`), and the corresponding constraint in
the definition of `Collection` is (the constraint is actually defined in
`_Indexable`, and `Collection` inherits from `_Indexable`):

``` swift-example
public protocol Collection: /* ... */ {
    /// A type that can represent the number of steps between a pair of
    /// indices.
    associatedtype IndexDistance: SignedInteger = Int
}
```

This is also why we need an extra `guard` to ensure the collection isn't empty.
When you're just doing integer arithmetic, there's no harm in generating a
`right` value of `-1` and then checking that it's less than zero. But when
dealing with any kind of index, you need to make sure you don't move back
through the start of the collection, which might be an invalid operation. (For
example, what would happen if you tried to go back one from the start of a
doubly linked list?)

Being integers, index distances can be added together or divided to find the
remainder. What we *can't* do is add two indices of any kind together, because
what would that mean? If you had the `Words` collection from the collection
protocols chapter, you obviously couldn't "add" two indices together and divide
by two. Instead, we must think only in terms of moving indices by some distance
using `index(after:)`, `index(before:)`, or `index(_:offsetBy:)`.

This way of thinking takes some getting used to if you're accustomed to thinking
in terms of arrays. But think of many array index expressions as a kind of
shorthand. For example, when we wrote `let right = count - 1`, what we really
meant was `right = index(startIndex, offsetBy: count - 1)`. It's just that when
the index is an `Int` and `startIndex` is zero, this reduces to `0 + count - 1`,
which in turn reduces to `count - 1`.

This leads us to the serious bug in the implementation that took our `Array`
code and just applied it to `RandomAccessCollection`: collections with integer
indices don't necessarily start with an index of zero, the most common example
being `ArraySlice`. A slice created via `myArray[3..<5]` will have a
`startIndex` of three. Try and use our simplistic generic binary search on it,
and it'll crash *at runtime*. While we were able to require that the index be an
integer, the Swift type system has no good way of requiring that the collection
be zero-based. And even if it did, in this case, it'd be a silly requirement to
impose, since we know a better way. Instead of adding together the left and
right indices and halving the result, we find half the distance between the two,
and then we advance the left index by that amount to reach the midpoint.

> This version also fixes the bug in our initial implementation. If you didn't
> spot it, it's that if the array is extremely large, then adding two integer
> indices together might overflow before being halved (suppose `count` was
> approaching `Int.max` and the searched-for element was the last one in the
> array). On the other hand, when adding half the distance between the two
> indices, this doesn't happen. Of course, the chances of anyone ever hitting
> this bug is very low, which is why the bug in the Java standard library took
> so long to be discovered.

Now, we can use our binary search algorithm to search
`ReversedRandomAccessCollection`:

*/

let a = ["a", "b", "c", "d", "e", "f", "g"]
let r = a.reversed()
r.binarySearch(for: "g", areInIncreasingOrder: >) == r.startIndex


/*:
And we can also search slices, which aren't zero-based:

*/

let s = a[2..<5]
s.startIndex
s.binarySearch(for: "d")


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
