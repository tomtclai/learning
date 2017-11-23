/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Swift Errors

Under the hood, Swift's built-in error handling works in a way very similar to
the `Result` type we've defined above. They differ in two major ways: Swift
forces you to annotate any function or method that might throw an error with the
`throws` keyword, and it forces you to use `try` (and variants) when calling
code that might throw an error. With the `Result` type, we can't statically
guarantee this. A limitation of Swift's built-in mechanism is that it only works
on the result type of a function: we can't pass a possibly failed argument to a
function (e.g. when providing a callback).

To rewrite our `populationOfCapital` function using Swift's errors, we simply
add the `throws` keyword to the function's declaration. Instead of returning an
`.error` value, we now need to `throw` an error. Similarly, instead of returning
a `.success` value, we now just return the value directly:

*/

// --- (Hidden code block) ---
let capitals = [
    "France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterdam",
    "Belgium": "Brussels"
]

let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]

enum LookupError: Error {
    case capitalNotFound
    case populationNotFound
}
// ---------------------------
func populationOfCapital(country: String) throws -> Int {
    guard let capital = capitals[country] else {
        throw LookupError.capitalNotFound
    }
    guard let population = cities[capital] else {
        throw LookupError.populationNotFound
    }
    return population
}

/*:
To call a function that's marked as `throws`, we can wrap the call in a
`do`-block and add a `try` prefix. The advantage of this is that we can just
write the regular flow within our `do`-block and handle all possible errors in
the `catch`-block:

*/

do {
    let population = try populationOfCapital(country: "France")
    print("France's population is \(population)")
} catch {
    print("Lookup error: \(error)")
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
