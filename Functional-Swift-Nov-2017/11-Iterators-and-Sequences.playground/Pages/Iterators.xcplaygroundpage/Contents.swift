/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Iterators

In Objective-C and Swift, we almost always use the `Array` datatype to represent
a list of items; it's both simple and fast. However, there are situations where
arrays aren't suitable. For example, you might not want to calculate all the
elements of an array because there's an infinite amount, or you don't expect to
use them all. In such situations, you may want to use an *iterator* instead.

To get started, we'll provide some motivation for iterators, using familiar
examples from array computations.

Swift's `for` loops can be used to iterate over array elements:

``` swift-example
for x in array {
    // do something with x
}
```

In such a `for` loop, the array is traversed from beginning to end. There may be
examples, however, where you want to traverse arrays in a different order. This
is where iterators may be useful.

Conceptually, an iterator is a 'process' that generates new array elements on
request. An iterator is any type that adheres to the following protocol:

``` swift-example
protocol IteratorProtocol {
    associatedtype Element
    mutating func next() -> Element?
}
```

This protocol requires an *associated type*, `Element`, defined by the
`IteratorProtocol`. There's a single method, `next`, that produces the next
element if it exists and `nil` otherwise.

For example, the following iterator produces array indices, starting from the
end of an array until it reaches 0. The `Element` type is derived from the
`next` method; we don't need to specify it explicitly:

*/

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

/*:
We define an initializer that's passed an array and initializes the `index` to
the array's last valid index.

We can use this `ReverseIndexIterator` to traverse an array's indices backward:

*/

let letters = ["A", "B", "C"]

()
var iterator = ReverseIndexIterator(array: letters)
while let i = iterator.next() {
    print("Element \(i) of the array is \(letters[i])")
}

/*:
Although it may seem like overkill on such simple examples, the iterator
encapsulates the computation of array indices. If we want to compute the indices
in a different order, we only need to update the iterator and never the code
that uses it.

Iterators need not produce a `nil` value at some point. For example, we can
define an iterator that produces an 'infinite' series of powers of two (until
`NSDecimalNumber` overflows, which is only with extremely large values):

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
struct PowerIterator: IteratorProtocol {
    var power: NSDecimalNumber = 1

    mutating func next() -> NSDecimalNumber? {
        power = power.multiplying(by: 2)
        return power
    }
}

/*:
We can use the `PowerIterator` to inspect increasingly large array indices — for
example, when implementing an exponential search algorithm that doubles the
array index in every iteration.

We may also want to use the `PowerIterator` for something entirely different.
Suppose we want to search through the powers of two, looking for some
interesting value. The `find` method takes a `predicate` of type
`(NSDecimalNumber) -> Bool` as argument and returns the smallest power of two
that satisfies this predicate:

*/

extension PowerIterator {
    mutating func find(where predicate: (NSDecimalNumber) -> Bool)
        -> NSDecimalNumber? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

/*:
We can use the `find` method to compute the smallest power of two larger
than 1,000:

*/

var powerIterator = PowerIterator()
powerIterator.find { $0.intValue > 1000 }

/*:
The iterators we've seen so far all produce numerical elements, but this need
not be the case. We can just as well write iterators that produce some other
value. For example, the following iterator produces a list of strings
corresponding to the lines of a file:

*/

struct FileLinesIterator: IteratorProtocol {
    let lines: [String]
    var currentLine: Int = 0

    init(filename: String) throws {
        let contents: String = try String(contentsOfFile: filename)
        lines = contents.components(separatedBy: .newlines)
    }

    mutating func next() -> String? {
        guard currentLine < lines.endIndex else { return nil }
        defer { currentLine += 1 }
        return lines[currentLine]
    }
}

/*:
By defining iterators in this fashion, we separate the *generation* of data from
its *usage*. The generation may involve opening a file or URL and handling the
errors that arise. Hiding this behind a simple iterator protocol helps keep the
code that manipulates the generated data oblivious to these issues. Our
implementation could even read the file line by line and the consumer of our
iterator could be left unchanged.

By defining a protocol for iterators, we can also write generic methods that
work for every iterator. For instance, our previous `find` method can be
generalized as follows:

*/

extension IteratorProtocol {
    mutating func find(predicate: (Element) -> Bool) -> Element? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

/*:
The `find` method is now available in any possible iterator. The most
interesting thing about it is its type signature. The iterator may be modified
by the `find` method, resulting from the calls to `next`, hence we need to add
the `mutating` annotation in the type declaration. The predicate is a function
that maps each generated element to a boolean value. To refer to the type of the
iterator's elements, we can use its associated type, `Element`. Finally, note
that we may not succeed in finding a value that satisfies the predicate. For
that reason, `find` returns an optional value, returning `nil` when the iterator
is exhausted.

It's also possible to combine iterators on top of one another. For example, you
may want to limit the number of items generated, buffer the generated values, or
encrypt the data generated. Here's one simple example of an iterator transformer
that produces the first `limit` values from its argument iterator:

*/

struct LimitIterator<I: IteratorProtocol>: IteratorProtocol {
    var limit = 0
    var iterator: I

    init(limit: Int, iterator: I) {
        self.limit = limit
        self.iterator = iterator
    }

    mutating func next() -> I.Element? {
        guard limit > 0 else { return nil }
        limit -= 1
        return iterator.next()
    }
}

/*:
Such an iterator may be useful when populating an array of a fixed size or
somehow buffering the elements generated.

When writing iterators, it can sometimes be cumbersome to introduce new structs
or classes for every iterator. Swift provides a simple struct,
`AnyIterator<Element>`, which is generic in the element type. It can be
initialized with an existing initializer or with a `next` function:

``` swift-example
struct AnyIterator<Element>: IteratorProtocol {
    init(_ body: @escaping () -> Element?)
    // ...
}
```

We'll provide the complete definition of `AnyIterator` shortly. For now, we'd
like to point out that the `AnyIterator` struct not only implements the
`Iterator` protocol, but it also implements the `Sequence` protocol that we'll
cover in the next section.

Using `AnyIterator` allows for much shorter definitions of iterators. For
example, we can rewrite our `ReverseIndexIterator` as follows:

*/

extension Int {
    func countDown() -> AnyIterator<Int> {
        var i = self - 1
        return AnyIterator {
            guard i >= 0 else { return nil }
            defer { i -= 1 }
            return i
        }
    }
}

/*:
We can even define functions to manipulate and combine iterators in terms of
`AnyIterator`. For example, we can append two iterators with the same underlying
element type, as follows:

``` swift-example
func +<I: IteratorProtocol, J: IteratorProtocol>(first: I, second: J)
    -> AnyIterator<I.Element> where I.Element == J.Element
{
    var i = first
    var j = second
    return AnyIterator { i.next() ?? j.next() }
}
```

The resulting iterator simply reads off new elements from its `first` argument
iterator; once this is exhausted, it produces elements from its `second`
iterator. Once both iterators have returned `nil`, the composite iterator also
returns `nil`.

We can improve on the definition above by a variant that's lazy over the second
parameter. This will come in handy later on in this chapter. The lazy version
produces exactly the same results, but it can be more efficient if only a part
of the iterator's results are needed:

*/

func +<I: IteratorProtocol, J: IteratorProtocol>(
    first: I, second: @escaping @autoclosure () -> J)
    -> AnyIterator<I.Element> where I.Element == J.Element
{
    var one = first
    var other: J? = nil
    return AnyIterator {
        if other != nil {
            return other!.next()
        } else if let result = one.next() {
            return result
        } else {
            other = second()
            return other!.next()
        }
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
