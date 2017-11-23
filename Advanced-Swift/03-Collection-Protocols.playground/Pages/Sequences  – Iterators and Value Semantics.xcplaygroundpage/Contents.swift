/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Iterators and Value Semantics

The iterators we've seen thus far all have value semantics. If you make a copy
of one, the iterator's entire state will be copied, and the two instances will
behave independently of one other, as you'd expect. Most iterators in the
standard library also have value semantics, but there are exceptions.

To illustrate the difference between value and reference semantics, we first
take a look at `StrideToIterator`. It's the underlying iterator for the sequence
that's returned from the `stride(from:to:by:)` function. Let's create a
`StrideToIterator` and call `next` a couple of times:

*/

// A sequence from 0 to 9
let seq = stride(from: 0, to: 10, by: 1)
var i1 = seq.makeIterator()
i1.next()
i1.next()

/*:
`i1` is now ready to return `2`. Now, say you make a copy of it:

*/

var i2 = i1

/*:
Both the original and the copy are now separate and independent, and both return
`2` when you call `next`:

*/

i1.next()
i1.next()
i2.next()
i2.next()

/*:
This is because `StrideToIterator`, a pretty simple struct whose implementation
is not too dissimilar from our Fibonacci iterator above, has value semantics.

Now let's look at an iterator that doesn't have value semantics. `AnyIterator`
is an iterator that wraps another iterator, thus "erasing" the base iterator's
concrete type. An example where this might be useful is if you want to hide the
concrete type of a complex iterator that would expose implementation details in
your public API. The way `AnyIterator` does this is by wrapping the base
iterator in an internal box object, which is a reference type. (If you want to
learn exactly how this works, check out the section on type erasure in the
protocols chapter.)

To see why this is relevant, we create an `AnyIterator` that wraps `i1`, and
then we make a copy:

*/

var i3 = AnyIterator(i1)
var i4 = i3

/*:
In this situation, original and copy aren't independent because, despite being a
struct, `AnyIterator` doesn't have value semantics. The box object `AnyIterator`
uses to store its base iterator is a class instance, and when we assigned `i3`
to `i4`, only the reference to the box got copied. The storage of the box is
shared between the two iterators. Any calls to `next` on either `i3` or `i4` now
increment the same underlying iterator:

*/

i3.next()
i4.next()
i3.next()
i3.next()

/*:
Obviously, this could lead to bugs, although in all likelihood, you'll rarely
encounter this particular problem in practice. Iterators are usually not
something you pass around in your code. You're much more likely to create one
locally — sometimes explicitly, but mostly implicitly through a `for` loop — use
it once to loop over the elements, and then throw it away. If you find yourself
sharing iterators with other objects, consider wrapping the iterator in a
sequence instead.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
