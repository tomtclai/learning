/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Conforming to `ExpressibleByArrayLiteral` 

When writing a collection like this, it's nice to implement
`ExpressibleByArrayLiteral` too, as we did with our linked list type. This will
allow users to create a queue using the familiar `[value1, value2, etc]` syntax.
This can be done easily, like so:

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
extension FIFOQueue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        left = elements.reversed()
        right = []
    }
}

/*:
For our queue logic, we want to reverse the elements to have them ready for use
on the left-hand buffer. Of course, we could just copy the elements to the
right-hand buffer, but since we're going to be copying elements anyway, it's
more efficient to copy them in reverse order so that they don't need reversing
later when they're dequeued.

Now queues can easily be created from literals:

*/

let queue: FIFOQueue = [1,2,3]

/*:
#### Literals

It's important to underline the difference between literals and types in Swift
here. `[1,2,3]` is *not* an array. Rather, it's an *array literal* — something
that can be used to create any type that conforms to
`ExpressibleByArrayLiteral`. This particular literal contains other literals —
integer literals — which can create any type that conforms to
`ExpressibleByIntegerLiteral`.

These literals have "default" types — types that Swift will assume if you don't
specify an explicit type when you use a literal. So array literals default to
`Array`, integer literals default to `Int`, float literals default to `Double`,
and string literals default to `String`. But this only occurs in the absence of
you specifying otherwise. For example, the queue declared above is a queue of
integers, but it could've been a queue of some other integer type:

*/

let byteQueue: FIFOQueue<UInt8> = [1,2,3]

/*:
Often, the type of the literal can be inferred from the context. For example,
this is what it looks like if a function takes a type that can be created from
literals:

*/

func takesSetOfFloats(floats: Set<Float>) {
    //...
}

takesSetOfFloats(floats: [1,2,3])

/*:
This literal will be interpreted as `Set<Float>`, not as `Array<Int>`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
