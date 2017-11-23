/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### RangeReplaceableCollection

For operations that require adding or removing elements, use the
`RangeReplaceableCollection` protocol. This protocol requires two things:

  - An empty initializer — this is useful in generic functions, as it allows a
    function to create new empty collections of the same type.

  - A `replaceSubrange(_:with:)` method — this takes a range to replace and a
    collection to replace it with.

`RangeReplaceableCollection` is a great example of the power of protocol
extensions. You implement one uber-flexible method, `replaceSubrange`, and from
that comes a whole bunch of derived methods for free:

  - **`append(_:)`** and **`append(contentsOf:)`** — replace
    `endIndex..<endIndex` (i.e. replace the empty range at the end) with the new
    element/elements

  - **`remove(at:)`** and **`removeSubrange(_:)`** — replace `i...i` or
    `subrange` with an empty collection

  - **`insert(at:)`** and **`in sert(contentsOf:at:)`** — replace `i..<i` (i.e.
    replace the empty range at that point in the array) with a new
    element/elements

  - **`removeAll`** — replace `startIndex..<endIndex` with an empty collection

If a specific collection type can use knowledge about its implementation to
perform these functions more efficiently, it can provide custom versions that
will take priority over the default protocol extension ones.

We chose to have a very simple inefficient implementation for our queue type. As
we stated when defining the data type, the left stack holds the element in
reverse order. In order to have a simple implementation, we need to reverse all
the elements and combine them into the right array so that we can replace the
entire range at once:

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
// ---------------------------
extension FIFOQueue: RangeReplaceableCollection {
    mutating func replaceSubrange<C: Collection>(_ subrange: Range<Int>, 
        with newElements: C) where C.Element == Element 
    {
        right = left.reversed() + right
        left.removeAll()
        right.replaceSubrange(subrange, with: newElements)
    }
}

/*:
You might like to try implementing a more efficient version, which looks at
whether or not the replaced range spans the divide between the left and right
stacks. There's no need for us to implement the empty `init` in this example,
since the `FIFOQueue` struct already has one by default.

Unlike `BidirectionalCollection` and `RandomAccessCollection`, where the latter
extends the former, `RangeReplaceableCollection` doesn't inherit from
`MutableCollection`; they form distinct hierarchies. An example of a standard
library collection that does conform to `RangeReplaceableCollection` but isn't a
`MutableCollection` is `String`. The reasons boil down to what we said above
about indices having to remain stable during a single-element subscript
mutation, which `String` can't guarantee. We'll talk more about this in the
chapter on strings.

> The standard library knows twelve distinct kinds of collections that are the
> result of the combination of three traversal methods (forward-only,
> bidirectional, and random-access) with four mutability types (immutable,
> mutable, range-replaceable, and mutable-and-range-replaceable).
> 
> Because each of these needs a specialized default subsequence type, you may
> encounter types like `MutableRangeReplaceableBidirectionalSlice`. Don't let
> these monstrosities discourage you from working with them — they behave just
> like a normal `Slice`, with extra capabilities that match their base
> collection, and you rarely need to care about the specific type. And if and
> when Swift gets conditional protocol conformance, the types will be removed in
> favor of constrained extensions on `Slice`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
