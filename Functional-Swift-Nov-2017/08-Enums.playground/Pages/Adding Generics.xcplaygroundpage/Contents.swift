/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Adding Generics

Let's say that we want to write a similar function to `populationOfCapital`,
except instead of looking up the population, we want to look up the mayor of a
country's capital:

*/

let mayors = [
    "Paris": "Hidalgo",
    "Madrid": "Carmena",
    "Amsterdam": "van der Laan",
    "Berlin": "Müller"
]

/*:
By using optionals, we can simply look up the capital of the country and then
`flatMap` over the result to find the mayor of that capital:

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
func mayorOfCapital(country: String) -> String? {
    return capitals[country].flatMap { mayors[$0] }
}

/*:
However, using an optional return type doesn't give us any information as to why
the lookup failed.

But we now know how to solve this\! Our first approach might be to reuse the
`PopulationResult` enumeration to return the error. When `mayorOfCapital`
succeeds, however, we don't have an `Int` to associate with the `success` case.
Instead, we have a string. While we could somehow convert the string into an
`Int`, this indicates bad design: our types should be precise enough to prevent
us from having to work with such conversions.

Alternatively, we can define a new enumeration, `MayorResult`, corresponding to
the two possible cases:

*/

enum MayorResult {
    case success(String)
    case error(Error)
}

/*:
We can certainly write a new version of the `mayorOfCapital` function using this
enumeration — but introducing a new enumeration for each possible function seems
tedious. Besides, `MayorResult` and `PopulationResult` have an awful lot in
common. The only difference between the two enumerations is the type of the
value associated with `success`. So we define a new enumeration that's *generic*
in the result associated with `success`:

*/

enum Result<T> {
    case success(T)
    case error(Error)
}

/*:
Now we can use the same result type for both `populationOfCapital` and
`mayorOfCapital`. Their new type signatures become the following:

``` swift-example
func populationOfCapital(country: String) -> Result<Int>
func mayorOfCapital(country: String) -> Result<String>
```

The `populationOfCapital` function returns either an `Int` or a `LookupError`;
the `mayorOfCapital` function returns either a `String` or an `Error`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
