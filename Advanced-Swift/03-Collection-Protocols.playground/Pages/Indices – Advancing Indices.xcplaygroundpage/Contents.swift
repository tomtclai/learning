/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Advancing Indices

Swift 3 introduced [a major
change](https://github.com/apple/swift-evolution/blob/master/proposals/0065-collections-move-indices.md)
to the way index traversal is handled for collections. The task of advancing an
index forward or backward (i.e. deriving a new index from a given index) is now
a responsibility of the collection, whereas up until Swift 2, indices were able
to advance themselves. Where you used to write `someIndex.successor()` to step
to the next index, you now write `collection.index(after: someIndex)`.

Why did the Swift team decide to make this change? In short, performance. It
turns out that deriving an index from another very often requires information
about the collection's internals. It doesn't for arrays, where advancing an
index is a simple addition operation. But a string index, for example, needs to
inspect the actual character data because characters have variable sizes in
Swift.

In the old model of self-advancing indices, this meant that the index had to
store a reference to the collection's storage. That extra reference was enough
to defeat the copy-on-write optimizations used by the standard library
collections and would result in unnecessary copies when a collection was mutated
during iteration.

By allowing indices to remain dumb values, the new model doesn't have this
problem. It's also conceptually easier to understand and can make
implementations of custom index types simpler. When you do implement your own
index type, keep in mind that the index shouldn't keep a reference to the
collection if at all possible. In most cases, an index can likely be represented
with one or two integers that efficiently encode the position to the element in
the collection's underlying storage.

The downside of the new indexing model is a more verbose syntax.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
