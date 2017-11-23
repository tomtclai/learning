/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Putting It All Together

To conclude this section, we'll provide a small example of `map`, `filter`, and
`reduce` in action.

Suppose we have the following `struct` definition, consisting of a city's name
and population (measured in thousands of inhabitants):

*/

struct City {
    let name: String
    let population: Int
}

/*:
We can define several example cities:

*/

let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)
let amsterdam = City(name: "Amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

/*:
Now suppose we'd like to print a list of cities with at least one million
inhabitants, together with their total populations. We can define a helper
function that scales up the inhabitants:

*/

extension City {
    func scalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }
}

/*:
Now we can use all the ingredients we've seen in this chapter to write the
following statement:

*/

cities.filter { $0.population > 1000 }
    .map { $0.scalingPopulation() }
    .reduce("City: Population") { result, c in
        return result + "\n" + "\(c.name): \(c.population)"
    }

/*:
We start by filtering out those cities that have less than one million
inhabitants. We then map our `scalingPopulation` function over the remaining
cities. Finally, using the `reduce` function, we compute a `String` with a list
of city names and populations. Here we use the `map`, `filter`, and `reduce`
definitions from the `Array` type in Swift's standard library. As a result, we
can chain together the results of our maps and filters nicely. The
`cities.filter(..)` expression computes an array, on which we call `map`; we
call `reduce` on the result of this call to obtain our final result.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
