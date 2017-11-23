/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Associated Values

So far, we've seen how Swift's enumerations can be used to describe a choice
between several different alternatives. The `Encoding` enumeration provided a
safe, typed representation of different string encoding schemes. There are,
however, many more applications of enumerations.

Recall the `populationOfCapital` function from Chapter 5. It looks up a
country's capital, and if it's found, it returns the capital's population. The
result type is an optional integer: if everything is found, the resulting
population is returned. Otherwise, it's `nil`.

There's one drawback to using Swift's optional type: we don't return the error
message when something goes wrong. This is rather unfortunate — if a call to
`populationOfCapital` fails, there's no way to diagnose what went wrong. Does
the country not exist in our dictionary? Is there no population defined for the
capital?

Ideally, we'd like our `populationOfCapital` function to return *either* an
`Int` *or* an `Error`. Using Swift's enumerations, we can do just that. Instead
of returning an `Int?`, we'll redefine our `populationOfCapital` function to
return a case of the `PopulationResult` enumeration. We can define this
enumeration as follows:

*/

enum LookupError: Error {
    case capitalNotFound
    case populationNotFound
}

enum PopulationResult {
    case success(Int)
    case error(LookupError)
}

/*:
In contrast to the `Encoding` enumeration, both cases of `PopulationResult` have
[*associated
values*](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Enumerations.html):
the `success` case has an integer associated with it, corresponding to the
population of the country's capital, while the `error` case has an associated
`Error`. To illustrate this, we can declare an example `success` case as
follows:

*/

// --- (Hidden code block) ---
let capitals = [
    "France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterdam",
    "Belgium": "Brussels"
]

let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]
// ---------------------------
let exampleSuccess: PopulationResult = .success(1000)

/*:
Similarly, to create a `PopulationResult` using the `error` case, we'd need to
provide an associated `LookupError` value.

Now we can rewrite our `populationOfCapital` function to return a
`PopulationResult`:

*/

func populationOfCapital(country: String) -> PopulationResult {
    guard let capital = capitals[country] else {
        return .error(.capitalNotFound)
    }
    guard let population = cities[capital] else {
        return .error(.populationNotFound)
    }
    return .success(population)
}

/*:
Instead of returning an optional `Int`, we now return either the population or a
`LookupError`. We first check if the capital is in the `capitals` dictionary;
otherwise, we return a `.capitalNotFound` error. Then we verify that there's a
population in the `cities`. If not, we return a `.populationNotFound` error.
Finally, if both the capital and population are found, we return a `success`
value.

Upon calling `populationOfCapital`, you can use a switch statement to determine
whether or not the function succeeded:

*/

switch populationOfCapital(country: "France") {
  case let .success(population):
      print("France's capital has \(population) thousand inhabitants")
  case let .error(error):
      print("Error: \(error)")
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
