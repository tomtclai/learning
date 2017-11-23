/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Type-Driven Development

In the introduction, we mentioned how functional programs take the application
of functions to arguments as the canonical way to assemble bigger programs. In
this chapter, we've seen a concrete example of this functional design
methodology. We've defined a series of functions for describing regions. Each of
these functions isn't very powerful on its own. Yet together, the functions can
describe complex regions you wouldn't want to write from scratch.

The solution is simple and elegant. It's quite different from what you might
write if you had naively refactored the `canSafelyEngage(ship:friendly:)` method
into separate methods. The crucial design decision we made was *how* to define
regions. Once we chose the `Region` type, all the other definitions followed
naturally. The moral of the example is **choose your types carefully**. More
than anything else, types guide the development process.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
