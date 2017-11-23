/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
Of course, it would've been much better to define a generic version of `isEven`
that works on *any* integer as a computed property:

*/

extension BinaryInteger {
    var isEven: Bool { return self % 2 == 0 }
}

/*:
Alternatively, we could have chosen to define an `isEven` variant for all
`Integer` types as a free function:

*/

func isEven<T: BinaryInteger>(_ i: T) -> Bool {
    return i % 2 == 0
}

/*:
If you want to assign that free function to a variable, this is also when you'd
have to lock down which specific types it's operating on. A variable can't hold
a generic function — only a specific one:

*/

let int8isEven: (Int8) -> Bool = isEven

/*:
One final point on naming. It's important to keep in mind that functions
declared with `func` can be closures, just like ones declared with `{ }`.
Remember, a closure is a function combined with any captured variables. While
functions created with `{ }` are called *closure expressions*, people often
refer to this syntax as just *closures*. But don't get confused and think that
functions declared with the closure expression syntax are different from other
functions — they aren't. They're both functions, and they can both be closures.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
