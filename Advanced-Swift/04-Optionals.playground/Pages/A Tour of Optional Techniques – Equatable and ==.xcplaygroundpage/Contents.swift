/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
#### Equatable and `==`

Even though optionals have an `==` operator, this doesn't mean they can conform
to the `Equatable` protocol. This subtle but important distinction will hit you
in the face if you try and do the following:

``` swift-example
// Two arrays of optional integers
let a: [Int?] = [1, 2, nil]
let b: [Int?] = [1, 2, nil]

// Error: binary operator '==' cannot be applied to two [Int?] operands
a == b
```

The problem is that the `==` operator for arrays requires the elements of the
array to be equatable:

``` swift-example
func ==<Element : Equatable>(lhs: [Element], rhs: [Element]) -> Bool
```

Optionals don't conform to `Equatable` — that would require they implement `==`
for any kind of type they contain, and they only can if that type is itself
equatable. In the future, Swift will support conditional protocol conformance,
and only then will we be able to write something like this:

``` swift-example
extension Optional: Equatable where Wrapped: Equatable {
    // No need to implement anything; == is already implemented so long
    // as this condition is met.
}
```

In the meantime, you could implement a version of `==` for arrays of optionals,
like so:

*/

func ==<T: Equatable>(lhs: [T?], rhs: [T?]) -> Bool {
    return lhs.elementsEqual(rhs) { $0 == $1 }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
