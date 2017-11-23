/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Combining Parsers

*/

// --- (Hidden code block) ---
import Foundation

struct Parser<Result> {
    typealias Stream = String.CharacterView
    let parse: (Stream) -> (Result, Stream)?
}

extension Parser {
    func run(_ string: String) -> (Result, String)? {
        guard let (result, remainder) = parse(string.characters) else { return nil }
        return (result, String(remainder))
    }
}

func character(condition: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser { input in
        guard let char = input.first, condition(char) else { return nil }
        return (char, input.dropFirst())
    }
}

extension CharacterSet {
    func contains(_ c: Character) -> Bool {
        let scalars = String(c).unicodeScalars
        guard scalars.count == 1 else { return false }
        return contains(scalars.first!)
    }
}

let digit = character { CharacterSet.decimalDigits.contains($0) }
// ---------------------------
/*:
Our first goal is to parse an integer instead of just a single digit. For this
we have to execute the `digit` parser multiple times and combine the results
into an integer value.

The first step is to create a combinator, `many`, that executes a parser
multiple times and returns the results as an array:

``` swift-example
extension Parser {
    var many: Parser<[Result]> {
        // ...
    }
}
```

The type of `many` is `Parser<[Result]>`, which gives us a clue of how to start
implementing the property's body: like in the `character` function, we have to
return a new `Parser`. Within the `parse` function, we then have to keep calling
`self.parse` and accumulate the results until parsing fails:

*/

extension Parser {
    var many: Parser<[Result]> {
        return Parser<[Result]> { input in
            var result: [Result] = []
            var remainder = input
            while let (element, newRemainder) = self.parse(remainder) {
                result.append(element)
                remainder = newRemainder
            }
            return (result, remainder)
        }
    }
}

digit.many.run("123")

/*:
Now that we're able to parse multiple digits into an array of characters, the
last step is to transform the array of characters into an integer. For this
task, we'll define `map` on `Parser`.

`map` on `Parser` transforms a parser of one result type into a parser of a
different result type, just like `map` on optionals transforms an optional of
one type into an optional of another type. The parse function of the new parser
we return from `map` simply tries to call `self.parse` on the input, and it
immediately returns `nil` if this fails. If it succeeds, it applies the
`transform` function to the result and returns the new result together with the
remainder:

*/

extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> {
        return Parser<T> { input in
            guard let (result, remainder) = self.parse(input) else { return nil }
            return (transform(result), remainder)
        }
    }
}

/*:
Using `many` and `map` makes it easy to finally define our integer parser:

*/

let integer = digit.many.map { Int(String($0))! }

integer.run("123")

/*:
If we run the integer parser on an input string that doesn't only contain
digits, everything from the first non-digit will be returned as the remainder:

*/

integer.run("123abc")

/*:
Note that the `digit.many` parser will currently also succeed on an empty
string, which then will crash at the point where we try to force unwrap the
result of the `Int` initializer. We'll come back to this issue a bit later.

### Sequence

Thus far, we can only execute one parser repeatedly and combine the results into
an array. However, we often want to execute multiple different parsers
consecutively. For example, in order to parse a multiplication expression like
`"2*3"`, we first have to parse an integer, then the `"*"` symbol, and lastly
another integer.

For this purpose, we'll introduce a sequence combinator, `followed(by:)`. As
with `many`, we implement this combinator as a method on `Parser`.
`followed(by:)` takes another parser as argument, and it returns a new parser
that combines the results of the two parsers in a tuple:

``` swift-example
extension Parser {
    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        // ...
    }
}
```

`followed(by:)` has a generic parameter, `A`, since the following parser doesn't
have to be of the same type as the parser we're calling `followed(by:)` on.

Once again, the return type of this method, `Parser<(Result, A)>`, gives us a
clue of how to implement the method's body. We have to return a new parser whose
`parse` function returns a result of type `(Result, A)`. Therefore, we first try
to call execute `self.parse` on the input. If this succeeds, we call
`other.parse` on the remainder returned by `self.parse`. If this also succeeds,
we return the combined result; otherwise, we return `nil`:

*/

extension Parser {
    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        return Parser<(Result, A)> { input in
            guard let (result1, remainder1) = self.parse(input) else { return nil }
            guard let (result2, remainder2) = other.parse(remainder1) 
                else { return nil }
            return ((result1, result2), remainder2)
        }
    }
}

/*:
Using `followed(by:)` and the previously defined integer and character parsers,
we can now define a parser for a multiplication expression:

*/

let multiplication = integer
    .followed(by: character { $0 == "*" })
    .followed(by: integer)
multiplication.run("2*3")

/*:
The result looks a bit complicated, since using `followed(by:)` multiple times
results in even more nested tuples. We'll improve this situation in a bit, but
first let's employ our `map` method to actually calculate the result of the
multiplication:

*/

let multiplication2 = multiplication.map { $0.0 * $1 }
multiplication2.run("2*3")

/*:
In the transform function passed to `map`, you can already see the problem
caused by the nested tuples: the first parameter is a tuple consisting of the
first integer value and the operator symbol, and the second parameter is the
second integer value. This is already hard to understand, and it'll only get
worse once we combine more parsers.

#### Improving Sequence

Let's take a step back and analyze where the problem is coming from. Each time
we combine two parsers using `followed(by:)`, the result is a tuple. It has to
be tuple (or something similar) because the results of the two parsers can have
different types. So we couldn't just accumulate the results in an array, as
we've done with the `many` combinator — at least not without throwing out all
type information.

We could avoid this issue if we could feed the result of each parser into the
evaluation function, one by one, instead of first collecting them all in nested
tuples to evaluate them afterward.

It turns out that there's a technique that enables exactly that: currying. We
already talked about currying in the chapter Wrapping Core Image. Essentially,
we can represent a function with two or more arguments in two ways: either as a
function that takes all arguments at once, or as a *curried* function that takes
one argument at a time. Let's take a look at what this means for our
multiplication function.

First we can pull out the transform function used with `map`:

*/

func multiply(lhs: (Int, Character), rhs: Int) -> Int { 
    return lhs.0 * rhs
}

/*:
Since we want to get rid of the nested tuples anyway, we can also write this
function in a more readable way:

*/

func multiply(_ x: Int, _ op: Character, _ y: Int) -> Int {
    return x * y
}

/*:
The curried version of the same function looks like this:

*/

func curriedMultiply(_ x: Int) -> (Character) -> (Int) -> Int {
    return { op in
        return { y in
            return x * y
        }
    }
}

/*:
The curried function looks very different at the call site. For the arguments
`2`, `"*"`, and `3`, we'd call it like this:

*/

curriedMultiply(2)("*")(3)

/*:
Here we already notice that this will help us avoid the nested tuple issue,
since we can pass in the results of the parsers one at a time.

Let's unpack the call of `curriedMultiply` further. If we just call it with the
first argument, `2`, the return value is a function of type `(Character) ->
(Int) -> Int`. Consequently, calling this returned function with the next
argument, `"*"`, returns another function, but this time of type `(Int) -> Int`.
Applying the last argument, `3`, finally yields the result of the
multiplication.

As a side note: it can be a bit tedious to type out curried functions by hand.
Instead, we can also define a `curry` function that turns non-curried functions
with a certain number of arguments into the curried variant. For example, for
two arguments, `curry` is defined like this:

*/

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

/*:
How can we use `curriedMultiply` to simplify our multiplication parser? The type
of the first integer parser and the type of the first argument of
`curriedMultiply` are the same. So we can use `map` to apply `curriedMultiply`
to the result of the `int` parser:

*/

let p1 = integer.map(curriedMultiply)

/*:
Can you guess the type of the resulting parser?

The result type of `p1` is now the same type as the type of `curriedMultiply`
with only its first argument applied: `(Character) -> (Int) -> Int`. At this
point, things are going to get even weirder, but hang in there, we're almost
done\!

We'll use `followed(by:)` to add the multiplication symbol parser again:

*/

let p2 = p1.followed(by: character { $0 == "*" })

/*:
The type of `p2` is now a tuple: the first element of the tuple has the result
type of `p1`, `(Character) -> (Int) -> Int`. The second element has the result
type of the character parser, `Character`. Again, we notice that the type of the
function's first argument matches the type of the second element in the tuple;
they're both `Character`. So let's use `map` again to apply the second element
of the tuple to the first:

*/

let p3 = p2.map { f, op in f(op) }

/*:
The result type of `p3` is now `(Int) -> Int`. So we just repeat the process to
add the last integer parser:

*/

let p4 = p3.followed(by: integer)
let p5 = p4.map { f, y in f(y) }

/*:
`p5` now has a result type of `Int`:

*/

p5.run("2*3")

/*:
Let's write down the multiplication parser in one piece again:

*/

let multiplication3 = 
    integer.map(curriedMultiply)
        .followed(by: character { $0 == "*" }).map { f, op in f(op) }
        .followed(by: integer).map { f, y in f(y) }

/*:
No nested tuples anymore\! Admittedly, it's still a confusing piece of code, but
we can improve upon it.

On closer inspection of the code above, we see that the last two lines share a
common pattern: we call `followed(by:)` with another parser, and then we map
over the result. The transform functions are actually the same in both calls to
`map`; they just differ in parameter naming. We can abstract this common pattern
into the sequence operator, `<*>`:

``` swift-example
func <*>(lhs: Parser<...>, rhs: Parser<...>) -> Parser<...> {
    return lhs.followed(by: rhs).map { f, x in f(x) }
}
```

We just have to figure out the types for the arguments as well as the return
type. Looking at the first call to `followed(by:)` in `evaluatedMultiplication`,
we know what the result type of the left-hand side parser has to be, since we
know the type of `int.map(curriedMultiply)`: it's a function taking a single
argument and returning a value. Consequently, the type of the right-hand side
parser has to match the type of the function argument of the left-hand side
parser. Lastly, the result type of the returned parser has to be the same type
as the return type of the function in the left-hand side parser:

*/

func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    return lhs.followed(by: rhs).map { f, x in f(x) }
}

/*:
In order to be able to use this operator, we still have to specify that it's an
infix operator, and we also have to specify its associativity and precedence:

*/

precedencegroup SequencePrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <*>: SequencePrecedence

/*:
Once you're familiar with this operator, using it makes the parser code much
more readable:

*/

let multiplication4 = 
    integer.map(curriedMultiply) <*> character { $0 == "*" } <*> integer

/*:
This is better already. However, what's not so nice is that the
`.map(curriedMultiply)` call sits in between the first integer parser and the
other parsers. It would read much more like a grammar definition if we could
turn this around. To do so, we define the apply operator, `<^>`, which is just
`map` the other way around:

*/

infix operator <^>: SequencePrecedence
func <^><A, B>(lhs: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}

/*:
Now we can write the multiplication parser like this:

*/

let multiplication5 = 
    curriedMultiply <^> integer <*> character { $0 == "*" } <*> integer

/*:
Once you get used to this syntax, it's very easy to understand what the parser
is doing. You can read the `<^>` operator like a function call:
`curriedMultiply` is called with three arguments, namely the results of the
integer, the character, and the integer parser:

    multiply(integer, character { $0 == "*" }, integer)

#### Another Variant of Sequence

In addition to the sequence operator `<*>`, defined above, it's often handy to
define another variant of it, which also combines two parsers but throws away
the result of the first one. We'll use this later on to parse arithmetic
operators like `"*"` or `"+"` followed by an integer. In those cases, we're not
interested in the result of parsing the operator; we just want to make sure it's
there.

We use the symbol `*>` for this operator and define it in terms of the `<*>`
operator:

*/

infix operator *>: SequencePrecedence
func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    return curry({ _, y in y }) <^> lhs <*> rhs
}

/*:
Analogous to this, we can also define a `<*` operator that throws away the
result of the parser on the right-hand side. We'll make use of this combinator
in the next chapter:

*/

infix operator <*: SequencePrecedence
func <*<A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<A> {
    return curry({ x, _ in x }) <^> lhs <*> rhs
}

/*:
### Choice

Another way we often want to combine parsers is with something akin to an "or"
operator. For example, we want to express that either a `"*"` symbol or a `"+"`
symbol should be parsed.

For this purpose, we add another combinator method on `Parser`:

*/

extension Parser {
    func or(_ other: Parser<Result>) -> Parser<Result> {
        return Parser<Result> { input in
            return self.parse(input) ?? other.parse(input)
        }
    }
}

let star = character { $0 == "*" }
let plus = character { $0 == "+" }
let starOrPlus = star.or(plus)
starOrPlus.run("+")

/*:
Similar to the sequence operator above, we'll also define a choice operator,
`<|>`:

*/

infix operator <|>
func <|><A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    return lhs.or(rhs)
}

/*:
With this operator, we can write the above example like so:

*/

(star <|> plus).run("+")

/*:
### One or More

When we defined our integer parser above, it still had one shortcoming: since we
used the `many` combinator (which translates to zero or more occurrences), the
`int` parser will also try to convert an empty string into an integer, which of
course causes a crash.

To fix this, we'll introduce a `many1` combinator that tries to apply a parser
one or more times. We've postponed `many1` up to this point, because now we can
use the sequence operator to implement it:

``` swift-example
extension Parser {
    var many1: Parser<[Result]> {
        return { x in { manyX in [x] + manyX } } <^> self <*> self.many
    }
}
```

We express the one or more requirement by writing `self <*> self.many`. The
anonymous function in front of the `<^>` operator is a curried function that
prepends the single result from `self` with the array of results from
`self.many`. This isn't very readable, but we can also write the function in a
non-curried way and use `curry` to turn it into its curried counterpart:

*/

extension Parser {
    var many1: Parser<[Result]> {
        return curry({ [$0] + $1 }) <^> self <*> self.many
    }
}

/*:
### Optional

Often we want to express that certain characters should be optionally parsed,
i.e. they could just as well be missing and parsing would continue as normal. We
can express this with the following `optional` combinator:

*/

extension Parser {
    var optional: Parser<Result?> {
        return Parser<Result?> { input in
            guard let (result, remainder) = self.parse(input) else { return (nil, input) }
            return (result, remainder)
        }
    }
}

/*:
We'll put this combinator to use when we build the parser for arithmetic
expressions in the next section.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
