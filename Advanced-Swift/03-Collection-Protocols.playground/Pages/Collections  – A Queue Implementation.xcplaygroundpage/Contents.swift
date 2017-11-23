/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### A Queue Implementation

Now that we've defined what a queue is, let's implement it. Below is a very
simple FIFO queue, with just `enqueue` and `dequeue` methods implemented on top
of a couple of arrays.

Since we've named our queue's generic placeholder `Element`, the same name as
the required associated type, there's no need to define it. It's not necessary
to name it `Element` though — the placeholder is just an arbitrary name of your
choosing. If it were named `Foo`, you could either define `typealias Element =
Foo`, or leave Swift to infer it implicitly from the return types of the
`enqueue` and `dequeue` implementations:

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
// ---------------------------
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

/*:
This implementation uses a technique of simulating a queue through the use of
two stacks (two regular arrays). As elements are enqueued, they're pushed onto
the "right" stack. Then, when elements are dequeued, they're popped off the
"left" stack, where they're held in reverse order. When the left stack is empty,
the right stack is reversed onto the left stack.

You might find the claim that the `dequeue` operation is `O(1)` slightly
surprising. Surely it contains a `reverse` call that is `O(n)`? But while this
is true, the overall [*amortized*
time](https://en.wikipedia.org/wiki/Amortized_analysis) to pop an item is
constant — over a large number of pushes and pops, the time taken for them all
is constant, even though the time for individual pushes or pops might not be.

The key to why this is lies in understanding how often the reverse happens and
on how many elements. One technique to analyze this is the "banker's
methodology." Imagine that each time you put an element on the queue, you pay a
token into the bank. Single enqueue, single token, so constant cost. Then when
it comes time to reverse the right-hand stack onto the left-hand one, you have a
token in the bank for every element enqueued, and you use those tokens to pay
for the reversal. The account never goes into debit, so you never spend more
than you paid.

This kind of reasoning is good for explaining why the "amortized" cost of an
operation over time is constant, even though individual calls might not be. The
same kind of justification can be used to explain why appending an element to an
array in Swift is a constant time operation. When the array runs out of storage,
it needs to allocate bigger storage and copy all its existing elements into it.
But since the storage size doubles with each reallocation, you can use the same
"append an element, pay a token, double the array size, spend all the tokens but
no more" argument.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
