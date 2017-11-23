/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Errors and Optionals

Errors and optionals are both very common ways for functions to signal that
something went wrong. Earlier in this chapter, we gave you some advice on how to
decide which pattern you should use for your own functions. You'll end up
working a lot with both errors and optionals, and passing results to other APIs
will often make it necessary to convert back and forth between throwing
functions and optional values.

The `try?` keyword allows us to ignore the error of a `throws` function and
convert the return value into an optional that tells us if the function
succeeded or not:

*/

// --- (Hidden code block) ---
enum ParseError: Error {
    case wrongEncoding
    case warning(line: Int, message: String)
}

func parse(text: String) throws -> [String] {
    switch text {
    case "encoding": throw ParseError.wrongEncoding
    case "warning": throw ParseError.warning(line: 1, message: "Expected file header")
    default: return [
      "This is a dummy return value. Pass \"encoding\" or \"warning\"" +
      "as the argument to have this function throw an error."]
    }
}

let input = "{ \"message\": \"We come in peace\" }"
// ---------------------------
if let result = try? parse(text: input) {
    print(result)
}

/*:
Using the `try?` keyword means we receive less information than before: we only
know if the function returned a successful value or if it returned some error —
any specific information about that error gets thrown away. To go the other way,
from an optional to a function that throws, we have to provide the error value
that gets used in case the optional is `nil`. Here's an extension on `Optional`
that, given an error, does this:

*/

extension Optional {
    /// Unwraps `self` if it is non-`nil`.
    /// Throws the given error if `self` is `nil`.
    func or(error: Error) throws -> Wrapped {
        switch self {
            case let x?: return x
            case nil: throw error
        }
    }
}

// --- (Hidden code block) ---
enum ReadIntError: Error {
    case couldNotRead
}
// ---------------------------
do {
    let int = try Int("42").or(error: ReadIntError.couldNotRead)
} catch {
    print(error)
}

/*:
This can be useful in conjunction with multiple `try` statements, or when you're
working inside a function that's already marked as `throws`.

The existence of the `try?` keyword may appear contradictory to Swift's
philosophy that ignoring errors shouldn't be allowed. However, you still have to
explicitly write `try?` so that the compiler forces you to acknowledge your
actions. In cases where you're not interested in the error message, this can be
very helpful.

It's also possible to write equivalent functions for converting between `Result`
and `throws`, or between `throws` and `Result`, or between optionals and
`Result`.

There's a third variant of `try`: `try!`. This is used when you know there can't
possibly be an error result. Just like force-unwrapping an optional value that's
`nil`, `try!` crashes when the result was actually an error.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
