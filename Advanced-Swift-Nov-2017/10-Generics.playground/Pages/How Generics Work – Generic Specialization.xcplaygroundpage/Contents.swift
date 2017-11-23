/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Generic Specialization

The compile-once-and-dispatch-dynamically model we described in the previous
section was an important design goal for Swift's generics system. Compared to
how C++ templates work — where the compiler generates a separate instance of the
templated function or class for every permutation of concrete types using the
template — this leads to faster compilation times and potentially smaller
binaries. Swift's model is also more flexible because, unlike C++, code that
uses a generic API doesn't need to see the implementation of the generic
function or type, only the declaration.

The downside is lower performance at runtime, caused by the indirection the code
has to go through. This is likely negligible when you consider a single function
call, but it does add up when generics are as pervasive as they are in Swift.
The standard library uses generics everywhere, including for very common
operations that must be as fast as possible, such as comparing values. Even if
generic code is only slightly slower than non-generic code, chances are
developers will try to avoid using it.

Luckily, the Swift compiler can make use of an optimization called *generic
specialization* to remove the overhead. Generic specialization means that the
compiler clones a generic type or function, such as `min<T>`, for a concrete
parameter type, such as `Int`. This specialized function can then be optimized
specifically for `Int`, removing all indirection. So the specialized version of
`min<T>` for `Int` would look like this:

*/

func min(_ x: Int, _ y: Int) -> Int {
    return y < x ? y : x
}

/*:
This is exactly the implementation you'd write for a concrete, non-generic `min`
function. Generic specialization not only eliminates the cost of the virtual
dispatch, but it also enables further optimizations, such as inlining, for which
the indirection would otherwise be a barrier.

The optimizer uses heuristics to decide which generic types or functions it
chooses to specialize, and for which concrete types it performs the
specialization. This decision requires a balancing of compilation times, binary
size, and runtime performance. If your code calls `min` with `Int` arguments
very frequently, but only once with `Float` arguments, chances are only the
`Int` variant will be specialized. Make sure to compile your release builds with
optimizations enabled (`swiftc -O` on the command line) to take advantage of all
available heuristics.

Regardless of how aggressive the compiler is with generic specialization, the
generic version of the function will always exist, at least if the generic
function is visible to other modules. This ensures that external code can always
call the generic version, even if the compiler didn't know anything about the
external types when it compiled the generic function.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
