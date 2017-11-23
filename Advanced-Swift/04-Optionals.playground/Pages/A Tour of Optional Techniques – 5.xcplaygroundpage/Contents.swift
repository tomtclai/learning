/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
However, the two previous examples are pretty ugly. Really, what's needed is
some kind of `if not let` — which is exactly what `guard let` does:

*/

func doStuff(withArray a: [Int]) {
    guard let firstElement = a.first else {
        return
    }
    // firstElement is unwrapped here
}

/*:
And the second example becomes much clearer:

*/

extension String {
    var fileExtension: String? {
        guard let period = index(of: ".") else {
            return nil
        }
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
}

/*:
Anything can go in the `else` clause here, including multiple statements just
like an `if ... else`. The only requirement is that the `else` block must leave
the current scope. That might mean `return`, or it might mean calling
`fatalError` (or any other function that returns `Never`). If the `guard` were
in a loop, `break` or `continue` would also be allowed.

> A function that has the return type `Never` signals to the compiler that it'll
> never return. There are two common types of functions that do this: those that
> abort the program, such as `fatalError`; and those that run for the entire
> lifetime of the program, like `dispatchMain`. The compiler uses this
> information for its control flow diagnostics. For example, the `else` branch
> of a `guard` statement must either exit the current scope or call one of these
> never-returning functions.
> 
> `Never` is what's called an *uninhabited type*. It's a type that has no valid
> values and thus can't be constructed. Its only purpose is its signaling role
> for the compiler. A function declared to return an uninhabited type can never
> return normally. In Swift, an uninhabited type is implemented as an `enum`
> that has no cases:
> 
> ``` swift-example
> public enum Never { }
> ```
> 
> You won't usually need to define your own never-returning functions unless you
> write a wrapper for `fatalError` or `preconditionFailure`. One interesting use
> case is while you're writing new code: say you're working on a complex
> `switch` statement, gradually filling in all the cases, and the compiler is
> bombarding you with error messages for empty case labels or missing return
> values, while all you'd like to do is concentrate on the one case you're
> working on. In this situation, a few carefully placed calls to `fatalError()`
> can do wonders to silence the compiler. Consider writing a function called
> `unimplemented()` in order to better communicate the temporary nature of these
> calls:
> 
> ``` swift
> func unimplemented() -> Never {
>     fatalError("This code path is not implemented yet.")
> }
> ```
> 
> Swift meticulously distinguishes between different kinds of "nothingness." In
> addition to `nil` and `Never`, there's also `Void`, which is just another way
> of writing an empty tuple:
> 
> ``` swift-example
> public typealias Void = ()
> ```
> 
> The most common use of `Void` or `()` is in the types of functions that don't
> return anything, but it has other applications too. For example, consider a
> reactive programming framework that models event streams with an
> `Observable<T>` type, where `T` describes the payload type of the emitted
> event. A text field object might provide an `Observable<String>` that fires an
> event every time the user edits the text. Similarly, a button object sends an
> event when the user taps the button, but it has no additional payload to send
> — its event stream should have the type `Observable<()>`.
> 
> As [David Smith put
> it](https://twitter.com/Catfish_Man/status/825080948555292672), Swift makes a
> careful distinction between the "absence of a thing" (`nil`), the "presence of
> nothing" (`Void`), and a "thing which cannot be" (`Never`).

Of course, `guard` isn't limited to binding. `guard` can take any condition you
might find in a regular `if` statement, so the empty array example could be
rewritten with it:

*/

func doStuff2(withArray a: [Int]) {
    guard !a.isEmpty else { return }
    // Now use a[0] or a.first! safely
}

/*:
Unlike the optional binding case, this `guard` isn't a big win — in fact, it's
slightly more verbose than the original return. But it's still worth considering
doing this with any early exit situation. For one, sometimes (though not in this
case) the inversion of the boolean condition can make things clearer.
Additionally, `guard` is a clear signal when reading the code; it says: "We only
continue if the following condition holds." Finally, the Swift compiler will
check that you're definitely exiting the current scope and raise a compilation
error if you don't. For this reason, we'd suggest using `guard` even when an
`if` would do.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
