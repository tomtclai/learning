/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Transforming Arrays

#### Map

It's common to need to perform a transformation on every value in an array.
Every programmer has written similar code hundreds of times: create a new array,
loop over all elements in an existing array, perform an operation on an element,
and append the result of that operation to the new array. For example, the
following code squares an array of integers:

*/

// --- (Hidden code block) ---
let fibs = [0, 1, 1, 2, 3, 5]
// ---------------------------
var squared: [Int] = []
for fib in fibs {
    squared.append(fib * fib)
}
squared

/*:
Swift arrays have a `map` method, adopted from the world of functional
programming. Here's the exact same operation, using `map`:

*/

let squares = fibs.map { fib in fib * fib }
squares


/*:
This version has three main advantages. It's shorter, of course. There's also
less room for error. But more importantly, it's clearer. All the clutter has
been removed. Once you're used to seeing and using `map` everywhere, it acts as
a signal — you see `map`, and you know immediately what's happening: a function
is going to be applied to every element, returning a new array of the
transformed elements.

The declaration of `squared` no longer needs to be made with `var`, because we
aren't mutating it any longer — it'll be delivered out of the `map` fully
formed, so we can declare `squares` with `let`, if appropriate. And because the
type of the contents can be inferred from the function passed to `map`,
`squares` no longer needs to be explicitly typed.

`map` isn't hard to write — it's just a question of wrapping up the boilerplate
parts of the `for` loop into a generic function. Here's one possible
implementation (though in Swift, it's actually an extension of `Sequence`,
something we'll cover in the chapter on writing generic algorithms):

*/

extension Array {
    func map_sample_impl<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

/*:
`Element` is the generic placeholder for whatever type the array contains. And
`T` is a new placeholder that can represent the result of the element
transformation. The `map` function itself doesn't care what `Element` and `T`
are; they can be anything at all. The concrete type `T` of the transformed
elements is defined by the return type of the `transform` function the caller
passes to `map`.

> Really, the signature of this method should be `func map<T>(_ transform:
> (Element) throws -> T) rethrows -> [T]`, indicating that `map` will forward
> any error the transformation function might throw to the caller. We'll cover
> this in detail in the errors chapter. We've left the error handling
> annotations out here for simplicity. If you'd like, you can check out [the
> source code for
> `Sequence.map`](https://github.com/apple/swift/blob/swift-4.0-branch/stdlib/public/core/Sequence.swift)
> in the Swift repository on GitHub.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
