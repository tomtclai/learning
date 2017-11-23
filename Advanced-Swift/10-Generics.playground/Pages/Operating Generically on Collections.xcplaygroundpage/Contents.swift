/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Operating Generically on Collections

Generic algorithms on collections often pose some special problems, particularly
when it comes to working with indices and slices. In this section, we'd like to
demonstrate how to deal with these problems by showing two examples that heavily
rely on the correct handling of indices and slices.

### A Binary Search

Suppose you find yourself in need of a binary search algorithm for collections.
You reach for your [nearest favorite
reference](https://algs4.cs.princeton.edu/home/), which happens to be written in
Java, and port the code to Swift. Here's one such attempt — albeit a boringly
iterative, rather than recursive, one:

*/

extension Array {
    /// Returns the first index where `value` appears in `self`, or `nil`,
    /// if `value` is not found.
    ///
    /// - Requires: `areInIncreasingOrder` is a strict weak ordering over the
    /// elements in `self`, and the elements in the array are already
    /// ordered by it.
    /// - Complexity: O(log `count`)
    func binarySearch(for value: Element, 
        areInIncreasingOrder: (Element, Element) -> Bool) -> Int?
    {
        var left = 0
        var right = count - 1
        while left <= right {
            let mid = (left + right) / 2
            let candidate = self[mid]
            if areInIncreasingOrder(candidate,value) {
                left = mid + 1
            } else if areInIncreasingOrder(value,candidate) {
                right = mid - 1
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

extension Array where Element: Comparable {
    func binarySearch(for value: Element) -> Int? {
        return self.binarySearch(for: value, areInIncreasingOrder: <)
    }
}


/*:
> For such a famous and seemingly simple algorithm, a binary search is
> [notoriously hard to get
> right](https://research.googleblog.com/2006/06/extra-extra-read-all-about-it-nearly.html).
> This one contains a bug that also existed in the Java implementation for two
> decades — one we'll fix in the generic version. But we also don't guarantee
> that it's the only bug\!

It's worth noting some of the conventions from the Swift standard library that
this follows:

  - Similar to `index(of:)`, it returns an optional index, with `nil`
    representing "not found."

  - It's defined twice — once with a user-supplied parameter to perform the
    comparison, and once relying on `Comparable` conformance to supply that
    parameter as a convenience to callers.

  - The ordering must be a strict weak ordering. This means that when comparing
    two elements, if neither is ordered before the other, they *must* be equal.

This works for arrays, but if you wanted to binary search a `ContiguousArray` or
an `ArraySlice`, you're out of luck. The method should really be in an extension
to `RandomAccessCollection` — the random access is necessary to preserve the
logarithmic complexity, as you need to be able to locate the midpoint in
constant time.

A shortcut might be to require the collection to have an `Int` index. This will
cover almost every random-access collection in the standard library, and it
means you can cut and paste the entire `Array` version as is:

``` swift-example
extension RandomAccessCollection where Index == Int, IndexDistance == Int {
    public func binarySearch(for value: Element,
        areInIncreasingOrder: (Element, Element) -> Bool)
        -> Index?
    {
        // Identical implementation to that of Array...
    }
}
```

**Warning**: If you do this, you'll introduce an *even worse* bug, which we'll
come to shortly.

But this is still restricted to integer-indexed collections, and collections
don't always have an integer index. `Dictionary`, `Set`, and the various
`String` collection views have custom index types. The most notable
random-access example in the standard library is
`ReversedRandomAccessCollection`, which, as we saw in the collection protocols
chapter, has an opaque index type that wraps the original index, converting it
to the equivalent position in the reversed collection.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
