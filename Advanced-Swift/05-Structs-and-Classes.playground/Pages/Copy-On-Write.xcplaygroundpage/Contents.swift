/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Copy-On-Write

In the Swift standard library, collections like `Array`, `Dictionary`, and `Set`
are implemented using a technique called *copy-on-write*. Let's say we have an
array of integers:

*/

var x = [1,2,3]

/*:
If we create a new variable, `y`, and assign the value of `x` to it, a copy gets
made, and both `x` and `y` now contain independent structs:

*/

var y = x

/*:
Internally, each of these `Array` structs contains a reference to some memory
buffer. This buffer is where the actual elements of the array are stored. At
this point, both arrays reference the same buffer — the arrays are sharing this
part of their storage. However, the moment we mutate `x`, the shared reference
gets detected, and the buffer is copied. This means we can mutate both variables
independently, yet the (expensive) copy of the elements only happens when it has
to — once we mutate one of the variables:

*/

x.append(5)
y.removeLast()
x
y

/*:
This behavior is called *copy-on-write*. The way it works is that whenever an
array is mutated, it first checks if its reference to the storage buffer is
*unique*, i.e. if the array is the sole owner of the buffer. If so, the buffer
can be mutated in place; no copy has to be made. However, if the buffer has more
than one owner (as in this example), the array will create a copy of the buffer
and then mutate the copy, leaving the other owners unaffected.

As the author of a struct, copy-on-write behavior isn't something you get for
free; you have to implement it yourself. Implementing copy-on-write for your own
types makes sense whenever you define a struct that contains a mutable reference
but should still retain value semantics. Maintaining value semantics would
normally require an expensive copy on every mutation, but copy-on-write avoids
copying unless it's absolutely necessary.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
