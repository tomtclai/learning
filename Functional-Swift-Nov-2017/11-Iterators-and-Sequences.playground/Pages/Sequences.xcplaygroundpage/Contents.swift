/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Sequences

Iterators form the basis of another Swift protocol: `Sequence`. Iterators
provide a 'one-shot' mechanism for repeatedly computing a next element. There's
no way to rewind or replay the elements generated. The only thing we can do is
create a fresh iterator and use that instead. The `Sequence` protocol provides
just the right interface for doing that:

``` swift-example
protocol Sequence {
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Iterator
    // ...
}
```

> Note that the `Sequence` makes no guarantees about whether or not the sequence
> is destructively consumed. For example, you could wrap `readLine()` into a
> sequence.

Every sequence has an associated iterator type and a method to create a new
iterator. We can then use this iterator to traverse the sequence. For example,
we can use our `ReverseIndexIterator` to define a sequence that generates a
series of array indexes in back-to-front order:

*/

// --- (Hidden code block) ---
struct ReverseIndexIterator: IteratorProtocol {
    var index: Int

    init<T>(array: [T]) {
        index = array.endIndex-1
    }

    mutating func next() -> Int? {
        guard index >= 0 else { return nil }
        defer { index -= 1 }
        return index
    }
}
// ---------------------------
struct ReverseArrayIndices<T>: Sequence {
    let array: [T]

    init(array: [T]) {
        self.array = array
    }

    func makeIterator() -> ReverseIndexIterator {
        return ReverseIndexIterator(array: array)
    }
}

/*:
Every time we want to traverse the array stored in the `ReverseArrayIndices`
struct, we can call the `makeIterator` method to produce the desired iterator.
The following example shows how to fit these pieces together:

*/

var array = ["one", "two", "three"]
let reverseSequence = ReverseArrayIndices(array: array)
var reverseIterator = reverseSequence.makeIterator()

while let i = reverseIterator.next() {
    print("Index \(i) is \(array[i])")
}

/*:
In contrast to the previous example that just used the iterator, the *same*
sequence can be traversed a second time — we'd simply call `makeIterator()` to
produce a new iterator. By encapsulating the creation of iterators in the
`Sequence` definition, programmers using sequences don't have to be concerned
with the creation of the underlying iterators. This is in line with the
object-oriented philosophy of separating use and creation, which tends to result
in more cohesive code.

Swift has special syntax for working with sequences. Instead of creating the
iterator associated with a sequence ourselves, we can write a `for` loop. For
example, we can also write the previous code snippet as the following:

*/

for i in ReverseArrayIndices(array: array) {
    print("Index \(i) is \(array[i])")
}

/*:
Under the hood, Swift then uses the `makeIterator()` method to produce an
iterator and repeatedly calls its `next` method until it produces `nil`.

The obvious drawback of our `ReverseIndexIterator` is that it produces numbers,
while we may be interested in the *elements* associated with an array.
Fortunately, there are standard `map` and `filter` methods that manipulate
sequences rather than arrays:

``` swift-example
public protocol Sequence {
    public func map<T>(
        _ transform: (Iterator.Element) throws -> T)
        rethrows -> [T]

    public func filter(
        _ isIncluded: (Iterator.Element) throws -> Bool)
        rethrows -> [Iterator.Element]
}
```

To produce the *elements* of an array in reverse order, we can `map` over our
`ReverseArrayIndices`:

*/

let reverseElements = ReverseArrayIndices(array: array).map { array[$0] }
for x in reverseElements {
    print("Element is \(x)")
}

/*:
Similarly, we may of course want to filter out certain elements from a sequence.

It's worth pointing out that these `map` and `filter` methods do *not* return
new sequences, but instead traverse the sequence to produce an array. Likewise,
`Sequence` has a built-in method, `reversed()`, which returns a new array.
Mathematicians may therefore object to calling such operations `map`s, as they
fail to leave the underlying structure (a sequence) intact.

The `BidirectionalCollection` protocol has a method, `reversed`, which returns a
reversed view on the underlying collection by working on the indices. Because
the `Sequence` protocol has no notion of indices, we can't provide an efficient
`reversed` sequence unless we compute the entire result.

### Lazy Sequences

When we work with sequences, we can compose our transformations out of small,
understandable pieces. For example, consider the following code. It takes an
array of numbers, filters them, and squares the result:

*/

(1...10).filter { $0 % 3 == 0 }.map { $0 * $0 }

/*:
We can keep chaining other operations to this expression. Each operation can be
understood in isolation, making it easier to understand the whole. If we
would've written this as a `for` loop, it'd look like this:

*/

var result: [Int] = []
for element in 1...10 {
    if element % 3 == 0 {
        result.append(element * element)
    }
}
result

/*:
The imperative version, written using a `for` loop, is more complex. And once we
start adding more operations, it'll quickly get out of hand. When coming back to
the code, it's harder to understand what's going on. The functional version,
however, is very declarative: take an array, filter it, and map over it.

Yet the imperative version has one important advantage: it's faster. It iterates
over the sequence once, and the filtering and mapping are combined into a single
step. Also, the `result` array is only created once. In the functional version,
not only is the sequence iterated twice (once when filtering and once when
mapping), but there's also an intermediate array that gets passed from `filter`
to `map`.

Most times, code readability is more important than performance. However, we can
have our cake and eat it too. By using a `LazySequence`, we can chain
operations, and only once we compute the result do the operations get applied.
This way, the `filter` and `map` step can be combined into a single operation
per element:

*/

let lazyResult = (1...10).lazy.filter { $0 % 3 == 0 }.map { $0 * $0 }

/*:
In the code above, the result has a complex type, and the new elements aren't
evaluated yet. Yet the type conforms to the `Sequence` protocol. Therefore, we
can either iterate over it using a `for` loop or convert it into an array:

*/

Array(lazyResult)

/*:
When chaining multiple methods together, we can use `lazy` to fuse all the loops
together, and we'll end up with code that has performance similar to the
imperative version.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
