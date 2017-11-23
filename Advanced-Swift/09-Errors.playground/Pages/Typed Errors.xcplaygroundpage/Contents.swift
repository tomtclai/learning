/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Typed Errors

It can sometimes be useful to take advantage of the type system to specify the
concrete errors a function can throw. We can come up with a slightly altered
`Result` type, which has an additional generic parameter for the error type:

*/

enum Result<A, ErrorType: Error> {
    case failure(ErrorType)
    case success(A)
}

/*:
This way, we can declare functions using an explicit error type. The following
`parseFile` function will return either an array of strings or a `ParseError`.
We don't have to handle any other cases when calling it, and the compiler knows
this:

*/

// --- (Hidden code block) ---
enum ParseError: Error {
    case wrongEncoding
    case warning(line: Int, message: String)
}
// ---------------------------
func parse(text: String) -> Result<[String], ParseError>

// --- (Hidden code block) ---
{
    switch text {
    case "encoding": return .failure(ParseError.wrongEncoding)
    case "warning": return .failure(ParseError.warning(line: 1, message: "Expected file header"))
    default: return .success(["This is a dummy return value. Pass \"encoding\" or \"warning\" as the argument to have this function return an error."])
    }
}
// ---------------------------
/*:
In code where your errors have a significant semantic meaning, you can choose to
use a typed `Result` type instead of Swift's built-in error handling. This way,
you can let the compiler verify that you caught all possible errors. However, in
most applications, using `throws` and `do`/`try`/`catch` will lead to simpler
code. There's another big benefit to using the built-in error handling: the
compiler will make sure you can't ignore the error case when calling a function
that might throw. With the definition of `parseFile` above, we could write the
following code:

``` swift-example
_ = parse(text: invalidData)
```

If the function were marked as `throws`, the compiler would force us to call it
using `try`. The compiler would also force us to either wrap that call in a
`do`/`catch` block or propagate the error.

Granted, the example above is unrealistic, because ignoring the `parse`
function's return value doesn't make any sense, and the compiler *would* force
you to consider the failure case when you unwrap the result. It's relevant when
dealing with functions that don't have a meaningful return value, though, and in
these situations, it can really help you not forget to catch the error. For
example, consider the following function:

*/

func setupServerConnection() throws

// --- (Hidden code block) ---
{
    // Empty implementation
}
// ---------------------------
/*:
Because the function is marked as `throws`, we need to call it with `try`. If
the server connection fails, we probably want to switch to a different code path
or display an error. By having to use `try`, we're forced to think about this
case. Had we chosen to return a `Result<()>` instead, it would be all too easy
to ignore errors.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
