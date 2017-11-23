/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Optional `map`

Let's say we have an array of characters, and we want to turn the first element
into a string:

*/

let characters: [Character] = ["a", "b", "c"]
String(characters[0])

/*:
If it's possible for `characters` to be empty, we can use an `if let` to create
the string only if the array is non-empty:

*/

var firstCharAsString: String? = nil
if let char = characters.first {
    firstCharAsString = String(char)
}

/*:
So now, if the array contains at least one element, `firstCharAsString` will
contain that element as a `String`. But if it doesn't, `firstCharAsString` will
be `nil`.

This pattern — take an optional, and transform it if it isn't `nil` — is common
enough that there's a method on optionals to do this. It's called `map`, and it
takes a closure that represents how to transform the contents of the optional.
Here's the above function, rewritten using `map`:

*/

let firstChar = characters.first.map { String($0) }

/*:
This `map` is, of course, very similar to the `map` on arrays or other
sequences. But instead of operating on a sequence of values, it operates on just
one: the possible one inside the optional. You can think of optionals as being a
collection of either zero or one values, with `map` either doing nothing to zero
values or transforming one.

Given the similarities, the standard library's implementation of optional `map`
looks a lot like collection `map`:

*/

extension Optional {
    func map_sample_impl<U>(transform: (Wrapped) -> U) -> U? {
        if let value = self {
            return transform(value)
        }
        return nil
    }
}

/*:
An optional `map` is especially nice when you already want an optional result.
Suppose you wanted to write another variant of `reduce` for arrays. Instead of
taking an initial value, it uses the first element in the array (in some
languages, this might be called `reduce1`, but we'll call it `reduce` and rely
on overloading):

Because of the possibility that the array might be empty, the result needs to be
optional — without an initial value, what else could it be? You might write it
like this:

*/

extension Array {
    func reduce(_ nextPartialResult: (Element, Element) -> Element) -> Element? {
        // first will be nil if the array is empty
        guard let fst = first else { return nil }
        return dropFirst().reduce(fst, nextPartialResult)
    }
}

/*:
You can use it like this:

*/

[1, 2, 3, 4].reduce(+)

/*:
Since optional `map` returns `nil` if the optional is `nil`, `reduce` could be
rewritten using a single `return` statement (and no `guard`):

*/

extension Array {
    func reduce_alt(_ nextPartialResult: (Element, Element) -> Element) 
        -> Element? 
    {
        return first.map {
            dropFirst().reduce($0, nextPartialResult)
        }
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
