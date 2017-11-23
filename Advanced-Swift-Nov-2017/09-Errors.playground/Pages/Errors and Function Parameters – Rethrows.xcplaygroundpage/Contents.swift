/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Rethrows

Fortunately, there's a better way. By marking `all` as `rethrows`, we can write
both variants in one go. Annotating a function with `rethrows` tells the
compiler that this function will only throw an error when its function parameter
throws an error. This allows the compiler to waive the requirement that `all`
must be called with `try` when the caller passes in a non-throwing `check`
function:

*/

extension Sequence {
    func all(matching predicate: (Element) throws -> Bool) rethrows
        -> Bool {
        for element in self {
            guard try predicate(element) else { return false }
        }
        return true
    }
}

/*:
The implementation of `checkAllFiles` is now very similar to `checkPrimes`, but
because the call to `all` can now throw an error, we need to insert an
additional `try`:

*/

// --- (Hidden code block) ---
struct CheckFileError: Error {}

func checkFile(filename: String) throws -> Bool

{
    switch filename {
    case "fail.txt": throw CheckFileError()
    case "invalid.txt": return false
    default: return true
    }
}
// ---------------------------
func checkAllFiles(filenames: [String]) throws -> Bool {
    return try filenames.all(matching: checkFile)
}

/*:
Almost all sequence and collection functions in the standard library that take a
function argument are annotated with `rethrows`. For example, the `map` function
is only throwing if the transformation function is a throwing function itself.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
