/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Infinite Sequences

Like all iterators we've seen so far, the `sequence` functions apply their
`next` closures lazily, i.e. the next value isn't computed until it's requested
by the caller. This makes constructs like `fibsSequence2.prefix(10)` work.
`prefix(10)` only asks the sequence for its first (up to) 10 elements and then
stops. If the sequence had tried to compute all its values eagerly, the program
would've crashed with an integer overflow before the next step had a chance to
run.

The possibility of creating infinite sequences is one thing that sets sequences
apart from collections, which can't be infinite.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
