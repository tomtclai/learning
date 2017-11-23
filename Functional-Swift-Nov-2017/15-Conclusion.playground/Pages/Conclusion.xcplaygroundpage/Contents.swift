/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Conclusion

So what is functional programming? Many people (mistakenly) believe functional
programming is *only* about programming with higher-order functions, such as
`map` and `filter`. There is much more to it than that.

In the Introduction, we mentioned three qualities that we believe characterize
well-designed functional programs in Swift: modularity, a careful treatment of
mutable state, and types. In each of the chapters we have seen, these three
concepts pop up again and again.

Higher-order functions can certainly help define some abstractions, such as the
`Filter` type in Chapter 3 or the regions in Chapter 2, but they are a means,
not an end. The functional wrapper around the Core Image library we defined
provides a type-safe and modular way to assemble complex image filters.
Generators and sequences (Chapter 11) help us abstract iteration.

Swift's advanced type system can help catch many errors before your code is even
run. Optional types (Chapter 5) mark possible `nil` values as suspicious;
generics not only facilitate code reuse, but also allow you to enforce certain
safety properties (Chapter 4); and enumerations and structs provide the building
blocks to model the data in your domain accurately (Chapters 8 and 9).

Referentially transparent functions are easier to reason about and test. Our
QuickCheck library (Chapter 6) shows how we can use higher-order functions to
*generate* random unit tests for referentially transparent functions. Swift's
careful treatment of value types (Chapter 7) allows you to share data freely
within your application without having to worry about it changing
unintentionally or unexpectedly.

We can use all these ideas in concert to build powerful domain-specific
languages. Our libraries for diagrams (Chapter 10) and parser combinators
(Chapter 12) both define a small set of functions, providing the modular
building blocks that can be used to assemble solutions to large and difficult
problems. Our final case study shows how these domain-specific languages can be
used in a complete application (Chapter 13).

Finally, many of the types we have seen share similar functions. In Chapter 14,
we show how to group them and how they relate to each other.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
