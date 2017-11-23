/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Indices

An index represents a position in the collection. Every collection has two
special indices, `startIndex` and `endIndex`. The `startIndex` designates the
collection's first element, and `endIndex` is the index that comes *after* the
last element in the collection. As a result, `endIndex` isn't a valid index for
subscripting; you use it to form ranges of indices (`someIndex..<endIndex`) or
to compare other indices against, e.g. as the break condition in a loop (`while
someIndex < endIndex`).

Up to this point, we've been using integers as the index into our collections.
`Array` does this, and (with a bit of manipulation) our `FIFOQueue` type does
too. Integer indices are very intuitive, but they're not the only option. The
only requirement for a collection's `Index` is that it must be `Comparable`,
which is another way of saying that indices have a defined order.

Take `Dictionary`, for instance. It would seem that the natural candidates for a
dictionary's indices would be its keys; after all, the keys are what we use to
address the values in the dictionary. But the key can't be the index because you
can't advance it — there's no way to tell what the next index after a given key
would be. Also, subscripting with an index is expected to give direct element
access, without detours for searching or hashing.

As a result, `DictionaryIndex` is an opaque value that points to a position in
the dictionary's internal storage buffer. It really is just a wrapper for a
single `Int` offset, but that's an implementation detail of no interest to users
of the collection. (In fact, the reality is somewhat more complex because
dictionaries that get passed to or returned from Objective-C APIs use an
`NSDictionary` as their backing store for efficient bridging, and the index type
for those dictionaries is different. But you get the idea.)

This also explains why subscripting a `Dictionary` with an index doesn't return
an optional value, whereas subscripting with a key does. The `subscript(_ key:
Key)` we're so used to is an additional overload of the subscript operator
that's defined directly on `Dictionary`. It returns an optional `Value`:

``` swift-example
struct Dictionary {
    ...
    subscript(key: Key) -> Value?
}
```

In contrast, subscripting with an index is part of the `Collection` protocol and
*always* returns a non-optional value, because addressing a collection with an
invalid index (like an out-of-bounds index on an array) is considered a
programmer error and doing so is supposed to trap:

``` swift-example
protocol Collection {
    subscript(position: Index) -> Element { get }
}
```

Notice the return type `Element`. A dictionary's `Element` type is the tuple
type `(key: Key, value: Value)`, so for `Dictionary`, this subscript returns a
key-value pair and not just a `Value`. This is also why iterating over a
dictionary in a `for` loop produces key-value pairs.

In the section on array indexing in the built-in collections chapter, we
discussed why it makes sense even for a "safe" language like Swift not to wrap
every failable operation in an optional or error construct. "[If every API can
fail, then you can't write useful
code.](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160411/014776.html)
You need to have some fundamental basis that you can rely on, and trust to
operate correctly," otherwise your code gets bogged down in safety checks.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
