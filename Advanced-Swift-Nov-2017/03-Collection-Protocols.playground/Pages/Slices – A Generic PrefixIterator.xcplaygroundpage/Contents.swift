/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### A Generic PrefixIterator

Now that we know any collection can be sliced, we could revisit our prefix
iterator code from earlier in the chapter and write a version that works with
any collection:

*/

struct PrefixIterator<Base: Collection>: IteratorProtocol, Sequence {
    let base: Base
    var offset: Base.Index

    init(_ base: Base) {
        self.base = base
        self.offset = base.startIndex
    }

    mutating func next() -> Base.SubSequence? {
        guard offset != base.endIndex else { return nil }
        base.formIndex(after: &offset)
        return base.prefix(upTo: offset)
    }
}

/*:
By conforming the iterator directly to `Sequence`, we can use it with functions
that work on sequences without having to define another type:

*/

let numbers = [1,2,3]
Array(PrefixIterator(numbers))


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
