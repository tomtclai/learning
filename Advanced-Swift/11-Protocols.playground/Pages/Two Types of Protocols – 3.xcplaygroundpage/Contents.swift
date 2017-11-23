/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
The standard library takes a different approach to erasing types: it uses a
class hierarchy to hide the concrete iterator type in a subclass, while the
client-facing base class is only generic over the element type.

To see how this works, we start by creating a simple abstract class that
conforms to `IteratorProtocol`. Its generic type is the `Element` of the
iterator, and the implementation will simply crash:

*/

class IteratorBox<Element>: IteratorProtocol {
    func next() -> Element? {
        fatalError("This method is abstract.")
    }
}

/*:
Then, we create another class, `IteratorBoxHelper`, which is also generic. Here,
the generic parameter is the specific iterator type (for example,
`ConstantIterator`). The purpose of this class is to store the underlying
iterator in a property. The `next` method simply forwards to the iterator's
`next` method:

``` swift-example
class IteratorBoxHelper<I: IteratorProtocol> {
    var iterator: I
    init(iterator: I) {
        self.iterator = iterator
    }

    func next() -> I.Element? {
        return iterator.next()
    }
}
```

Now for the hacky part. We change `IteratorBoxHelper` so that it's a subclass of
`IteratorBox`, and the two generic parameters are constrained in such a way that
`IteratorBox` gets `I`'s element as the generic parameter:

*/

class IteratorBoxHelper<I: IteratorProtocol>: IteratorBox<I.Element> {
    var iterator: I
    init(_ iterator: I) {
        self.iterator = iterator
    }

    override func next() -> I.Element? {
        return iterator.next()
    }
}

/*:
The “magic” happens in the initializer of `IteratorBoxHelper`. `IteratorBox`
can't have a property to store the wrapped iterator directly, because then it
would need to be generic over the concrete iterator type, which is exactly what
we want to avoid. The solution is to hide this property (and with it, its
concrete type) in the subclass, which can be generic over the concrete iterator
type. `IteratorBox` is then able to be generic only over the element type.

This allows us to create a value of `IteratorBoxHelper` and use it as an
`IteratorBox`, effectively erasing the type of `I`:

*/

// --- (Hidden code block) ---
struct ConstantIterator: IteratorProtocol {
    mutating func next() -> Int? {
        return 1
    }
}
// ---------------------------
let iter: IteratorBox<Int> = IteratorBoxHelper(ConstantIterator())

/*:
In the standard library, the `IteratorBox` and `IteratorBoxHelper` are then made
private, and yet another wrapper (`AnyIterator`) makes sure that these
implementation details are hidden from the public interface.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
