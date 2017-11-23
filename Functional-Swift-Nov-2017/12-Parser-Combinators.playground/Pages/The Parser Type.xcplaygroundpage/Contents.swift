/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Parser Type

Before we can start implementing the core parts of our parser combinator
library, we first have to think about what a parser actually does. Generally
speaking, a parser takes some characters (a string) as input and returns some
resulting value and the remainder of the string if parsing succeeds. If parsing
fails, it returns nothing. We could express this as a function type, like so:

``` swift-example
typealias Parser<Result> = (String) -> (Result, String)?
```

Of course, a parser doesn't necessarily have to operate on characters; it could
operate on any sequence of input tokens. For the sake of simplicity, however,
we'll stick to parsing characters in this chapter.

It turns out that it's bad for performance to operate on strings directly.
Instead of using a string as the type of the input and the remainder, we'll
immediately use a `String.CharacterView` instead. This step is already an
optimization, but it's an easy one to make, and it comes with a big upside:

``` swift-example
typealias Stream = String.CharacterView
typealias Parser<Result> = (Stream) -> (Result, Stream)?
```

Next, we'll define our `Parser` type as a struct instead of a simple type alias.
This allows us to implement combinators as methods on `Parser` instead of as
free functions, which will make the code easier to read:

*/

struct Parser<Result> {
    typealias Stream = String.CharacterView
    let parse: (Stream) -> (Result, Stream)?
}

/*:
Now we can implement our first parser. A basic building block we'll need all the
time is a parser that parses a character matching a condition:

``` swift-example
func character(matching condition: @escaping (Character) -> Bool)
    -> Parser<Character> {
    // ...
}
```

`character` is a convenience function that constructs a parser, which tries to
parse a character matching a certain condition. Since the return type of this
function is `Parser`, we can start implementing the function's body by returning
a new `Parser`:

``` swift-example
func character(matching condition: @escaping (Character) -> Bool)
    -> Parser<Character> {
    return Parser(parse: { input in
        // ...
    })
}
```

All that's left to do is to check whether `condition` holds true for the first
character of `input`. If so, we return a tuple containing the first character
and the remainder of the input. If the first character doesn't match, we simply
return `nil`. We'll also use the trailing closure syntax to call the initializer
of the `Parser` type:

*/

func character(condition: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser { input in
        guard let char = input.first, condition(char) else { return nil }
        return (char, input.dropFirst())
    }
}

/*:
Let's test our character parser by trying to parse the digit `"1"` from an input
string of multiple digits:

*/

let one = character { $0 == "1" }
one.parse("123".characters)

/*:
To make it more convenient to test our parsers, we'll add a `run` method on
`Parser`, which transforms an input string into a character view for us, and
turns the remainder in the result back into a string. This makes the output
easier to understand:

*/

extension Parser {
    func run(_ string: String) -> (Result, String)? {
        guard let (result, remainder) = parse(string.characters) else { return nil }
        return (result, String(remainder))
    }
}

one.run("123")

/*:
Since we're mostly not just interested in the character `"1"`, but in any digit,
let's immediately use our `character` function to create a digit parser. To
check if a character actually is a decimal digit, we'll use Foundation's
`CharacterSet` class. The `contains` method on `CharacterSet` expects a value of
type `UnicodeScalar`, but we want to check the character set against a value of
type `Character`. So first we add a small helper on `CharacterSet` for this
purpose:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
extension CharacterSet {
    func contains(_ c: Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else { return false }
        return contains(scalars.first!)
    }
}

/*:
With this helper in place, it's easy to define a parser for digits:

*/

let digit = character { CharacterSet.decimalDigits.contains($0) }

digit.run("456")

/*:
Next we'll look at how we can combine these atomic parsers into more powerful
ones.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
