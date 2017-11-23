/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Case Study: Dictionaries

In addition to arrays, Swift has special support for working with
*dictionaries*. A dictionary is a collection of key-value pairs, and it provides
an efficient way to find the value associated with a certain key. The syntax for
creating dictionaries is similar to arrays:

*/

let cities = ["Paris": 2241, "Madrid": 3165, "Amsterdam": 827, "Berlin": 3562]

/*:
This dictionary stores the population of several European cities. In this
example, the key `"Paris"` is associated with the value `2241`; that is, Paris
has about 2,241,000 inhabitants.

As with arrays, the `Dictionary` type is generic. The type of dictionaries takes
two type parameters, corresponding to the types of the stored keys and stored
values, respectively. In our example, the city dictionary has type
`Dictionary<String, Int>`. There's also a shorthand notation, `[String: Int]`.

We can look up the value associated with a key using a subscript:

``` swift-example
let madridPopulation: Int = cities["Madrid"]
// Error: Value of optional type 'Int?' not unwrapped
```

This example, however, doesn't type check. The problem is that the key
`"Madrid"` may not be in the `cities` dictionary — and what value should be
returned if it isn't? We can't guarantee that the dictionary lookup operation
*always* returns an `Int` for every key. Swift's *optional* types track the
possibility of this kind of failure. The correct way to write the example above
would be the following:

*/

let madridPopulation: Int? = cities["Madrid"]

/*:
Instead of having type `Int`, the `madridPopulation` example has the optional
type `Int?`. A value of type `Int?` is either an `Int` or a special 'missing'
value, `nil`.

We can check whether or not the lookup was successful:

*/

if madridPopulation != nil {
    print("The population of Madrid is \(madridPopulation! * 1000)")
} else {
    print("Unknown city: Madrid")
}

/*:
If `madridPopulation` isn't `nil`, then the first branch is executed. Here we
use the `!` postfix operator to extract the actual integer value from
`madridPopulation`. Note, however, that this is an unsafe operation: the code
will crash if `madridPopulation` is `nil`. In this example, we've just made sure
that `madridPopulation` isn't `nil` in the line above, but it's easy to break
such assumptions later on.

Swift has a special *optional binding* mechanism that lets you avoid writing the
`!` suffix. We can combine the definition of `madridPopulation` and the check
above into a single statement:

*/

if let madridPopulation = cities["Madrid"] {
    print("The population of Madrid is \(madridPopulation * 1000)")
} else {
    print("Unknown city: Madrid")
}

/*:
If the lookup, `cities["Madrid"]`, is successful, we can use the variable
`madridPopulation` of type `Int` in the then-branch. Note that we no longer need
to explicitly use the forced unwrapping operator.

Given the choice, we'd recommend using optional binding over forced unwrapping.
Forced unwrapping may crash if you have a `nil` value; optional binding
encourages you to handle exceptional cases explicitly, thereby avoiding runtime
errors. Unchecked usage of the forced unwrapping of optional types or Swift's
[implicitly unwrapped
optionals](https://developer.apple.com/library/prerelease/mac/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html)
can be a bad code smell, indicating the possibility of runtime errors.

Swift also provides a safer alternative to the `!` operator, which requires an
additional default value to return when applied to `nil`. Roughly speaking, it
can be defined as follows:

``` swift-example
infix operator ??

func ??<T>(optional: T?, defaultValue: T) -> T {
    if let x = optional {
        return x
    } else {
        return defaultValue
    }
}
```

The `??` operator checks whether or not its optional argument is `nil`. If it
is, it returns its `defaultValue` argument; otherwise, it returns the optional's
underlying value.

There's one problem with this definition: the `defaultValue` will be evaluated,
regardless of whether or not the optional is `nil`. This is usually undesirable
behavior: an if-then-else statement should only execute *one* of its branches,
depending on whether or not the associated condition is true. This behavior is
sometimes called short circuiting, e.g. `||` and `&&` work the same way.
Similarly, the `??` operator should only evaluate the `defaultValue` argument
when the optional argument is `nil`. As an illustration, suppose we were to call
`??`, as follows:

*/

let cache = ["test.swift": 1000]
let defaultValue = 2000 // Read from disk
cache["hello.swift"] ?? defaultValue

/*:
In this example, we really don't want to evaluate `defaultValue` if the optional
value is non-nil — it could be a very expensive computation that we only want to
run if it's absolutely necessary. We can resolve this issue as follows:

*/

func ??<T>(optional: T?, defaultValue: () -> T) -> T {
    if let x = optional {
        return x
    } else {
        return defaultValue()
    }
}

/*:
Instead of providing a default value of type `T`, we now provide one of type `()
-> T`. The code in the `defaultValue` function is now only executed in the else
branch. The drawback is that when using the `??` operator, we need to wrap the
default value in an anonymous function. For example, we'd need to write the
following:

``` swift-example
myOptional ?? { myDefaultValue }
```

The definition in the Swift standard library avoids the need for creating
explicit closures by using Swift's [`autoclosure` type
attribute](https://developer.apple.com/library/prerelease/mac/documentation/Swift/Conceptual/Swift_Programming_Language/Types.html).
This implicitly wraps any arguments to the `??` operator in the required
closure. As a result, we can provide the same interface we initially had, but
without requiring the user to create an explicit closure wrapping the
`defaultValue` argument. The definition used in Swift's standard library is as
follows:

``` swift-example
infix operator ??

func ??<T>(optional: T?, defaultValue: @autoclosure () throws -> T) 
    rethrows -> T 
{
    if let x = optional {
        return x
    } else {
        return try defaultValue()
    }
}
```

The `??` operator provides a safer alternative to the forced optional unwrapping
without being as verbose as the optional binding.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
