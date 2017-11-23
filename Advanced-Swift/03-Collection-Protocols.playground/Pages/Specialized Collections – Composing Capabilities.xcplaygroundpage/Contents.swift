/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Composing Capabilities

The specialized collection protocols can be composed very elegantly into a set
of constraints that exactly matches the requirements of a particular algorithm.
As an example, take the `sort` method in the standard library for sorting a
collection in place (unlike its non-mutating sibling, `sorted`, which returns
the sorted elements in an array). Sorting in place requires the collection to be
mutable. If you want the sort to be fast, you also need random access. Last but
not least, you need to be able to compare the collection's elements to each
other.

Combining these requirements, the `sort` method is defined in an extension to
`MutableCollection`, with `RandomAccessCollection` and `Element: Comparable` as
additional constraints:

``` swift-example
extension MutableCollection
    where Self: RandomAccessCollection, Element: Comparable {
    /// Sorts the collection in place.
    public mutating func sort() { ... }
}
```

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
