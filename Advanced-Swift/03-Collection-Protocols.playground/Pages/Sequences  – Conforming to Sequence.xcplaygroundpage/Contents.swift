/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Conforming to Sequence

An example of an iterator that produces a finite sequence is the following
`PrefixIterator`, which generates all prefixes of a string (including the string
itself). It starts at the beginning of the string, and with each call of `next`,
increments the slice of the string it returns by one character until it reaches
the end:

*/

struct PrefixIterator: IteratorProtocol {
    let string: String
    var offset: String.Index

    init(string: String) {
        self.string = string
        offset = string.startIndex
    }

    mutating func next() -> Substring? {
        guard offset < string.endIndex else { return nil }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

/*:
(`string[..<offset]` is a slicing operation that returns the substring between
the start and the offset — we saw the partial range notation in the previous
chapter, and we'll talk more about slicing later.)

With `PrefixIterator` in place, defining the accompanying `PrefixSequence` type
is easy. Again, it isn't necessary to specify the associated `Iterator` or
`Element` types explicitly because the compiler can infer them from the return
type of the `makeIterator` method:

*/

struct PrefixSequence: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return PrefixIterator(string: string)
    }
}

/*:
Now we can use a `for` loop to iterate over all the prefixes:

*/

for prefix in PrefixSequence(string: "Hello") {
    print(prefix)
}

/*:
Or we can perform any other operation provided by `Sequence`:

*/

PrefixSequence(string: "Hello").map { $0.uppercased() }

/*:
We can create sequences for `ConstantIterator` and `FibsIterator` in the same
way. We're not showing them here, but you may want to try this yourself. Just
keep in mind that these iterators create infinite sequences. Use a construct
like `for i in fibsSequence.prefix(10)` to slice off a finite piece.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
