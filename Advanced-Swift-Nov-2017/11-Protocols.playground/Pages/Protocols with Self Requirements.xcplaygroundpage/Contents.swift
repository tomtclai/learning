/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Protocols with `Self` Requirements

Protocols with `Self` requirements behave in a way similar to protocols with
associated types. One of the simplest protocols with a `Self` requirement is
`Equatable`. It has a single method (in the form of an operator) that compares
two elements:

``` swift-example
protocol Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool
}
```

Implementing `Equatable` for your own type isn't too hard. For example, if we
have a simple `MonetaryAmount` struct, we can compare two values by comparing
their properties:

*/

struct MonetaryAmount: Equatable {
    var currency: String
    var amountInCents: Int
    
    static func ==(lhs: MonetaryAmount, rhs: MonetaryAmount) -> Bool {
        return lhs.currency == rhs.currency &&
               lhs.amountInCents == rhs.amountInCents
    }
}

/*:
We can't simply declare a variable with `Equatable` as its type:

``` swift-example
// Error: 'Equatable' can only be used as a generic constraint
// because it has Self or associated type requirements
let x: Equatable = MonetaryAmount(currency: "EUR", amountInCents: 100)
```

This suffers from the same problems as associated types: from this (incorrect)
declaration, it's unclear what the `Self` type should be. For example, if it
were possible to use `Equatable` as a standalone type, you could also write
this:

``` swift-example
let x: Equatable = MonetaryAmount(currency: "EUR", amountInCents: 100)
let y: Equatable = "hello"
x == y
```

There's no definition of `==` that takes a monetary amount and a string. How
would you compare the two? However, we can use `Equatable` as a generic
constraint. For example, we could write a free function, `allEqual`, that checks
whether all elements in an array are equal:

*/

func allEqual<E: Equatable>(x: [E]) -> Bool {
    guard let firstElement = x.first else { return true }
    for element in x {
        guard element == firstElement else { return false }
    }
    return true
}

/*:
Or we could use it as a constraint when writing an extension on `Collection`:

*/

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        guard let firstElement = first else { return true }
        for element in self {
            guard element == firstElement else { return false }
        }
        return true
    }
}

/*:
The `==` operator is defined as a static function of the type. In other words,
it's not a member function, and it's statically dispatched. Unlike member
functions, we can't override it. If you have a class that implements `Equatable`
(for example, `NSObject`), you might get unexpected behavior when you create a
subclass. For example, consider the following class:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
class IntegerRef: NSObject {
    let int: Int
    init(_ int: Int) {
        self.int = int
    }
}

/*:
We can define a version of `==` that compares two `IntegerRef`s by comparing
their `int` properties:

*/

func ==(lhs: IntegerRef, rhs: IntegerRef) -> Bool {
    return lhs.int == rhs.int
}

/*:
If we create two `IntegerRef` objects, we can compare them, and everything works
as expected:

*/

let one = IntegerRef(1)
let otherOne = IntegerRef(1)
one == otherOne

/*:
However, if we use them as `NSObject`s, the `==` of `NSObject` is used (which
uses `===` under the hood to check if the references point to the same object).
Unless you're aware of the static dispatch behavior, the result might come as a
surprise:

*/

let two: NSObject = IntegerRef(2)
let otherTwo: NSObject = IntegerRef(2)
two == otherTwo

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
