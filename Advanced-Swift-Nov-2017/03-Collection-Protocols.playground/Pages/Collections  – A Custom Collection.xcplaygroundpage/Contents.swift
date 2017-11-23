/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### A Custom Collection

To demonstrate how collections in Swift work, we'll implement one of our own.
Probably the most useful container type not present in the Swift standard
library is a queue. Swift arrays are able to easily be used as stacks, with
`append` to push and `popLast` to pop. However, they're not ideal to use as
queues. You could use `push` combined with `remove(at: 0)`, but removing
anything other than the last element of an array is an `O(n)` operation —
because arrays are held in contiguous memory, every element has to shuffle down
to fill the gap (unlike popping the last element, which can be done in constant
time).

#### Designing a Protocol for Queues

Before we implement a queue, maybe we should define what we mean by it. A good
way to do this is to define a protocol that describes what a queue is. Let's try
the following definition:

*/

/// A type that can `enqueue` and `dequeue` elements.
protocol Queue {
    /// The type of elements held in `self`.
    associatedtype Element
    /// Enqueue `element` to `self`.
    mutating func enqueue(_ newElement: Element)
    /// Dequeue an element from `self`.
    mutating func dequeue() -> Element?
}

/*:
As simple as this is, it says a lot about what our definition of queue is: it's
defined generically. It can contain any type, represented by the associated type
`Element`. It imposes no restrictions on what `Element` is.

It's important to note that the comments above the methods are as much a part of
a protocol as the actual method names and types. Here, what we don't say tells
us as much as what we do: there's no guarantee of the complexity of `enqueue` or
`dequeue`. We could've said, for example, that both should operate in constant
(`O(1)`) time. This would give users adopting this protocol a good idea of the
performance characteristics of *any* kind of queue implementing this protocol.
But it would rule out data structures, such as priority queues, that might have
an `O(log_n)` enqueueing operation.

It also doesn't offer a `peek` operation to check without dequeuing, which means
it could be used to represent a queue that doesn't have such a feature (such as,
say, a queue interface over an operating system or networking call that could
only pop, not peek). It doesn't specify whether the two operations are
thread-safe. It doesn't specify that the queue is a `Collection` (though the
implementation we're about to write will be).

It doesn't even specify that it's a FIFO queue — it could be a LIFO queue, and
we could conform `Array` to it, with `append` for `enqueue` and `dequeue`
implemented via `isEmpty`/`popLast`.

Speaking of which, here *is* something the protocol specifies: like `Array`'s
`popLast`, `dequeue` returns an optional. If the queue is empty, it returns
`nil`. Otherwise, it removes and returns the last element. We don't provide an
equivalent for `Array.removeLast`, which traps if you call it on an empty array.

By making `dequeue` an optional, the most common operation of repeatedly
dequeuing an element until the queue is empty becomes a one-liner, along with
the safety of not being able to get it wrong:

``` swift-example
while let x = queue.dequeue() {
    // Process queue element
}
```

The downside is the inconvenience of always having to unwrap, even when you
already know the queue *can't* be empty. The right tradeoff for your particular
data type depends on how you envision it to be used. (Conforming your custom
collection to the `Collection` protocol gives you both variants for free,
anyway, since `Collection` provides both a `popFirst` and a `removeFirst`
method.)

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
