/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Chaining Errors

Chaining multiple calls to functions that can throw errors becomes trivial with
Swift's built-in error handling — there's no need for nested `if` statements or
similar constructs; we simply place these calls into a single `do`/`catch` block
(or wrap them in a throwing function). The first error that occurs breaks the
chain and switches control to the `catch` block (or propagates the error to the
caller):

*/

// --- (Hidden code block) ---
extension Sequence {
    func all(matching predicate: (Element) throws -> Bool) rethrows
        -> Bool {
        for element in self {
            guard try predicate(element) else { return false }
        }
        return true
    }
}

struct CheckFileError: Error {}

func checkFile(filename: String) throws -> Bool

{
    switch filename {
    case "fail.txt": throw CheckFileError()
    case "invalid.txt": return false
    default: return true
    }
}

enum FileError: Error {
    case fileDoesNotExist
    case noPermission
}

func contents(ofFile filename: String) throws -> String

{
    switch filename {
    case "notfound.txt": throw FileError.fileDoesNotExist
    case "nopermission.txt": throw FileError.noPermission
    case "Pidfile": return "11111" // Used below in the Chaining Errors section
    default: return "This is a dummy return value. Pass \"notfound.txt\" or \"nopermission.txt\" as the filename to have this function throw an error."
    }
}

extension Optional {
    /// Unwraps `self` if it is non-`nil`.
    /// Throws the given error if `self` is `nil`.
    func or(error: Error) throws -> Wrapped {
        switch self {
            case let x?: return x
            case nil: throw error
        }
    }
}

enum ReadIntError: Error {
    case couldNotRead
}
// ---------------------------
func checkFilesAndFetchProcessID(filenames: [String]) -> Int {
    do {
        try filenames.all(matching: checkFile)
        let pidString = try contents(ofFile: "Pidfile")
        return try Int(pidString).or(error: ReadIntError.couldNotRead)
    } catch {
        return 42 // Default value
    }
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
