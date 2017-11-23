/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Closures and Mutability

In this section, we'll look at how closures store data.

For example, consider a function that generates a unique integer every time it
gets called (until it reaches `Int.max`). It works by moving the state outside
of the function. In other words, it *closes* over the variable `i`:

*/

var i = 0
func uniqueInteger() -> Int {
    i += 1
    return i
}

/*:
Every time we call this function, the shared variable `i` will change, and a
different integer will be returned. Functions are reference types as well — if
we assign `uniqueInteger` to another variable, the compiler won't copy the
function (or `i`). Instead, it'll create a reference to the same function:

*/

let otherFunction: () -> Int = uniqueInteger

/*:
Calling `otherFunction` will have exactly the same effect as calling
`uniqueInteger`. This is true for all closures and functions: if we pass them
around, they always get passed by reference, and they always share the same
state.

Recall the function-based `fibsIterator` example from the collection protocols
chapter, where we saw this behavior before. When we used the iterator, the
iterator itself (being a function) was mutating its state. In order to create a
fresh iterator for each iteration, we had to wrap it in an `AnySequence`.

If we want to have multiple different unique integer providers, we can use the
same technique: instead of returning the integer, we return a closure that
captures the mutable variable. The returned closure is a reference type, and
passing it around will share the state. However, calling `uniqueIntegerProvider`
repeatedly returns a fresh function that starts at zero every time:

*/

func uniqueIntegerProvider() -> () -> Int {
    var i = 0
    return { 
        i += 1
        return i
    }
}

/*:
Instead of returning a closure, we can also wrap the behavior in an
`AnyIterator`. That way, we can even use our integer provider in a `for` loop:

*/

func uniqueIntegerProvider() -> AnyIterator<Int> {
    var i = 0
    return AnyIterator {
        i += 1
        return i
    }
}

/*:
Swift structs are commonly stored on the stack rather than on the heap. For
mutable structs this is an optimization, though; a struct variable is created on
the heap by default, and the optimizer will then move it to the stack in almost
all cases. The reason the compiler works in this way is that variables that are
captured by an escaping closure need to outlive their stack frame. When the
compiler recognizes that a struct variable is closed over by a function, it
doesn't apply the optimization and the struct remains on the heap. That way, the
`i` variable in our example persists even when the scope of
`uniqueIntegerProvider` exits.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
