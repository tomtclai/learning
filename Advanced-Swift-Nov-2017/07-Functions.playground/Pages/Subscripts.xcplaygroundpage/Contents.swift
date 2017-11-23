/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Subscripts

We've already seen subscripts in the standard library. For example, we can
perform a dictionary lookup like so: `dictionary[key]`. These subscripts are
very much a hybrid of functions and computed properties, with their own special
syntax. Like functions, they take arguments. Like computed properties, they can
be either read-only (using `get`) or read-write (using `get set`). Just like
normal functions, we can overload them by providing multiple variants with
different types — something that isn't possible with properties. For example,
arrays have two subscripts by default — one to access a single element, and one
to get at a slice (to be precise, these are declared in the `Collection`
protocol):

*/

let fibs = [0, 1, 1, 2, 3, 5]
let first = fibs[0]
fibs[1..<3]

/*:
### Custom Subscripts

We can add subscripting support to our own types, and we can also extend
existing types with new subscript overloads. As an example, let's define a
`Collection` subscript that takes a list of indices and returns an array of all
elements at those indices:

*/

extension Collection {
    subscript(indices indexList: Index...) -> [Element] {
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}

/*:
Note how we used an explicit parameter label to disambiguate our subscript from
those in the standard library. The three dots indicate that `indexList` is a
*variadic parameter*. The caller can pass zero or more comma-separated values of
the specified type (here, the collection's `Index` type). Inside the function,
the parameters are made available as an array.

We can use the new subscript like this:

*/

Array("abcdefghijklmnopqrstuvwxyz")[indices: 7, 4, 11, 11, 14]

/*:
### Advanced Subscripts

Subscripts aren't limited to a single parameter. We've already seen an example
of a subscript that takes more than one parameter: the dictionary subscript that
takes a key and a default value. Check out [its
implementation](https://github.com/apple/swift/blob/6a6adb74384151a196a9361c1303d4b00245dad4/stdlib/public/core/HashedCollections.swift.gyb#L1976-L1989)
in the Swift source code if you're interested.

New in Swift 4, subscripts can now also be generic in their parameters or their
return type. Consider a heterogeneous dictionary of type `[String: Any]`:

*/

var japan: [String: Any] = [
    "name": "Japan",
    "capital": "Tokyo",
    "population": 126_740_000,
    "coordinates": [
        "latitude": 35.0,
        "longitude": 139.0
    ]
]

/*:
If you want to mutate a nested value in this dictionary, e.g. the coordinate's
latitude, you'll find it isn't so easy:

``` swift-example
// Error: Type 'Any' has no subscript members
japan["coordinate"]?["latitude"] = 36.0
```

OK, that's understandable. The expression `japan["coordinate"]` has the type
`Any?`, so you'd probably try to cast it to a dictionary before applying the
nested subscript:

``` swift-example
// Error: Cannot assign to immutable expression
(japan["coordinates"] as? [String: Double])?["coordinate"] = 36.0
```

Alas, not only is this becoming ugly fast, but it doesn't work either. The
problem is that you can't mutate a variable through a typecast — the expression
`japan["coordinates"] as? [String: Double]` is no longer an lvalue. You'd have
to store the nested dictionary in a local variable first, then mutate that
variable, and then assign the local variable back to the top-level key.

We can do better by extending `Dictionary` with a generic subscript that takes
the desired target type as a second parameter and attempts the cast inside the
subscript implementation:

*/

extension Dictionary {
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            guard let value = newValue as? Value else {
                return
            }
            self[key] = value
        }
    }
}

/*:
Since we no longer have to downcast the value returned by the subscript, the
mutation operation goes through to the top-level dictionary variable:

*/

japan["coordinates", as: [String: Double].self]?["latitude"] = 36.0
japan["coordinates"]

/*:
Generic subscripts close an important hole in the type system. That said, you'll
notice the final syntax in this example is still quite ugly. Swift is generally
not well suited for working on heterogeneous collections like this dictionary.
In most cases, you'll be better off defining your own custom types for your data
(e.g. here, a `Country` struct) and conforming those types to `Codable` for
converting value to and from data transfer formats.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
