/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

In the beginning of this chapter, we defined generic programming as identifying
the essential interface an algorithm or data type requires. We achieved this for
our `isSubset` method by starting with a non-generic version and then carefully
removing constraints. Writing multiple overloads with different constraints
allowed us to provide the function to the widest possible range of types and
meet performance expectations at the same time, and we relied on the compiler to
select the best variant for the types involved.

In the asynchronous networking example, we removed many assumptions about the
network stack from our `Resource` struct. Concrete resource values make no
assumptions about the server's root domain or how to load data — they're just
inert representations of API endpoints. Here, generic programming helps keep the
resources simple and decoupled from the networking code. This also makes testing
easier.

If you're interested in the theoretical details behind generic programming and
how different languages facilitate it, we recommend Ronald Garcia et al.'s 2007
paper titled "[An Extended Comparative Study of Language Support for Generic
Programming](http://www.osl.iu.edu/publications/prints/2005/garcia05:_extended_comparing05.pdf)."

Finally, generic programming in Swift wouldn't be possible without protocols.
This brings us to our next chapter.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
