/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Iterators

Sequences provide access to their elements by creating an iterator. The iterator
produces the values of the sequence one at a time and keeps track of its
iteration state as it traverses through the sequence. The only method defined in
the `IteratorProtocol` protocol is `next()`, which must return the next element
in the sequence on each subsequent call, or `nil` when the sequence is
exhausted:

``` swift-example
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}
```

The associated `Element` type specifies the type of the values the iterator
produces. For example, the element type of the iterator for `String` is
`Character`. By extension, the iterator also defines its sequence's element
type. (We'll talk more about protocols with associated types later in this
chapter and in the chapter on protocols):

``` swift-example
public protocol Sequence {
    associatedtype Element
    associatedtype Iterator: IteratorProtocol
        where Iterator.Element == Element

    // ...
}
```

You normally only have to care about iterators when you implement one for a
custom sequence type. Other than that, you rarely need to use iterators
directly, because a `for` loop is the idiomatic way to traverse a sequence. In
fact, this is what a `for` loop does under the hood: the compiler creates a
fresh iterator for the sequence and calls `next` on that iterator repeatedly,
until `nil` is returned. The `for` loop example we showed above is essentially
shorthand for the following:

``` swift-example
var iterator = someSequence.makeIterator()
while let element = iterator.next() {
    doSomething(with: element)
}
```

Iterators are single-pass constructs; they can only be advanced, and never
reversed or reset. While most iterators will produce a finite number of elements
and eventually return `nil` from `next()`, nothing stops you from vending an
infinite series that never ends. As a matter of fact, the simplest iterator
imaginable — short of one that immediately returns `nil` — is one that just
returns the same value over and over again:

*/

struct ConstantIterator: IteratorProtocol {
    typealias Element = Int
    mutating func next() -> Int? {
        return 1
    }
}

/*:
The explicit typealias for `Element` is optional (but often useful for
documentation purposes, especially in larger protocols). If we omit it, the
compiler infers the concrete type of `Element` from the return type of `next()`:

``` swift-example
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}
```

Notice that the `next()` method is declared as `mutating`. This isn't strictly
necessary in this simplistic example because our iterator has no mutable state.
In practice, though, iterators are inherently stateful. Almost any useful
iterator requires mutable state to keep track of its position in the sequence.

We can create a new instance of `ConstantIterator` and loop over the sequence it
produces in a `while` loop, printing an endless stream of ones:

``` swift-example
var iterator = ConstantIterator()
while let x = iterator.next() {
    print(x)
}
```

Let's look at a more elaborate example. `FibsIterator` produces the [Fibonacci
sequence](https://en.wikipedia.org/wiki/Fibonacci_number). It keeps track of the
current position in the sequence by storing the upcoming two numbers. The `next`
method then returns the first number and updates the state for the following
call. Like the previous example, this iterator also produces an "infinite"
stream; it keeps generating numbers until it reaches integer overflow, and then
the program crashes:

*/

struct FibsIterator: IteratorProtocol {
    var state = (0, 1)
    mutating func next() -> Int? {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
