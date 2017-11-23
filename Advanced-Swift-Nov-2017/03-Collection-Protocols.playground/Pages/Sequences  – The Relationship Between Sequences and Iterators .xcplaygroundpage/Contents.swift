/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### The Relationship Between Sequences and Iterators 

Sequences and iterators are so similar that you may wonder why these need to be
separate types at all. Can't we just fold the `IteratorProtocol` functionality
into `Sequence`? This would indeed work fine for destructively consumed
sequences, like our standard input example. Sequences of this kind carry their
own iteration state and are mutated as they're traversed.

Stable sequences, like arrays or our Fibonacci sequence, must not be mutated by
a `for` loop; they require separate traversal state, and that's what the
iterator provides (along with the traversal logic, but that might as well live
in the sequence). The purpose of the `makeIterator` method is to create this
traversal state.

Every iterator can also be seen as an *unstable* sequence over the elements it
has yet to return. As a matter of fact, you can turn every iterator into a
sequence simply by declaring conformance; `Sequence` comes with a default
implementation for `makeIterator` that returns `self` if the conforming type is
an iterator. Jordan Rose, a member of the Swift team, said [via the
swift-evolution mailing
list](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20160104/005525.html)
that `IteratorProtocol` would actually inherit from `Sequence` if it weren't for
language limitations (namely, lack of support for recursive associated type
constraints).

Though it may not currently be possible to enforce this relationship, most
iterators in the standard library do conform to `Sequence`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
