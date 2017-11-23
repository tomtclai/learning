/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Throwing and Catching

Swift's built-in error handling is implemented almost like in the above example,
only with a different syntax. Instead of giving a function a `Result` return
type to indicate that it can fail, we mark it as `throws`. Note that `Result`
applies to types, whereas `throws` applies to functions (we'll come back to this
difference later in this chapter). For every throwing function, the compiler
will verify that the caller either catches the error or propagates it to its
caller. In the case of `contents(ofFile:)`, the function signature including
`throws` looks like this:

*/

// --- (Hidden code block) ---
enum FileError: Error {
    case fileDoesNotExist
    case noPermission
}
// ---------------------------
func contents(ofFile filename: String) throws -> String

// --- (Hidden code block) ---
{
    switch filename {
    case "notfound.txt": throw FileError.fileDoesNotExist
    case "nopermission.txt": throw FileError.noPermission
    case "Pidfile": return "11111" // Used below in the Chaining Errors section
    default: return "This is a dummy return value. Pass \"notfound.txt\" or \"nopermission.txt\" as the filename to have this function throw an error."
    }
}
// ---------------------------

/*:
From now on, our code won't compile unless we annotate every call to
`contents(ofFile:)` with `try`. The `try` keyword serves two purposes: first, it
signals to the compiler that we know we're calling a function that can throw an
error. Second, and more importantly, it immediately makes clear to readers of
the code which functions can throw.

Calling a throwing function also forces us to make a decision about how we want
to deal with possible errors. We can either handle an error by using
`do`/`catch`, or we can have it propagate up the call stack by marking the
calling function as `throws`. We can use pattern matching to catch specific
errors or catch all errors. In the example below, we explicitly catch a
`fileDoesNotExist` case and then handle all other errors in a catch-all case.
Within the catch-all case, the compiler automatically makes a variable, `error`,
available (much like the implicit `newValue` variable in a property's `willSet`
handler):

*/

do {
    let result = try contents(ofFile: "input.txt")
    print(result)
} catch FileError.fileDoesNotExist {
    print("File not found")
} catch {
    print(error)
    // Handle any other error
}

/*:
> The error handling syntax in Swift probably looks familiar to you. Many other
> languages use the same `try`, `catch`, and `throw` keywords for exception
> handling. Despite the resemblance, error handling in Swift doesn't incur the
> runtime cost that's often associated with exceptions. The compiler treats
> `throw` like a regular return, making both code paths very fast.

If we want to expose more information in our errors, we can use an enum with
associated values. For example, a file parser could choose to model the possible
errors like this:

*/

enum ParseError: Error {
    case wrongEncoding
    case warning(line: Int, message: String)
}

/*:
Note that we could've also used a struct or class instead; any type that
conforms to the `Error` protocol can be used as an error in a throwing function.
And because the `Error` protocol has no requirements, any type can choose to
conform to it without extra implementation work.

Now, if we want to parse a string, we can again use pattern matching to
distinguish between the cases. In the case of `.warning`, we can bind the line
number and warning message to a variable:

*/

// --- (Hidden code block) ---
func parse(text: String) throws -> [String] {
    switch text {
    case "encoding": throw ParseError.wrongEncoding
    case "warning": throw ParseError.warning(line: 1, message: "Expected file header")
    default: return [
      "This is a dummy return value. Pass \"encoding\" or \"warning\"" +
      "as the argument to have this function throw an error."]
    }
}
// ---------------------------
do {
    let result = try parse(text: "{ \"message\": \"We come in peace\" }")
    print(result)
} catch ParseError.wrongEncoding {
    print("Wrong encoding")
} catch let ParseError.warning(line, message) {
    print("Warning at line \(line): \(message)")
} catch {
}

/*:
Something about the above code doesn't feel quite right. Even if we're
absolutely sure that the only error that could happen is of type `ParseError`
(which we handled exhaustively), we still need to write a final `catch` case to
convince the compiler that we caught all possible errors. In a future Swift
version, the compiler might be able to check exhaustiveness within a module, but
across modules, this problem can't be solved. The reason is that Swift errors
are untyped: we can only mark a function as `throws`, but we can't specify
*which* errors it'll throw. This was a deliberate design decision — most of the
time, you only care about whether or not an error was present. If we needed to
specify the types of all errors, this could quickly get out of hand: it would
make functions' type signatures quite complicated, especially for functions that
call several other throwing functions and propagate their errors. Moreover,
adding a new error case would be a breaking change for all clients of the API.

That said, Swift might get typed errors someday; this topic is being actively
discussed on the mailing lists. If typed errors come to Swift, we expect them to
be an opt-in feature because untyped errors are still the better choice in many
situations. For example, frameworks like Cocoa [probably won't ever have typed
errors](https://lists.swift.org/pipermail/swift-evolution/Week-of-Mon-20170814/038928.html).

> Because errors are untyped, it's important to document the types of errors
> your functions can throw. Xcode supports a [`Throws`
> keyword](https://developer.apple.com/library/ios/documentation/Xcode/Reference/xcode_markup_formatting_ref/Throws.html#//apple_ref/doc/uid/TP40016497-CH26-SW1)
> in documentation markup for this purpose. Here's an example:
> 
> ``` swift
> /// Opens a text file and returns its contents.
> ///
> /// - Parameter filename: The name of the file to read.
> /// - Returns: The file contents, interpreted as UTF-8.
> /// - Throws: `FileError` if the file does not exist or
> ///           the process doesn't have read permissions.
> func contents(ofFile filename: String) throws -> String
> ```
> 
> The Quick Help popover that appears when you Option-click on the function name
> will now include an extra section for the thrown errors.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
