/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Optional `flatMap`

As we saw in the built-in collections chapter, it's common to want to `map` over
a collection with a function that returns a collection, but collect the results
as a single array rather than an array of arrays.

Similarly, if you want to perform a `map` on an optional value, but your
transformation function also has an optional result, you'll end up with a doubly
nested optional. An example of this is when you want to fetch the first element
of an array of strings as a number, using `first` on the array and then `map` to
convert it to a number:

*/

let stringNumbers = ["1", "2", "3", "foo"]
let x = stringNumbers.first.map { Int($0) }

/*:
The problem is that since `map` returns an optional (`first` might have been
`nil`) and `Int(someString)` returns an optional (the string might not be an
integer), the type of `x` will be `Int??`.

`flatMap` will instead flatten the result into a single optional. As a result,
`y` will be of type `Int?`:

*/

let y = stringNumbers.first.flatMap { Int($0) }

/*:
Instead, you could've written this with `if let`, because values that are bound
later can be computed from earlier ones:

*/

if let a = stringNumbers.first, let b = Int(a) {
    print(b)
}

/*:
This shows that `flatMap` and `if let` are very similar. Earlier in this
chapter, we saw an example that uses a multiple-`if-let` statement. We can
rewrite it using `map` and `flatMap` instead:

*/

// --- (Hidden code block) ---
import UIKit
import PlaygroundSupport
// ---------------------------
let urlString = "https://www.objc.io/logo.png"
let view = URL(string: urlString)
    .flatMap { try? Data(contentsOf: $0) }
    .flatMap { UIImage(data: $0) }
    .map     { UIImageView(image: $0) }

if let view = view {
    PlaygroundPage.current.liveView = view
}

/*:
Optional chaining is also very similar to `flatMap`: `i?.advance(by: 1)` is
essentially equivalent to `i.flatMap { $0.advance(by: 1) }`.

Since we've shown that a multiple-`if-let` statement is equivalent to `flatMap`,
we could implement one in terms of the other:

*/

extension Optional {
    func flatMap_sample_impl<U>(transform: (Wrapped) -> U?) -> U? {
        if let value = self, let transformed = transform(value) {
            return transformed
        }
        return nil
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
