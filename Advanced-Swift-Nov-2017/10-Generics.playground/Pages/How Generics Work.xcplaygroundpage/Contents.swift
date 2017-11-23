/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## How Generics Work

How do generics work from the perspective of the compiler? To answer this
question, let's take a closer look at the `min` function from the standard
library (we took this example from the [Optimizing Swift
Performance](https://developer.apple.com/videos/play/wwdc2015/409/?time=992)
session at Apple's 2015 Worldwide Developers Conference):

*/

func min<T: Comparable>(_ x: T, _ y: T) -> T {
    return y < x ? y : x
}

/*:
The only constraints for the arguments and return value of `min` are that all
three must have the same type `T` and that `T` must conform to `Comparable`.
Other than that, `T` could be anything — `Int`, `Float`, `String`, or even a
type the compiler knows nothing about at compile time because it's defined in
another module. This means that the compiler lacks two essential pieces of
information it needs to emit code for the function:

  - The sizes of the variables of type `T` (including the arguments and return
    value).

  - The address of the specific overload of the `<` function that must be called
    at runtime.

Swift solves these problems by introducing a level of indirection for generic
code. Whenever the compiler encounters a value that has a generic type, it boxes
the value in a container. This container has a fixed size to store the value; if
the value is too large to fit, Swift allocates it on the heap and stores a
reference to it in the container.

The compiler also maintains a list of one or more *witness tables* per generic
type parameter: one so-called *value witness table*, plus one *protocol witness
table* for each protocol constraint on the type. The witness tables (also called
*vtables*) are used to dynamically dispatch function calls to the correct
implementations at runtime.

The value witness table is always present for any generic type. It contains
pointers to the fundamental operations of the type, such as allocation, copying,
and destruction. These can be simple no-ops or memcopies for primitive value
types such as `Int`, whereas reference types include their reference counting
logic here. The value witness table also records the size and alignment of the
type.

The record for the generic type `T` in our example will include one protocol
witness table because `T` has one protocol constraint, namely `Comparable`. For
each method or property the protocol declares, the witness table contains a
pointer to the implementation for the conforming type. Any calls to one of these
methods in the body of the generic function are then dispatched at runtime
through the witness table. In our example, the expression `y < x` is dispatched
in this way.

The protocol witness tables provide a mapping between the protocols to which the
generic type conforms (this is statically known to the compiler through the
generic constraints) and the functions that implement that functionality for the
specific type (these are only known at runtime). In fact, the only way to query
or manipulate the value in any way is through the witness tables. We couldn't
declare the `min` function with an unconstrained parameter `<T>` and then expect
it to work with any type that has an implementation for `<`, regardless of
`Comparable` conformance. The compiler wouldn't allow this because there
wouldn't be a witness table for it to locate the correct `<` implementation.
This is why generics are so closely related to protocols — you can't do much
with unconstrained generics except write container types like `Array<Element>`
or `Optional<Wrapped>`.

In summary, the code the compiler generates for the `min` function looks
something like this (in pseudocode):

``` swift-example
func min<T: Comparable>(_ x: Box_T, _ y: Box_T,
    valueWTable_T: VTable, comparableWTable_T: VTable)
    -> Box_T
{
    let xCopy = valueWTable_T.copy(x)
    let yCopy = valueWTable_T.copy(y)
    let result = comparableWTable_T.lessThan(yCopy, xCopy) ? y : x
    valueWTable_T.release(xCopy)
    valueWTable_T.release(yCopy)
    return result
}
```

> The layout of the container for generic parameters is similar but not
> identical to the *existential containers* used for protocol types that we'll
> cover in the next chapter. An existential container combines the storage for
> the value and the pointers to zero or more witness tables in one structure,
> whereas the container for a generic parameter only includes the value storage
> — the witness tables are stored separately so that they can be shared
> between all variables of the same type in the generic function.

If you want to learn more about how the generics system works, Swift compiler
developers Slava Pestov and John McCall gave [a talk on this
topic](https://www.youtube.com/watch?v=ctS8FzqcRug) at the 2017 LLVM Developers'
Meeting. We highly recommend that you watch it.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
