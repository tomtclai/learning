/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Parsing

*/

// --- (Hidden code block) ---
import Foundation

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
}

func curry<A, B, C, D>(_ f: @escaping (A, B, C) -> D) -> (A) -> (B) -> (C) -> D {
    return { a in { b in { c in f(a, b, c) } } }
}

struct Parser<Result> {
    typealias Stream = String.CharacterView
    let parse: (Stream) -> (Result, Stream)?
}

extension Parser {
    func map<T>(_ transform: @escaping (Result) -> T) -> Parser<T> {
        return Parser<T> { input in
            guard let (result, remainder) = self.parse(input) else { return nil }
            return (transform(result), remainder)
        }
    }

    func followed<A>(by other: Parser<A>) -> Parser<(Result, A)> {
        return Parser<(Result, A)> { input in
            guard let (result1, remainder1) = self.parse(input) else { return nil }
            guard let (result2, remainder2) = other.parse(remainder1) else { return nil }
            return ((result1, result2), remainder2)
        }
    }

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

    var many1: Parser<[Result]> {
        return curry({ [$0] + $1 }) <^> self <*> self.many
    }

    var optional: Parser<Result?> {
        return Parser<Result?> { input in
            guard let (result, remainder) = self.parse(input) else { return (nil, input) }
            return (result, remainder)
        }
    }
    
    func or(_ other: Parser<Result>) -> Parser<Result> {
        return Parser<Result> { input in
            return self.parse(input) ?? other.parse(input)
        }
    }

    func run(_ string: String) -> (Result, String)? {
        guard let (result, remainder) = parse(string.characters) else { return nil }
        return (result, String(remainder))
    }
}


precedencegroup SequencePrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <*>: SequencePrecedence
func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    return lhs.followed(by: rhs).map { f, x in f(x) }
}

infix operator *>: SequencePrecedence
func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    return curry({ _, y in y }) <^> lhs <*> rhs
}

infix operator <*: SequencePrecedence
func <*<A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<A> {
    return curry({ x, _ in x }) <^> lhs <*> rhs
}

infix operator <^>: SequencePrecedence
func <^><A, B>(lhs: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}

infix operator <|>: SequencePrecedence
func <|><A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    return lhs.or(rhs)
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

let integer = digit.many1.map { Int(String($0))! }
// ---------------------------
/*:
To build our spreadsheet expression parser, we make use of the parser combinator
code we developed in the last chapter. If you haven't read the previous chapter
yet, we recommend you first work through it and then come back here.

Compared to the parser for arithmetic expressions from the last chapter, we'll
introduce one more level of abstraction when parsing spreadsheet expressions. In
the last chapter, we wrote our parsers in a way that they immediately return the
evaluated result. For example, for multiplication expressions like `"2*3"` we
wrote:

``` swift-example
let multiplication = curry({ $0 * ($1 ?? 1) }) <^>
    integer <*> (character { $0 == "*" } *> integer).optional
```

The type of `multiplication` is `Parser<Int>`, i.e. executing this parser on the
input string `"2*3"` will return the integer value `6`.

Immediately evaluating the result only works as soon as the expressions we parse
don't depend on any data outside of the expression itself. However, in our
spreadsheet we want to allow expressions like `A3` to reference another cell's
value or function calls like `SUM(A1:A3)`.

To support such features, the parser task is to turn the input string into an
intermediate representation of the expression, also referred to as an *abstract
syntax tree*, which describes what's in the expression. In the next step, we can
take this structured data and actually evaluate it.

> In more complex scenarios (e.g. parsing a programming language), you'd often
> use one more intermediate layer: first the text gets turned into a sequence of
> tokens; then the tokens are turned into the abstract syntax tree; and finally
> the syntax tree gets evaluated.

We define this intermediate representation as an enum:

*/

indirect enum Expression {
    case int(Int)
    case reference(String, Int)
    case infix(Expression, String, Expression)
    case function(String, Expression)
}

/*:
The `Expression` enum contains four cases:

  - `int` represents simple numeric values.

  - `reference` represents references to values in other cells, e.g. `"A3"`. The
    column is specified by a capital letter and starts with `"A"`. The row is
    specified by a number and starts with `0`. The `reference` case has two
    associated values, a string and an integer, to store the referenced column
    and row.

  - `infix` represents operations with two arguments — one on the left-hand side
    of the operator, and the other on the right-hand side, e.g. `"A2+3"`. The
    associated values of the `infix` case store the expression on the left-hand
    side of the operator, the operator symbol itself, and the expression on the
    right-hand side.

  - `function` represents a function call like `"SUM(A1:A3)"`. The first
    associated value is the name of the function, and the second one is the
    function's parameter (in this implementation, functions can only have one
    parameter).

With the `Expression` enum in place, we can start to write a parser for each
kind of expression.

Let's start with the most simple case, `int`. Here we can utilize the integer
parser from last chapter and wrap the integer result in an `Expression`:

*/

extension Expression {
    static var intParser: Parser<Expression> {
        return { .int($0) } <^> integer
    }
}

Expression.intParser.run("123")

/*:
The parser for references is also very simple. We start by defining a parser for
capital letters:

*/

let capitalLetter = character { CharacterSet.uppercaseLetters.contains($0) }

/*:
Now we can combine the capital letter parser with an integer parser and wrap the
results in the `.reference` case:

*/

extension Expression {
    static var referenceParser: Parser<Expression> {
        return curry({ .reference(String($0), $1) }) <^> capitalLetter <*> integer
    }
}

Expression.referenceParser.run("A3")

/*:
Next, let's take a look at the `.function` case. Here we need to parse a
function name (one or more capital letters), followed by an expression in
parentheses. Within the parentheses, we expect something like `"A1:A2"`, since
that's the only supported parameter type in our example.

We start by defining two more helpers. First we add a `string` function to
create a parser that matches a specific string. We use the existing `character`
function to implement this:

*/

func string(_ string: String) -> Parser<String> {
    return Parser<String> { input in
        var remainder = input
        for c in string.characters {
            let parser = character { $0 == c }
            guard let (_, newRemainder) = parser.parse(remainder) else { return nil }
            remainder = newRemainder
        }
        return (string, remainder)
    }
}

string("SUM").run("SUM")

/*:
Then we define a convenience method on `Parser` that wraps an existing parser
with parsers for opening and closing parentheses:

*/

extension Parser {
    var parenthesized: Parser<Result> {
        return string("(") *> self <* string(")")
    }
}

string("SUM").parenthesized.run("(SUM)")

/*:
Here we use the `*>` and `<*` operators to combine the current parser with two
parsers that check for the presence of parentheses. This way, the parenthesis
parsers have to succeed, but their results are ignored.

With these two helpers, we can now write the parser for function expressions:

*/

extension Expression {
    static var functionParser: Parser<Expression> {
        let name = { String($0) } <^> capitalLetter.many1
        let argument = curry({ Expression.infix($0, String($1), $2) }) <^>
            referenceParser <*> string(":") <*> referenceParser
        return curry({ .function($0, $1) }) <^> name <*> argument.parenthesized
    }
}

/*:
Within `functionParser`, we first define a parser for the function name. Then we
define the parser for the function's argument, which is an `.infix` expression
using the `":"` operator and two reference arguments. Lastly, we combine all of
this by first parsing the function's name, followed by the function's argument
in parentheses.

We still have to handle arithmetic operators, like plus or times. This is
actually the most complex part to get right. We already defined a parser for
multiplication expressions in the previous chapter, however, this version had a
significant shortcoming (e.g. we couldn't parse expressions using multiple `"*"`
operators), and it expected simple integers as arguments.

The implementation for spreadsheet expression has to improve both of those
aspects: we need to be able to calculate not just with integer values, but also
with the values of references, function calls, and even whole subexpressions
wrapped in parentheses. And of course, we want to be able to use any arithmetic
operator as often as we want.

As a first step, we'll define a parser for multiplication (or division)
expressions that still only operates on integers, but which can handle multiple
multiplication operators. For this, we first define a `multiplier` parser, which
parses a `"*"` or `"/"` symbol followed by an
integer:

``` swift-example
let multiplier = curry({ ($0, $1) }) <^> (string("*") <|> string("/")) <*> intParser
```

The result of this parser is a tuple containing the operator and the integer.
Now we can define a parser that can parse inputs containing zero or more of
those multipliers:

``` swift-example
... <^> intParser <*> multiplier.many
```

The challenge is to write a function that combines the results of the two
parsers on the right-hand side. We know the types of arguments this function has
to accept, which are an `Expression` (from the `intParser`), and an array of
`(String, Expression)` tuples from the `multiplier.many` parser:

*/

func combineOperands(first: Expression, _ rest: [(String, Expression)])
    -> Expression {
    return rest.reduce(first) { result, pair in
        return Expression.infix(result, pair.0, pair.1)
    }
}

/*:
This function uses `reduce` to combine the first expression with all the
following `(operator, expression)` pairs by returning `.infix` expressions. If
you're not familiar with `reduce`, please see the Map, Filter, and Reduce
chapter for more details.

With these pieces in place, we can write our preliminary `productParser`, like
this:

``` swift-example
extension Expression {
    static var productParser: Parser<Expression> {
        let multiplier = curry({ ($0, $1) }) <^> (string("*") <|> string("/")) <*> intParser
        return curry(combineOperands) <^> intParser <*> multiplier.many
    }
}
```

Now we just have to remedy the issue of being restricted to multiplying only
integers with each other. For this we introduce a `primitiveParser`, which
parses anything that can be an operand for an arithmetic operation:

``` swift-example
extension Expression {
    static var primitiveParser: Parser<Expression> {
        return intParser <|> referenceParser <|> functionParser <|>
            lazy(parser).parenthesized
    }
}
```

`primitiveParser` uses the choice operator, `<|>`, to define that a primitive is
an integer, or a reference, or a function call, or a parenthesized
subexpression. The important part here is the use of the `lazy` helper. We have
to make sure that `parser`, which is the parser for any expression, only gets
evaluated if necessary. Otherwise, we get stuck in an endless loop. To achieve
this, `lazy` wraps its argument in a function using `@autoclosure`:

*/

func lazy<A>(_ parser: @autoclosure @escaping () -> Parser<A>) -> Parser<A> {
    return Parser<A> { parser().parse($0) }
}

/*:
We can now write the `productParser` using `primitiveParser` instead of
`intParser`:

``` swift-example
extension Expression {
    static var productParser: Parser<Expression> {
        let multiplier = curry({ ($0, $1) }) <^> (string("*") <|> string("/")) <*>
            primitiveParser
        return curry(combineOperands) <^> primitiveParser <*> multiplier.many
    }
}
```

Lastly, we define a `sumParser` analogous to `productParser`. The complete code
for arithmetic expressions then becomes the following:

*/

extension Expression {
    static var primitiveParser: Parser<Expression> {
        return intParser <|> referenceParser <|> functionParser <|>
            lazy(parser).parenthesized
    }
    
    static var productParser: Parser<Expression> {
        let multiplier = curry({ ($0, $1) }) <^> (string("*") <|> string("/")) <*>
            primitiveParser
        return curry(combineOperands) <^> primitiveParser <*> multiplier.many
    }
    
    static var sumParser: Parser<Expression> {
        let summand = curry({ ($0, $1) }) <^> (string("+") <|> string("-")) <*>
            productParser
        return curry(combineOperands) <^> productParser <*> summand.many
    }
    
    static var parser = sumParser
}

/*:
`Expression.parser` now can parse everything we need for the scope of this
spreadsheet app. For example:

*/

print(Expression.parser.run("2+4*SUM(A1:A2)")!.0)

/*:
Next, we can look at how to evaluate these expression trees into actual results,
which we can show to the user.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
