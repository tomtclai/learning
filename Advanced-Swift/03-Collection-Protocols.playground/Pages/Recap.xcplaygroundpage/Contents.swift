/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

The `Sequence` and `Collection` protocols form the foundation of Swift's
collection types. They provide dozens of common operations to conforming types
and act as constraints for your own generic functions. The specialized
collection types, such as `MutableCollection` or `RandomAccessCollection`, give
you very fine-grained control over the functionality and performance
requirements of your algorithms.

The high level of abstraction necessarily makes the model complex, so don't feel
discouraged if not everything makes sense immediately. It takes practice to
become comfortable with the strict type system, especially since, more often
than not, discerning what the compiler wants to tell you is an art form that
forces you to carefully read between the lines. The reward is an extremely
flexible system that can handle everything from a pointer to a memory buffer to
a destructively consumed stream of network packets.

This flexibility means that once you've internalized the model, chances are that
a lot of code you'll come across in the future will instantly feel familiar
because it's built on the same abstractions and supports the same operations.
And whenever you create a custom type that fits in the `Sequence` or
`Collection` framework, consider adding the conformance. It'll make life easier
both for you and for other developers who work with your code.

The next chapter is all about another fundamental concept in Swift: optionals.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
