/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Conforming to `Collection`

We now have a container that can enqueue and dequeue elements. The next step is
to add `Collection` conformance to `FIFOQueue`. Unfortunately, figuring out the
minimum set of implementations you must provide to conform to a protocol can
sometimes be a frustrating exercise in Swift.

At the time of writing, the `Collection` protocol has a whopping six associated
types, four properties, seven instance methods, and two subscripts:

``` swift-example
protocol Collection: Sequence {
    associatedtype Element // inherited from Sequence
    associatedtype Index: Comparable

    associatedtype IndexDistance: SignedInteger = Int
    associatedtype Iterator: IteratorProtocol = IndexingIterator<Self>
        where Iterator.Element == Element
    associatedtype SubSequence: Sequence 
        /* ... */
    associatedtype Indices: Sequence = DefaultIndices<Self>
        /* ... */

    var first: Element? { get }
    var indices: Indices { get }
    var isEmpty: Bool { get }
    var count: IndexDistance { get }
    
    func makeIterator() -> Iterator
    func prefix(through: Index) -> SubSequence
    func prefix(upTo: Index) -> SubSequence
    func suffix(from: Index) -> SubSequence
    func distance(from: Index, to: Index) -> IndexDistance
    func index(_: Index, offsetBy: IndexDistance) -> Index
    func index(_: Index, offsetBy: IndexDistance, limitedBy: Index) -> Index?

    subscript(position: Index) -> Element { get }
    subscript(bounds: Range<Index>) -> SubSequence { get }
} 
```

(Note that this is an idealized view of the protocol. In Swift 4.0, some of
these requirements are really defined on two hidden protocols named `_Indexable`
and `_IndexableBase`, which `Collection` extends. This construction is a
workaround for the lack of support for recursive associated type constraints in
the compiler that was already fixed in the [post-4.0 master
branch](https://github.com/apple/swift/blob/0648aad14f47ae1a26a82568303ae8eea31c3441/stdlib/public/core/Collection.swift).
Swift 4.1 will no longer require this stopgap measure, and the hidden protocols
will be merged into `Collection`.)

The associated `SubSequence` type, which is inherited from `Sequence`, has the
following additional constraints (because we're inside `Collection`, the
reference to `Sequence` isn't recursive anymore; ideally, the subsequence of a
collection should also be a `Collection`, but that would require support for
recursive constraints):

``` swift-example
associatedtype SubSequence: Sequence
    where Element == SubSequence.Element, 
         SubSequence == SubSequence.SubSequence
```

The `Indices` type also has a number of constraints. The most important one
connects `Index` with `Indices`, specifying that the former is the element type
of the latter. The other constraints say that `Indices` is its own subsequence:

``` swift-example
    associatedtype Indices: Sequence = DefaultIndices<Self>
        where Index == Indices.Element, 
            Indices == Indices.SubSequence, 
            Indices.Element == Indices.Index, 
            Indices.Index == SubSequence.Index

```

With all the requirements above, conforming to `Collection` seems like a
daunting task. Well, it turns out it's actually not that bad. Notice that all
associated types except `Index` and `Element` have default values, so you don't
need to care about those unless your type has special requirements. The same is
true for most of the functions, properties, and subscripts: protocol extensions
on `Collection` provide the default implementations. Some of these extensions
have associated type constraints that match the protocol's default associated
types; for example, `Collection` only provides a default implementation of the
`makeIterator` method if its `Iterator` is an `IndexingIterator<Self>`:

``` swift-example
extension Collection where Iterator == IndexingIterator<Self> {
    /// Returns an iterator over the elements of the collection.
    func makeIterator() -> IndexingIterator<Self>
}
```

If you decide that your type should have a different iterator type, you'd have
to implement this method.

Working out what's required and what's provided through defaults isn't exactly
hard, but it's a lot of manual work, and unless you're very careful not to
overlook anything, it's easy to end up in an annoying guessing game with the
compiler. The most frustrating part of the process may be that the compiler
*has* all the information to guide you; the diagnostics just aren't helpful
enough yet.

For the time being, your best hope is to find the minimal conformance
requirements spelled out in the documentation, as is in fact the case for
`Collection`:

> … To add `Collection` conformance to your type, you must declare at least the
> following requirements:
> 
>   - The `startIndex` and `endIndex` properties
> 
>   - A subscript that provides at least read-only access to your type's
>     elements
> 
>   - The `index(after:)` method for advancing an index into your collection

So in the end, we end up with these requirements:

``` swift-example
protocol Collection: Sequence {
    /// A type that represents a position in the collection.
    associatedtype Index: Comparable
    /// The position of the first element in a nonempty collection.
    var startIndex: Index { get }
    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    var endIndex: Index { get }
    /// Returns the position immediately after the given index.
    func index(after i: Index) -> Index
    /// Accesses the element at the specified position.
    subscript(position: Index) -> Element { get }
}
```

We can conform `FIFOQueue` to `Collection` like so:

*/

// --- (Hidden code block) ---
/// A type that can `enqueue` and `dequeue` elements.
protocol Queue {
    /// The type of elements held in `self`.
    associatedtype Element
    /// Enqueue `element` to `self`.
    mutating func enqueue(_ newElement: Element)
    /// Dequeue an element from `self`.
    mutating func dequeue() -> Element?
}

/// An efficient variable-size FIFO queue of elements of type `Element`
struct FIFOQueue<Element>: Queue {
    private var left: [Element] = []
    private var right: [Element] = []

    /// Add an element to the back of the queue.
    /// - Complexity: O(1).
    mutating func enqueue(_ newElement: Element) {
        right.append(newElement)
    }

    /// Removes front of the queue.
    /// Returns `nil` in case of an empty queue.
    /// - Complexity: Amortized O(1).
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}
// ---------------------------
extension FIFOQueue: Collection {
    public var startIndex: Int { return 0 }
    public var endIndex: Int { return left.count + right.count }
    
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }
    
    public subscript(position: Int) -> Element {
        precondition((0..<endIndex).contains(position), "Index out of bounds")
        if position < left.endIndex {
            return left[left.count - position - 1]
        } else {
            return right[position - left.count]
        }
    }
}

/*:
We use `Int` as our queue's `Index` type. We don't specify an explicit typealias
for the associated type; just like with `Element`, Swift can infer it from the
method and property definitions. Note that since the indexing returns elements
from the front first, `Queue.first` returns the next item that will be dequeued
(so it serves as a kind of peek).

With just a handful of lines, queues now have more than 40 methods and
properties at their disposal. We can iterate over queues:

*/

var q = FIFOQueue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(x)
}

for s in q {
    print(s, terminator: " ")
}

/*:
We can pass queues to methods that take sequences:

*/

var a = Array(q)
a.append(contentsOf: q[2...3])
a

/*:
We can call methods and properties that extend `Sequence`:

*/

q.map { $0.uppercased() }
q.flatMap { Int($0) }
q.filter { $0.count > 1 }
q.sorted()
q.joined(separator: " ")

/*:
And we can call methods and properties that extend `Collection`:

*/

q.isEmpty
q.count
q.first


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
