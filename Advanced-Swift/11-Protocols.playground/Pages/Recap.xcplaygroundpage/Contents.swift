/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

Protocols in Swift are important building blocks. They allow us to write
flexible code that decouples the interface and implementation. We looked at the
two different kinds of protocols and how they're implemented. We used type
erasers and looked at the performance differences between protocol types and
generic types with a protocol constraint. We also looked at unexpected behavior
due to the differences between static and dynamic dispatch.

Protocols had a big impact on the Swift community. Yet we also want to warn
against overusing them. Sometimes, using a simple concrete type like a struct or
a class is much easier to understand than a protocol, and this increases the
readability of your code. However, there are also times when using a protocol
can increase readability of your code — for example, when you deal with legacy
APIs retrofitted to a protocol.

One of the big upsides of using protocols is that they provide a *minimal viable
interface*; a well-designed protocol specifies the minimum set of requirements
conforming types must meet to be able to work with algorithms that were designed
for the protocol. Also, protocols can make it easier to write test code. Rather
than having to set up a complicated tree of dependencies, we can just create a
simple test type that conforms to the protocol.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
