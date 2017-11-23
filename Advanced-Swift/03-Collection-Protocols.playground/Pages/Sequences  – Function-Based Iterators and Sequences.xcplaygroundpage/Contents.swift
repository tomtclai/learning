/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Function-Based Iterators and Sequences

`AnyIterator` has a second initializer that takes the `next` function directly
as its argument. Together with the corresponding `AnySequence` type, this allows
us to create iterators and sequences without defining any new types. For
example, we could've defined the Fibonacci iterator alternatively as a function
that returns an `AnyIterator`:

*/

func fibsIterator() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let upcomingNumber = state.0
        state = (state.1, state.0 + state.1)
        return upcomingNumber
    }
}

/*:
By keeping the `state` variable outside of the iterator's `next` closure and
capturing it inside the closure, the closure can mutate the state every time
it's invoked. There's only one functional difference between the two Fibonacci
iterators: the definition using a custom struct has value semantics, and the
definition using `AnyIterator` doesn't.

Creating a sequence out of this is even easier now because `AnySequence`
provides an initializer that takes a function, which in turn produces an
iterator:

*/

let fibsSequence = AnySequence(fibsIterator)
Array(fibsSequence.prefix(10))

/*:
Another alternative is to use the `sequence` function, which has two variants.
The first, `sequence(first:next:)`, returns a sequence whose first element is
the first argument you passed in; subsequent elements are produced by the
closure passed in the `next` argument. The other variant,
`sequence(state:next:)`, is even more powerful because it can keep some
arbitrary mutable state around between invocations of the `next` closure. We can
use this to build the Fibonacci sequence with a single function call:

*/

let fibsSequence2 = sequence(state: (0, 1)) {
    // The compiler needs a little type inference help here
    (state: inout (Int, Int)) -> Int? in
    let upcomingNumber = state.0
    state = (state.1, state.0 + state.1)
    return upcomingNumber
}

Array(fibsSequence2.prefix(10))

/*:
> The return type of `sequence(first:next:)` and `sequence(state:next:)` is
> `UnfoldSequence`. This term comes from functional programming, where the same
> operation is often called *unfold*. `sequence` is the natural counterpart to
> `reduce` (which is often called *fold* in functional languages). Where
> `reduce` reduces (or *folds*) a sequence into a single return value,
> `sequence` *unfolds* a single value to generate a sequence.

The two `sequence` functions are extremely versatile. They're often a good fit
for replacing a traditional C-style `for` loop that uses non-linear math. In the
chapter on structs and classes, we'll talk more about `inout` parameters.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
