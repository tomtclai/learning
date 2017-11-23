/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Variables and References

In Swift, there are two ways to initialize a variable, using either `var` or
`let`:

*/

var x: Int = 1
let y: Int = 2

/*:
The crucial difference is that we can assign new values to variables declared
using `var`, whereas variables created using `let` *cannot* change:

``` highlight-swift
x = 3 // This is fine
y = 4 // This is rejected by the compiler
```

We'll refer to variables declared using a `let` as *immutable* variables;
variables declared using a `var`, on the other hand, are said to be *mutable*.

Why — you might wonder — would you ever declare an immutable variable? Doing so
limits the variable's capabilities. A mutable variable is strictly more
versatile. There's a clear case for preferring `var` over `let`. Yet in this
section, we want to try and argue that the opposite is true.

Imagine having to read through a Swift class that someone else has written.
There are a few methods that all refer to an instance variable with some
meaningless name, say `x`. Given the choice, would you prefer `x` to be declared
with a `var` or a `let`? Clearly declaring `x` to be immutable is preferable:
you can read through the code without having to worry about what the *current*
value of `x` is, you're free to substitute `x` for its definition, and you can't
invalidate `x` by assigning it some value that might break invariants on which
the rest of the class relies.

Immutable variables may not be assigned a new value. As a result, it's *easier*
to reason about immutable variables. In his famous paper, "Go To Statement
Considered Harmful," Edsger Dijkstra writes:

> My... remark is that our intellectual powers are rather geared to master
> static relations and that our powers to visualize processes evolving in time
> are relatively poorly developed.

Dijkstra goes on to argue that the mental model a programmer needs to develop
when reading through structured code (using conditionals, loops, and function
calls, but not goto statements) is simpler than spaghetti code full of gotos. We
can take this discipline even further and eschew the use of mutable variables:
`var` considered harmful. However, in Swift, things are a bit more subtle, as
we'll see in the next section.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
