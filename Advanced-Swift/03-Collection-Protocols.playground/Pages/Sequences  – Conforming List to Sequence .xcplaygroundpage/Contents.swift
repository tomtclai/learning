/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Conforming `List` to `Sequence` 

Since list variables are iterators into the list, this means you can use them to
conform `List` to `Sequence`. As a matter of fact, `List` is an example of an
unstable sequence that carries its own iteration state, like we saw when we
talked about the relationship between sequences and iterators. We can add
conformance to `IteratorProtocol` and `Sequence` in one go just by providing a
`next()` method; the implementation of this is exactly the same as for `pop`:

*/

// --- (Hidden code block) ---
/// A singly linked list
enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

extension List {
    /// Return a new list by prepending a node with value `x` to the
    /// front of a list.
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }
    }
}

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }

    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(x, next: tail):
            self = tail
            return x
        }
    }
}
// ---------------------------
extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

/*:
Now you can use lists with `for ... in`:

*/

let list: List = ["1", "2", "3"]
for x in list {
    print("\(x) ", terminator: "")
}

/*:
This also means that, through the power of protocol extensions, we can use
`List` with dozens of standard library functions:

*/

list.joined(separator: ",")
list.contains("2")
list.flatMap { Int($0) }
list.elementsEqual(["1", "2", "3"])

/*:
> In computer science theory, linked lists are more efficient than arrays for
> some common operations. In practice, however, it's really hard to outperform
> arrays on modern computer architectures with their extremely fast caches and
> (relatively) slow main memory. Because arrays use contiguous memory for their
> elements, the processor can process them way more efficiently. For a good
> overview of collection performance in Swift, see Károly Lőrentey's book
> [*Optimizing Collections*](https://www.objc.io/books/optimizing-collections/).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
