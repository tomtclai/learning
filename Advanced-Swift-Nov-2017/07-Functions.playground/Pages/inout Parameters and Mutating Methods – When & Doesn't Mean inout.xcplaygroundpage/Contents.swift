/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### When `&` Doesn't Mean `inout`

Speaking of unsafe functions, you should be aware of the other meaning of `&`:
converting a function argument to an unsafe pointer.

If a function takes an `UnsafeMutablePointer` as a parameter, then you can pass
a `var` into it using `&`, similar to an `inout` argument. But here you *really
are* passing by reference — by pointer in fact.

Here's `increment`, written to take an unsafe mutable pointer instead of an
`inout`:

*/

func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    // Store a copy of the pointer in a closure
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}

/*:
As we'll discuss in later chapters, Swift arrays implicitly decay to pointers to
make C interoperability nice and painless. Now, suppose you pass in an array
that goes out of scope before you call the resulting function:

*/

let fun: () -> Int
do {
    var array = [0]
    fun = incref(pointer: &array)
}
fun()

/*:
This opens up a whole exciting world of undefined behavior. In testing, the
above code printed different values on each run: sometimes `0`, sometimes `1`,
sometimes `140362397107840` — and sometimes it produced a runtime crash.

The moral here is: know what you're passing in to. When appending an `&`, you
could be invoking nice safe Swift `inout` semantics, or you could be casting
your poor variable into the brutal world of unsafe pointers. When dealing with
unsafe pointers, be very careful about the lifetime of variables. We'll go into
more detail on this in the chapter on interoperability.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
