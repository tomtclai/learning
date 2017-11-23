/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Optionals Revisited

Under the hood, Swift's built-in optional type is very similar to the `Result`
type that we've defined here. The following snippet is taken almost directly
from the Swift standard library:

``` swift-example
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
    // ...
}
```

The optional type just provides some syntactic sugar — such as the postfix `?`
notation and optional unwrapping mechanism — to make it easier to use. There is,
however, no reason you couldn't define it yourself.

In fact, we can even define some of the library functions for manipulating
optionals on our own `Result` type. For example, we can redefine the `??`
operator to work on our `Result` type:

*/

// --- (Hidden code block) ---
enum Result<T> {
    case success(T)
    case error(Error)
}
// ---------------------------
func ??<T>(result: Result<T>, handleError: (Error) -> T) -> T {
    switch result {
        case let .success(value):
            return value
        case let .error(error):
            return handleError(error)
    }
}

/*:
Note that we don't use an `autoclosure` argument (as we did when defining `??`
in the chapter about optionals). Instead, we expect a function that accepts an
`Error` argument and returns the desired value of type `T`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
