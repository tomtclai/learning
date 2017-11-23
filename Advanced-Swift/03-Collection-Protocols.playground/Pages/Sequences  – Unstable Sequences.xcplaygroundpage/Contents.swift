/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Unstable Sequences

Sequences aren't limited to classic collection data structures, such as arrays
or lists. Network streams, files on disk, streams of UI events, and many other
kinds of data can all be modeled as sequences. But not all of these behave like
an array when you iterate over the elements more than once.

While the Fibonacci sequence isn't affected by a traversal of its elements (and
a subsequent traversal starts again at zero), a sequence that represents a
stream of network packets is consumed by the traversal; it won't produce the
same values again if you do another iteration. Both are valid sequences, though,
so [the documentation is very
clear](https://developer.apple.com/reference/swift/sequence) that `Sequence`
makes no guarantee about multiple traversals:

> The `Sequence` protocol makes no requirement on conforming types regarding
> whether they will be destructively consumed by iteration. As a consequence,
> don't assume that multiple `for`-`in` loops on a sequence will either resume
> iteration or restart from the beginning:
> 
> ``` swift-example
> for element in sequence {
>     if ... some condition { break }
> }
> 
> for element in sequence {
>     // No defined behavior
> }
> ```
> 
> A conforming sequence that is not a collection is allowed to produce an
> arbitrary sequence of elements in the second `for`-`in` loop.

This also explains why the seemingly trivial `first` property is only available
on collections, and not on sequences. Invoking a property getter ought to be
non-destructive, and only the `Collection` protocol guarantees safe multi-pass
iteration.

As an example of a destructively consumed sequence, consider this wrapper on the
`readLine` function, which reads lines from the standard input:

*/

let standardIn = AnySequence {
    return AnyIterator {
        readLine()
    }
}

/*:
Now you can use this sequence with the various extensions of `Sequence`. For
example, you could write a line-numbering version of the Unix `cat` utility:

``` swift-example
let numberedStdIn = standardIn.enumerated()
for (i, line) in numberedStdIn {
    print("\(i+1): \(line)")
}
```

The `enumerated` method wraps a sequence in a new sequence that produces pairs
of the original sequence's elements and incrementing numbers starting at zero.
Just like our wrapper of `readLine`, elements are lazily generated. The
consumption of the base sequence only happens when you move through the
enumerated sequence using its iterator, and not when it's created. So if you run
the above code from the command line, you'll see it waiting inside the `for`
loop. It prints the lines you type in as you hit return; it does *not* wait
until the input is terminated with control-D. But nonetheless, each time
`enumerated` serves up a line from `standardIn`, it's consuming the standard
input. You can't iterate over it twice to get the same results.

As an author of a `Sequence` extension, you don't need to take into account
whether or not the sequence is destructively consumed by iteration. But as a
*caller* of a method on a sequence type, you should keep it in mind.

A certain sign that a sequence is stable is if it also conforms to `Collection`
because this protocol makes that guarantee. The reverse isn't true. Even the
standard library has some sequences that can be traversed safely multiple times
although they aren't collections. Examples include the `StrideTo` and
`StrideThrough` types, as returned by `stride(from:to:by:)` and
`stride(from:through:by:)`. The fact that you can stride over floating-point
numbers would make it tricky (though probably not impossible) to render them as
a collection, so they're just sequences.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
