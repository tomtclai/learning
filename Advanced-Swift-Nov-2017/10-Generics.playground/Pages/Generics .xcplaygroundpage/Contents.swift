/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Generics 

Like most modern languages, Swift has a number of features that can all be
grouped under *generic programming*. Generic code allows you to write reusable
functions and data types that can work with any type that matches the
constraints you define. For example, types such as `Array` and `Set` are generic
over their elements. Generic functions are generic over their input and/or
output types. The declaration `func identity<A>(input: A) -> A` defines a
function that works on any type, identified by the placeholder `A`. In a way, we
can also think of protocols with an associated type as "generic protocols." The
associated type allows us to abstract over specific implementations.
`IteratorProtocol` is an example of such a protocol: it's generic over the
`Element` type it produces.

The goal of generic programming is to express the *essential interface* an
algorithm or data structure requires. For example, consider the `last(where:)`
method we wrote in the built-in collections chapter. Writing this method as an
extension on `Array` would've been the obvious choice, but an `Array` has lots
of capabilities `last(where:)` doesn't need. By asking ourselves what the
essential interface is — that is, the minimal set of features required to
implement the desired functionality — we can make the function available to a
much broader set of types. In this example, `last(where:)` has only one
requirement: it needs to traverse a sequence of elements in reverse order. This
makes an extension on `Sequence` the right place for this algorithm (and we can
add a more efficient variant to `BidirectionalCollection`).

In this chapter, we'll look at how to write generic code. We'll start by talking
about overloading because this concept is closely related to generics. We'll use
generic programming to provide multiple implementations of an algorithm, each
relying on a different set of assumptions. We'll also discuss some common
difficulties you may encounter when writing generic algorithms for collections.
We'll then look at how you can use generic data types to refactor code to make
it testable and more flexible. Finally, we'll cover how the compiler handles
generic code and what we can do to get the best performance for our own generic
code.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
