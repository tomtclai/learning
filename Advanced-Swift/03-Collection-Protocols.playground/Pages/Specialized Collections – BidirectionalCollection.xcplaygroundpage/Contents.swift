/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### BidirectionalCollection

`BidirectionalCollection` adds a single but critical capability: the ability to
move an index backward using the `index(before:)` method. This is sufficient to
give your collection a default `last` property, matching `first`:

``` swift-example
extension BidirectionalCollection {
    /// The last element of the collection.
    public var last: Element? {
        return isEmpty ? nil : self[index(before: endIndex)]
    }
}
```

`Collection` could certainly provide a `last` property itself, but that wouldn't
be a good idea. To get the last element of a forward-only collection, you have
to iterate all the way to the end, i.e. an `O(n)` operation. It'd be misleading
to provide a cute little property for the last element — a singly linked list
with a million elements takes a long time to fetch the last element.

An example of a bidirectional collection in the standard library is `String`.
For Unicode-related reasons that we'll go into in the chapter on strings, a
character collection can't provide random access to its characters, but you can
move backward from the end, character by character.

`BidirectionalCollection` also adds more efficient implementations of some
operations that profit from traversing the collection backward, such as
`suffix`, `removeLast`, and `reversed`. The latter doesn't immediately reverse
the collection, but instead returns a lazy view:

``` swift-example
extension BidirectionalCollection {
    /// Returns a view presenting the elements of the collection in reverse
    /// order.
    /// - Complexity: O(1)
    public func reversed() -> ReversedCollection<Self> {
        return ReversedCollection(_base: self)
    }
}
```

Just as with the `enumerated` wrapper on `Sequence`, no actual reversing takes
place. Instead, `ReversedCollection` holds the base collection and uses a
reversed index into the collection. The collection then reverses the logic of
all index traversal methods so that moving forward moves backward in the base
collection, and vice versa.

Value semantics play a big part in the validity of this approach. On
construction, the wrapper "copies" the base collection into its own storage so
that a subsequent mutation of the original collection won't change the copy held
by `ReversedCollection`. This means that it has the same observable behavior as
the version of `reversed` that returns an array. We'll see in the chapter on
structs and classes that, in the case of copy-on-write types such as `Array` (or
immutable persistent structures like `List`, or types composed of two
copy-on-write types like `FIFOQueue`), this is still an efficient operation.

Most types in the standard library that conform to `Collection` also conform to
`BidirectionalCollection`. However, types like `Dictionary` and `Set` don't —
mostly as the idea of forward and backward iteration makes little sense for
inherently unordered collections.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
