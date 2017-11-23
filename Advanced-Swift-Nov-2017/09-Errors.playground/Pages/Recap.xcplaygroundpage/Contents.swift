/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Recap

When Apple introduced its error handling model in Swift 2.0, a lot of people in
the community were skeptical. People were rolling their own `Result` types in
the Swift 1.x days, mostly with a typed error case. The fact that `throws` uses
untyped errors was seen as a needless deviation from the strict typing in other
parts of the language. Unsurprisingly, the Swift team had considered this very
carefully and intentionally went for untyped errors. We were skeptical too, but
in hindsight, we think the Swift team was proven correct, not least by the large
acceptance of the error handling model in the developer community.

There's a chance that strongly typed error handling will be added as an opt-in
feature in the future, along with better support for asynchronous errors and
passing errors around as values. As it stands now, error handling is a good
example of Swift being a pragmatic language that optimizes for the most common
use case first. Keeping the syntax familiar for developers who are used to
C-style languages is a more important goal than adhering to the "purer"
functional style based on `Result` and `flatMap`.

In the meantime, we now have many possible choices for handling the unexpected
in our code. When we can't possibly continue, we can use `fatalError` or an
assertion. When we're not interested in the kind of error, or if there's only
one kind of error, we can use optionals. When we need more than one kind of
error or want to provide additional information, we can use Swift's built-in
errors or write our own `Result` type. When we want to write functions that take
a function as a parameter, `rethrows` lets us write one variant for both
throwing and non-throwing function parameters. Finally, the `defer` statement is
very useful in combination with the built-in errors. `defer` statements provide
us with a single place to put our cleanup code, regardless of how a scope exits
normally or with an error.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
