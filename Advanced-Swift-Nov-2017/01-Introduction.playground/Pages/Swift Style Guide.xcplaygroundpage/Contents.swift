/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Swift Style Guide

When writing this book, and when writing Swift code for our own projects, we try
to stick to the following rules:

  - For naming, clarity *at the point of use* is the most important
    consideration. Since APIs are used many more times than they're declared,
    their names should be optimized for how well they work at the call site.
    Familiarize yourself with the [Swift API Design
    Guidelines](https://swift.org/documentation/api-design-guidelines/) and try
    to adhere to them in your own code.

  - Clarity is often helped by conciseness, but brevity should never be a goal
    in and of itself.

  - Always add documentation comments to functions — *especially* generic ones.

  - Types start with `UpperCaseLetters`. Functions, variables, and enum cases
    start with `lowerCaseLetters`.

  - Use type inference. Explicit but obvious types get in the way of
    readability.

  - Don't use type inference in cases of ambiguity or when defining contracts
    (which is why, for example, `func`s have an explicit return type).

  - Default to structs unless you actually need a class-only feature or
    reference semantics.

  - Mark classes as `final` unless you've explicitly designed them to be
    inheritable. If you want to use inheritance internally but not allow
    subclassing for external clients, mark a class `public` but not `open`.

  - Use the trailing closure syntax, except when that closure is immediately
    followed by another opening brace.

  - Use `guard` to exit functions early.

  - Eschew force-unwraps and implicitly unwrapped optionals. They're
    occasionally useful, but needing them constantly is usually a sign something
    is wrong.

  - Don't repeat yourself. If you find you've written a very similar piece of
    code more than a couple of times, extract it into a function. Consider
    making that function a protocol extension.

  - Favor `map` and `filter`. But don't force it: use a `for` loop when it makes
    sense. The purpose of higher-order functions is to make code more readable.
    An obfuscated use of `reduce` when a simple `for` loop would be clearer
    defeats this purpose.

  - Favor immutable variables: default to `let` unless you know you need
    mutation. But use mutation when it makes the code clearer or more efficient.
    Again, don't force it: a `mutating` method on a struct is often more
    idiomatic and efficient than returning a brand new struct.

  - Swift generics tend to lead to very long function signatures. Unfortunately,
    we have yet to settle on a good way of breaking up long function
    declarations into multiple lines. We'll try to be consistent in how we do
    this in sample code.

  - Leave off `self.` when you don't need it. In closure expressions, it's a
    clear signal that `self` is being captured by the closure.

  - Write extensions on existing types and protocols, instead of free functions,
    whenever you can. This helps readability and discoverability.

One final note about our code samples throughout the book: to save space and
focus on the essentials, we usually omit import statements that would be
required to make the code compile. If you try out the code yourself and the
compiler tells you it doesn't recognize a particular symbol, try adding an
`import Foundation` or `import UIKit` statement.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
