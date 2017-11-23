/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Solving the Magic Value Problem with Enumerations

Of course, every good programmer knows magic numbers are bad. Most languages
support some kind of enumeration type, which is a safer way of representing a
set of discrete possible values for a type.

Swift takes enumerations further with the concept of "associated values." These
are enumeration values that can also have another value associated with them:

``` swift-example
enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}
```

In some languages, these are called ["tagged
unions"](https://en.wikipedia.org/wiki/Tagged_union) (or "discriminated unions")
— a union being multiple different possible types all held in the same space in
memory, with a tag to tell which type is actually held. In Swift enums, this tag
is the enum case.

The only way to retrieve an associated value is through pattern matching in a
`switch` or an `if case let` statement. Unlike with a sentinel value, you can't
accidentally use the value embedded in an `Optional` without explicitly checking
and unpacking it.

So instead of returning an index, the Swift equivalent of `find` — called
`index(of:)` — returns an `Optional<Index>` with a protocol extension
implementation somewhat similar to this:

*/

extension Collection where Element: Equatable {
    func index_sample_impl(of element: Element) -> Optional<Index> {
        var idx = startIndex
        while idx != endIndex {
            if self[idx] == element { 
                return .some(idx) 
            }
            formIndex(after: &idx)
        }
        // Not found, return .none
        return .none
    }
}

/*:
> Since optionals are fundamental to Swift, there's lots of syntax support to
> tidy this up: `Optional<Index>` can be written `Index?`; optionals conform to
> `ExpressibleByNilLiteral` so that you can write `nil` instead of `.none`; and
> non-optional values (like `idx`) are automatically "upgraded" to optionals
> where needed so that you can write `return idx` instead of `return
> .some(idx)`. The syntactic sugar is effective in disguising the true nature of
> the `Optional` type. It's worth remembering that there's nothing magical about
> it; it's just a normal enum, and if it didn't exist, you could define it
> yourself.

Now there's no way a user could mistakenly use the value before checking if it's
valid:

``` swift-example
var array = ["one", "two", "three"]
let idx = array.index(of: "four")
// Compile-time error: remove(at:) takes an Int, not an Optional<Int>
array.remove(at: idx)
```

Instead, you're forced to "unwrap" the optional in order to get at the index
within, assuming you didn't get `none` back:

*/

var array = ["one", "two", "three"]
switch array.index(of: "four") {
case .some(let idx):
    array.remove(at: idx)
case .none:
    break  // Do nothing
}

/*:
This switch statement writes the enumeration syntax for optionals out longhand,
including unpacking the associated value in the `some` case. This is great for
safety, but it's not very pleasant to read or write. A more succinct alternative
is to use the `?` pattern suffix syntax to match a `some` optional value, and
you can use the `nil` literal to match `none`:

*/

switch array.index(of: "four") {
case let idx?:  // Equivalent to .some(let idx)
    array.remove(at: idx)
case nil:
    break // Do nothing
}

/*:
But this is still clunky. Let's take a look at all the other ways you can make
your optional processing short and clear, depending on your use case.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
