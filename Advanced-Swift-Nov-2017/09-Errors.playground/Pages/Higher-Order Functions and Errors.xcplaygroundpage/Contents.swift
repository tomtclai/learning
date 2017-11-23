/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Higher-Order Functions and Errors

One domain where Swift's error handling unfortunately does *not* work very well
is asynchronous APIs that need to pass errors to the caller in callback
functions. Let's look at a function that asynchronously computes a large number
and calls back our code when the computation has finished:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
func compute(callback: (Int) -> ())

// --- (Hidden code block) ---
{
    // Dummy implementation: generate a random number
    let random = Int(arc4random())
    callback(random)
}
// ---------------------------
/*:
We can call it by providing a callback function. The callback receives the
result as the only parameter:

*/

compute { result in
    print(result)
}

/*:
If the computation can fail, we could specify that the callback receives an
optional integer, which would be `nil` in case of a failure:

*/

func computeOptional(callback: (Int?) -> ())

// --- (Hidden code block) ---
{
    // Dummy implementation: generate a random number, sometimes return nil
    let random = Int(arc4random())
    if random % 3 == 0 { callback(nil) }
    else { callback(random) }
}
// ---------------------------
/*:
Now, in our callback, we must check whether the optional is non-`nil`, e.g. by
using the `??` operator:

*/

computeOptional { result in
    print(result ?? -1)
}

/*:
But what if we want to report specific errors to the callback, rather than just
an optional? This function signature seems like a natural solution:

``` swift-example
func computeThrows(callback: (Int) throws -> ())
```

But this type has a totally different meaning. Instead of saying that the
computation might fail, it expresses that the callback itself could throw an
error. This highlights the key difference we mentioned earlier: optionals and
`Result` work on types, whereas `throws` works only on function types.
Annotating a function with `throws` means that the *function* might fail.

It becomes a bit clearer when we try to rewrite the wrong attempt from above
using `Result`:

``` swift-example
func computeResult(callback: (Int) -> Result<()>)
```

This isn't correct either. We need to wrap the `Int` argument in a `Result`, not
the callback's return type. Finally, this is the correct solution:

*/

// --- (Hidden code block) ---
enum Result<A> {
    case failure(Error)
    case success(A)
}

struct ComputeError: Error {}
// ---------------------------
func computeResult(callback: (Result<Int>) -> ())

// --- (Hidden code block) ---
{
    // Dummy implementation: generate a random number, sometimes return nil
    let random = Int(arc4random())
    if random % 3 == 0 { callback(.failure(ComputeError())) }
    else { callback(.success(random)) }
}
// ---------------------------
/*:
Unfortunately, there's currently no clear way to write the variant above with
`throws`. The best we can do is wrap the `Int` inside another throwing function.
This makes the type more complicated:

``` swift-example
func compute(callback: (() throws -> Int) -> ())
```

And using this variant becomes more difficult for the caller too. In order to
get the integer out, the callback now has to call the throwing function. This is
where the caller must perform the error checking:

``` swift-example
compute { (resultFunc: () throws -> Int) in
    do {
        let result = try resultFunc()
        print(result)
    } catch {
        print("An error occurred: \(error)")
    }
}
```

This works, but it's definitely not idiomatic Swift; `Result` is the way to go
for asynchronous error handling. It's unfortunate that this creates an impedance
mismatch with synchronous functions that use `throws`. The Swift team has
expressed interest in extending the `throws` model to other scenarios, but this
will likely be part of the much greater task of adding native concurrency
features to the language, and that won't happen until Swift 5 at the earliest.

Until then, we're stuck with using our own custom `Result` types. Apple did
consider adding a `Result` type to the standard library, but ultimately [decided
against
it](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20151207/001433.html)
on the grounds that it wasn't independently valuable enough outside the error
handling domain and that the team didn't want to endorse it as an alternative to
`throws`-style error handling. Luckily, using `Result` for asynchronous APIs is
a pretty well-established practice among the Swift developer community, so you
shouldn't hesitate to use it in your APIs when the native error handling isn't
appropriate. It certainly beats the Objective-C style of having completion
handlers with two nullable arguments (a result object and an error object).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
