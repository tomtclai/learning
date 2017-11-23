/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Case Study: Parser Combinators 

Parsers are very useful tools for transforming a sequence of tokens (usually
characters) into structured data. Sometimes you can get away with using a
regular expression to parse a simple input string, but regular expressions are
limited in what they can do, and they become hard to understand very quickly.
Once you understand how to write a parser (or how to use an existing parser
library), it's a very powerful tool to have in your toolbox.

There are multiple approaches you can take to create a parser: first, you could
hand code the parser, maybe using something like Foundation's `Scanner` class to
make your life a bit easier. Second, you could generate a parser with an
external tool, such as [Bison](http://en.wikipedia.org/wiki/GNU_bison) or
[YACC](http://en.wikipedia.org/wiki/Yacc). Third, you could use a [parser
combinator](http://en.wikipedia.org/wiki/Parser_combinators) library, which
strikes a balance between the other two approaches in many ways.

Parser combinators are a functional approach to parsing. Instead of managing the
mutable state of a parser (e.g. the character we're currently at), parser
combinators use pure functions to avoid mutable state. In this chapter, we'll
look at how parser combinators work and build some core elements of a parser
combinator library ourselves. As an example, we'll try to parse simple
arithmetic expressions, like `1+2*3`.

The goal isn't to write a comprehensive combinator library, but rather to learn
how parser combinator libraries work under the hood, so that you get comfortable
using them. In most cases, you'll be better off using an existing library rather
than rolling your own.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
