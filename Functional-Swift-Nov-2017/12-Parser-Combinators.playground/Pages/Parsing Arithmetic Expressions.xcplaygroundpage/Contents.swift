/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Parsing Arithmetic Expressions

*/

// --- (Hidden code block) ---
import Foundation

func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { a in { b in f(a, b) } }
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
}

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

func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    return lhs.followed(by: rhs).map { f, x in f(x) }
}

precedencegroup SequencePrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <*>: SequencePrecedence

infix operator *>: SequencePrecedence
func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    return curry({ _, y in y }) <^> lhs <*> rhs
}

infix operator <^>: SequencePrecedence
func <^><A, B>(lhs: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(lhs)
}

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

extension Parser {
    var many1: Parser<[Result]> {
        return curry({ [$0] + $1 }) <^> self <*> self.many
    }
}

extension Parser {
    var optional: Parser<Result?> {
        return Parser<Result?> { input in
            guard let (result, remainder) = self.parse(input) else { return (nil, input) }
            return (result, remainder)
        }
    }
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

let integer = digit.many.map { Int(String($0))! }
// ---------------------------
/*:
Before we start using our parser combinators to write the parser for arithmetic
expressions, it's helpful to think about the grammar of these expressions for a
moment. It's especially important to get the precedence rules right: for
example, multiplication takes precedence over addition.

The grammar could look something like this:

    expression = minus
    minus = addition ("-" addition)?
    addition = division ("+" division)?
    division = multiplication ("/" multiplication)?
    multiplication = integer ("*" integer)?

The precedence rules are embedded in this grammar. For example, an addition
expression is defined as two division expressions with a `"+"` symbol in
between. This results in the multiplication expressions being evaluated first.

You might have noticed this grammar is far from complete. Besides obvious
missing features like parentheses, there's also still an even graver issue: for
example, currently, an addition expression can only contain one `"+"` operator,
whereas we'd want to be able to sum up multiple summands. The same goes for all
other expressions defined in this grammar. This isn't too difficult to
implement, but it makes the whole example more complex. Therefore, we're going
to implement the parser with those limitations.

The nice thing about using a parser combinator library is that the code is very
similar to the grammar we've written down above. We'll just start from the
bottom up and translate the grammar into combinator code:

*/

let multiplication = curry({ $0 * ($1 ?? 1) }) <^>
    integer <*> (character { $0 == "*" } *> integer).optional

/*:
The part in front of the `<^>` operator is the function that evaluates the
result. In this case, it takes two parameters. The second parameter is optional,
since the second part of the multiplication expression is marked as optional in
our grammar. Behind the `<^>` operator, we simply write down the parsers for the
different parts in the expression: an integer parser followed by a character
parser for the `"*"` symbol, followed by another integer parser. Since we don't
need the result of the character parser, we use the `*>` sequence operator to
throw away the result on the left-hand side. Lastly, we use the `optional`
combinator to mark the symbol and the second integer parser as optional.

The parsers for the other expressions in our grammar are defined in the same
way:

*/

let division = curry({ $0 / ($1 ?? 1) }) <^>
    multiplication <*> (character { $0 == "/" } *> multiplication).optional
let addition = curry({ $0 + ($1 ?? 0) }) <^>
    division <*> (character { $0 == "+" } *> division).optional
let minus = curry({ $0 - ($1 ?? 0) }) <^>
    addition <*> (character { $0 == "-" } *> addition).optional
let expression = minus

/*:
Since all these parsers have the same structure, we could refactor this code to
contain less repetitive code, for example by writing a function that generates
the parser for a given arithmetic operator. However, for this simple example,
we'll stick with what we have in order to avoid another layer of abstraction.

The last thing to do is to test the `expression` parser:

*/

expression.run("2*3+4*6/2-10")

/*:
In the next chapter, we'll build on top of this expression parser to implement a
simple spreadsheet application.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
