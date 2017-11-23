/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Equating Optionals

Often, you don't care whether a value is `nil` or not — just whether it contains
(if non-`nil`) a certain value:

*/

let regex = "^Hello$"
// ...
if regex.first == "^" {
    // match only start of string
}

/*:
In this case, it doesn't matter if the value is `nil` or not — if the string is
empty, the first character can't be a caret, so you don't want to run the block.
But you still want the protection and simplicity of `first`. The alternative,
`if !regex.isEmpty && regex[regex.startIndex] == "^"`, is horrible.

The code above relies on two things to work. First, there's a version of `==`
that takes two optionals, with an implementation something like this:

``` swift-example
func ==<T: Equatable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case (nil, nil): return true
    case let (x?, y?): return x == y
    case (_?, nil), (nil, _?): return false
    }
}
```

This overload *only* works on optionals of equatable types. Given this, there
are four possibilities: they're both `nil`, or they both have a value, or either
one or the other is `nil`. The `switch` exhaustively tests all four
possibilities (hence no need for a `default` clause). It defines two `nil`s to
be equal to each other, `nil` to never be equal to non-`nil`, and two non-`nil`
values to be equal if their unwrapped values are equal.

But this is only half the story. Notice that we did *not* have to write the
following:

*/

if regex.first == Optional("^") { // or: == .some("^")
    // Match only start of string
}

/*:
This is because whenever you have a non-optional value, Swift will always be
willing to upgrade it to an optional value in order to make the types match.

This implicit conversion is incredibly useful for writing clear, compact code.
Suppose there was no such conversion, but to make things nice for the caller,
you wanted a version of `==` that worked between both optional and non-optional
types. You'd have to write three separate versions:

``` swift-example
// Both optional
func == <T: Equatable>(lhs: T?, rhs: T?) -> Bool
// lhs non-optional
func == <T: Equatable>(lhs: T, rhs: T?) -> Bool
// rhs non-optional
func == <T: Equatable>(lhs: T?, rhs: T) -> Bool
```

But instead, only the first version is necessary, and the compiler will convert
to optionals where necessary.

In fact, we've been relying on this throughout the book. For example, when we
implemented optional `map`, we transformed the inner value and returned it. But
the return value of `map` is optional. The compiler automatically converted the
value for us — we didn't have to write `return Optional(transform(value))`.

Swift code constantly relies on this implicit conversion. For example,
dictionary subscript lookup by key returns an optional (the key might not be
present). But it also takes an optional on assignment — subscripts have to both
take and receive the same type. Without implicit conversion, you'd have to write
`myDict["someKey"] = Optional(someValue)`.

Incidentally, if you're wondering what happens to dictionaries with key-based
subscript assignment when you assign a `nil` value, the answer is that the key
is removed. This can be useful, but it also means you need to be a little
careful when dealing with a dictionary with an optional value type. Consider
this dictionary:

*/

var dictWithNils: [String: Int?] = [
    "one":  1,
    "two":  2,
    "none": nil
]

/*:
The dictionary has three keys, and one of them has a value of `nil`. Suppose we
wanted to set the value of the `"two"` key to `nil` as well. This will *not* do
that:

*/

dictWithNils["two"] = nil
dictWithNils

/*:
Instead, it'll *remove* the `"two"` key.

To change the value for the key, you'd have to write one of the following (they
all work, so choose whichever you feel is clearer):

*/

dictWithNils["two"] = Optional(nil)
dictWithNils["two"] = .some(nil)
dictWithNils["two"]? = nil
dictWithNils

/*:
Note that the third version above is slightly different than the other two. It
works because the `"two"` key is already in the dictionary, so it uses optional
chaining to set its value if successfully fetched. Now try this with a key that
isn't present:

*/

dictWithNils["three"]? = nil
dictWithNils.index(forKey: "three")

/*:
You can see that nothing would be updated/inserted.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
