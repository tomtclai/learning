/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Error Handling 

Swift provides multiple ways for dealing with errors and even allows us to build
our own mechanisms. In the chapter on optionals, we looked at two of them:
optionals and assertions. An optional indicates that a value may or may not be
there; we have to inspect the optional and unwrap the value before we can use
it. An assertion validates that a condition is true; if the condition doesn't
hold, the program crashes.

Looking at the interfaces of types in the standard library can give us a good
feel for when to use an optional and when not to. Optionals are used for
operations that have a clear and commonly used "not found" or "invalid input"
case. For instance, consider the failable initializer for `Int` that takes a
string: it returns `nil` if the input isn't a valid integer. Another example:
when you look up a key in a dictionary, it's often expected that the key might
not be present. Therefore, a dictionary lookup returns an optional result.

Contrast this with arrays: when looking up an element at a specific index, the
element is returned directly and isn't wrapped in an optional. This is because
the programmer is expected to know if an array index is valid. Accessing an
array with an index that's out of bounds is considered a programmer error, and
consequently, this will crash your application. If you're unsure whether or not
an index is within bounds, you need to check beforehand.

Assertions are a great tool for identifying bugs in your code. Used correctly,
they show you at the earliest possible moment when your program is in a state
you didn't expect. They should never be used to signal *expected errors* such as
a network error.

Note that arrays also have accessors that return optionals. For example, the
`first` and `last` properties on `Collection` return `nil` when called on an
empty collection. The developers of Swift's standard library deliberately
designed the API this way because it's common to access these values in
situations when the collection might be empty.

An alternative to returning an optional from a function that can fail is to mark
the function as `throws`. Besides a different syntax for how the caller must
handle the success and failure cases, the key difference to returning an
optional is that throwing functions can return a rich error value that carries
information about the error that occurred.

This difference is a good guideline for when to use one approach over the other.
Consider the `first` and `last` properties on `Collection` again. They have
exactly one error condition (the collection is empty) — returning a rich error
wouldn't give the caller more information than what's already present in the
optional value. Compare this to a function that executes a network request: many
things can fail, from the network being down, to being unable to parse the
server's response. Rich error information is necessary to allow the caller to
react differently to different errors (or just to show the user what exactly
went wrong).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
