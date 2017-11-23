/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The `Result` Type

Before we look at Swift's built-in error handling in more detail, let's discuss
the `Result` type, which will help clarify how Swift's error handling works when
you take away the syntactic sugar. A `Result` type is very similar to an
optional. Recall that an optional is just an enumeration with two cases: a
`.none` or `nil` case, with no associated value; and a `.some` case, which has
an associated value. The `Result` type is an `enum` with two cases as well: a
failure case, which carries an associated error value; and a success case, also
with an associated value. Just like optionals, `Result` has one generic
parameter:

*/

enum Result<A> {
    case failure(Error)
    case success(A)
}

/*:
The failure case constrains its associated value to the `Error` protocol. We'll
come back to this shortly.

Let's suppose we're writing a function to read a file from disk. As a first try,
we could define the interface using an optional. Because reading a file might
fail, we want to be able to return `nil`:

*/

func contentsOrNil(ofFile filename: String) -> String?

// --- (Hidden code block) ---
{
    switch filename {
    case "notfound.txt": return nil
    case "nopermission.txt": return nil
    default: return "This is a dummy return value.\n" +
                    "Pass \"notfound.txt\" or \"nopermission.txt\"" +
                    "as the filename to have this function return nil."
    }
}
// ---------------------------

/*:
The interface above is very simple, but it doesn't tell us anything about why
reading the file failed. Does the file not exist? Or do we not have the right
permissions? This is another example where the failure reason matters. Let's
define an `enum` for the possible error cases:

*/

enum FileError: Error {
    case fileDoesNotExist
    case noPermission
}

/*:
Now we can change the type of our function to return either an error or a valid
result:

*/

func contents(ofFile filename: String) -> Result<String>

// --- (Hidden code block) ---
{
    switch filename {
    case "notfound.txt": return .failure(FileError.fileDoesNotExist)
    case "nopermission.txt": return .failure(FileError.noPermission)
    default: return .success("This is a dummy return value. Pass \"notfound.txt\" or \"nopermission.txt\" as the filename to have this function return an error.")
    }
}
// ---------------------------

/*:
The caller of the function can look at the result cases and react differently
based on the error. In the code below, we try to read the file, and in case
reading succeeds, we print the contents. If the file doesn't exist, we print
that, and we handle any remaining errors in a different way:

*/

let result = contents(ofFile: "input.txt")
switch result {
case let .success(contents):
    print(contents)
case let .failure(error):
    if let fileError = error as? FileError,
        fileError == .fileDoesNotExist
    {
        print("File not found")
    } else {
        // Handle error
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
