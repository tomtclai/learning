/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## A Swifty Alternative for the Parser Type

At the beginning of this chapter we defined the parser type like this:

*/

struct Parser<Result> {
    typealias Stream = String.CharacterView
    let parse: (Stream) -> (Result, Stream)?
}

/*:
This is the purely functional approach of defining it: the `parse` function has
no side effects, and the result and the remaining input stream are returned as a
tuple.

With Swift, there's a different approach we could take by using the `inout`
keyword:

*/

struct Parser2<Result> {
    typealias Stream = String.CharacterView
    let parse: (inout Stream) -> Result?
}

/*:
The `inout` keyword allows us to mutate the input stream so we can return just
the result instead of the tuple containing the result and the remainder.

It's important to note that `inout` isn't the same as passing a value by
reference e.g. in Objective-C. We can still work with the parameter like with
any other simple value. The difference is that the value gets copied back out as
soon as the function returns. Therefore, there's no danger of global side
effects when using `inout`, since the mutation is limited to one specific
variable.

Using an `inout` parameter on `parse` simplifies the implementation of some
combinators. For example, the `many` combinator can now be written like this:

*/

extension Parser2 {
    var many: Parser2<[Result]> {
        return Parser2<[Result]> { input in
            var result: [Result] = []
            while let element = self.parse(&input) {
                result.append(element)
            }
            return result
        }
    }
}

/*:
In contrast to our previous implementation, we don't have to manage the
remainder of each parsing step ourselves, since each call to `self.parse` simply
mutates `input`.

Other combinators like `or` become a bit more tricky to implement:

*/

extension Parser2 {
    func or(_ other: Parser2<Result>) -> Parser2<Result> {
        return Parser2<Result> { input in
            let original = input
            if let result = self.parse(&input) { return result }
            input = original // reset input
            return other.parse(&input)
        }
    }
}

/*:
Since the call to `self.parse` mutates `input`, we first have to store a copy of
`input` in another variable so that we can restore it in case `self.parse`
returns `nil`.

There are good arguments to be made for either implementation, and we were
ambivalent about this choice ourselves. In the end, we decided to use the purely
functional version in this chapter because we felt that it's better suited to
explain the idea behind parser combinators.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
