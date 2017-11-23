/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Working with Optionals

Swift's optional values make the possibility of failure explicit. This can be
cumbersome, especially when combining multiple optional results. There are
several techniques to facilitate the use of optionals.

### Optional Chaining

First of all, Swift has a special mechanism, *optional chaining*, for calling
methods or accessing properties on nested classes or structs. Consider the
following simple model for processing customer orders:

*/

struct Order {
    let orderNumber: Int
    let person: Person?
}

struct Person {
    let name: String
    let address: Address?
}

struct Address {
    let streetName: String
    let city: String
    let state: String?
}

let order = Order(orderNumber: 42, person: nil)

/*:
Given an `Order`, how can we find the state of the customer? We could use the
explicit unwrapping operator:

``` swift-example
order.person!.address!.state!
```

Doing so, however, may cause runtime exceptions if any of the intermediate data
is missing. It'd be much safer to use optional binding:

*/

if let person = order.person {
    if let address = person.address {
        if let state = address.state {
            print("Got a state: \(state)")
        }
    }
}

/*:
But this is rather verbose, and we haven't even handled the else cases yet.
Using optional chaining, this example would become the following:

*/

if let myState = order.person?.address?.state {
    print("This order will be shipped to \(myState)")
} else {
    print("Unknown person, address, or state.")
}

/*:
Instead of forcing the unwrapping of intermediate types, we use the question
mark operator to try to unwrap the optional types. When any of the property
accesses fails, the whole chain returns `nil`.

### Branching on Optionals

We've already discussed the `if let` optional binding mechanism above, but Swift
has two other branch statements, `switch` and `guard`, that are especially
suited to work with optionals.

To match an optional value in a `switch` statement, we simply add the `?` suffix
to every pattern in a `case` branch:

*/

// --- (Hidden code block) ---
let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]

let madridPopulation: Int? = cities["Madrid"]
// ---------------------------
switch madridPopulation {
    case 0?: print("Nobody in Madrid")
    case (1..<1000)?: print("Less than a million in Madrid")
    case let x?: print("\(x) people in Madrid")
    case nil: print("We don't know about Madrid")
}

/*:
The `guard` statement is designed to exit the current scope early if some
condition isn't met. A very common use case is to combine it with optional
binding to handle the cases when no value is present. This makes it very clear
that any code following the `guard` statement requires the value to be present
and won't be executed if it isn't. For example, we could rewrite the code to
print out the number of inhabitants of a given city like this:

*/

func populationDescription(for city: String) -> String? {
    guard let population = cities[city] else { return nil }
    return "The population of Madrid is \(population)"
}

populationDescription(for: "Madrid")
/*:
After the `guard` statement, we have the non-optional `population` value to work
with. Using `guard` statements in this fashion makes the control flow simpler
than nesting `if let` statements.

### Optional Mapping

The `?` operator lets us select methods or fields of optional values. However,
there are plenty of other examples where you may want to manipulate an optional
value, if it exists, and return `nil` otherwise. Consider the following example:

``` swift-example
func increment(optional: Int?) -> Int? {
    guard let x = optional else { return nil }
    return x + 1
}
```

The `increment(optional:)` example behaves similarly to the `?` operator: if the
optional value is `nil`, the result is `nil`; otherwise, some computation is
performed.

We can generalize both `increment(optional:)` and the `?` operator and define a
`map` function on optionals. Rather than only increment a value of type `Int?`,
as we did in `increment(optional:)`, we pass the operation we wish to perform as
an argument to the `map` function:

*/

extension Optional {
    func map_sample_impl<U>(_ transform: (Wrapped) -> U) -> U? {
        guard let x = self else { return nil }
        return transform(x)
    }
}

/*:
This `map` function takes a `transform` function of type `Wrapped -> U` as
argument. If the optional value isn't `nil`, it applies `transform` to it and
returns the result; otherwise, the `map` function returns `nil`. This `map`
function is part of the Swift standard library.

Using `map`, we can write the `increment(optional:)` function as the following:

*/

func increment(optional: Int?) -> Int? {
    return optional.map { $0 + 1 }
}

/*:
Of course, we can also use `map` to project fields or methods from optional
structs and classes, similar to the `?` operator.

Why is this function called `map`? What does it have in common with array
computations? There's a good reason for calling both of these functions `map`,
but we'll defer this discussion for the moment and return to it in the chapter
about functors, applicative functors, and monads.

### Optional Binding Revisited

The `map` function shows one way to manipulate optional values, but many others
exist. Consider the following example:

``` swift-example
let x: Int? = 3
let y: Int? = nil
let z: Int? = x + y
```

This program isn't accepted by the Swift compiler. Can you spot the error?

The problem is that addition only works on `Int` values, rather than the
optional `Int?` values we have here. To resolve this, we could introduce nested
`if` statements, as follows:

*/

func add(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    if let x = optionalX {
        if let y = optionalY {
            return x + y
        }
    }
    return nil
}

/*:
However, instead of the deep nesting, we can also bind multiple optionals at the
same time:

*/

func add2(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    if let x = optionalX, let y = optionalY {
        return x + y
    }
    return nil
}

/*:
Even shorter, we can also use a `guard` statement to exit early in case of
missing values:

*/

func add3(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    guard let x = optionalX, let y = optionalY else { return nil }
    return x + y
}

/*:
This may seem like a contrived example, but manipulating optional values can
happen all the time. Suppose we have the following dictionary, associating
countries with their capital cities:

*/

let capitals = [
    "France": "Paris",
    "Spain": "Madrid",
    "The Netherlands": "Amsterdam",
    "Belgium": "Brussels"
]

/*:
In order to write a function that returns the number of inhabitants for the
capital of a given country, we use the `capitals` dictionary in conjunction with
the `cities` dictionary defined previously. For each dictionary lookup, we have
to make sure that it actually returned a result:

*/

func populationOfCapital(country: String) -> Int? {
    guard let capital = capitals[country], let population = cities[capital]
        else { return nil }
    return population * 1000
}

/*:
Both optional chaining and `if let` (or `guard let`) are special constructs in
the language to make working with optionals easier. However, Swift offers yet
another way to solve the problem above: the function `flatMap` in the standard
library. The `flatMap` function is defined on multiple types, and in the case of
optionals, it looks like this:

*/

extension Optional {
    func flatMap_sample_impl<U>(_ transform: (Wrapped) -> U?) -> U? {
        guard let x = self else { return nil }
        return transform(x)
    }
}

/*:
The `flatMap` function checks whether an optional value is non-`nil`. If it is,
we pass it on to the argument function `transform`; if the optional argument is
`nil`, the result is also `nil`.

Using this function, we can now write our examples as follows:

*/

func add4(_ optionalX: Int?, _ optionalY: Int?) -> Int? {
    return optionalX.flatMap { x in
        optionalY.flatMap { y in
            return x + y
        }
    }
}

func populationOfCapital2(country: String) -> Int? {
    return capitals[country].flatMap { capital in
        cities[capital].flatMap { population in
            population * 1000
        }
    }
}

/*:
Instead of nesting the `flatMap` calls, we can also rewrite
`populationOfCapital2` in such a way that the calls are chained, thereby making
the structure of the code more shallow:

*/

func populationOfCapital3(country: String) -> Int? {
    return capitals[country].flatMap { capital in
        cities[capital]
    }.flatMap { population in
        population * 1000
    }
}

/*:
We don't want to advocate that `flatMap` is the 'right' way to combine optional
values. Instead, we hope to show that optional binding isn't magically built in
to the Swift compiler, but rather a control structure you can implement yourself
using a higher-order function.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
