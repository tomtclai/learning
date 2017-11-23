/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Errors and Function Parameters

In the following example, we'll write a function that checks a list of files for
validity. The `checkFile` function can return three possible values. If it
returns `true`, the file is valid. If it returns `false`, the file is invalid.
If it throws an error, something went wrong when checking the file:

*/

// --- (Hidden code block) ---
struct CheckFileError: Error {}
// ---------------------------
func checkFile(filename: String) throws -> Bool

// --- (Hidden code block) ---
{
    switch filename {
    case "fail.txt": throw CheckFileError()
    case "invalid.txt": return false
    default: return true
    }
}
// ---------------------------
/*:
As a first step, we can write a simple function that loops over a list of
filenames and makes sure that `checkFile` returns `true` for every file. If
`checkFile` returns `false`, we want to make sure to exit early, avoiding any
unnecessary work. Since we don't catch any errors that `checkFile` throws, the
first error would propagate to the caller and thus also exit early:

*/

func checkAllFiles(filenames: [String]) throws -> Bool {
    for filename in filenames {
        guard try checkFile(filename: filename) else { return false }
    }
    return true
}

// --- (Hidden code block) ---
let filenames = ["one.txt", "two.txt"]
// ---------------------------
/*:
Checking whether all the elements in an array conform to a certain condition is
something that might happen more often in our app. For example, consider the
function `checkPrimes`, which checks whether all numbers in a given list are
prime numbers. It works in exactly the same way as `checkAllFiles`. It loops
over the array and checks all elements for a condition (`isPrime`), exiting
early when one of the numbers doesn't satisfy the condition:

*/

// --- (Hidden code block) ---
extension Int {
    var isPrime: Bool {
        guard self >= 2 else { return false }
        guard self >= 4 else { return true }
        guard self % 2 != 0 else { return false }
        guard self % 3 != 0 else { return false }
        
        var i = 5
        while i * i <= self {
            if (self % i == 0) || (self % (i + 2) == 0) {
                return false
            }
            i += 6
        }
        return true
    }
}
// ---------------------------
func checkPrimes(_ numbers: [Int]) -> Bool {
    for number in numbers {
        guard number.isPrime else { return false }
    }
    return true
}

checkPrimes([2,3,7,17])
checkPrimes([2,3,4,5])


/*:
Both functions mix the process of iterating over a sequence (the `for` loops)
with the actual logic that decides if an element meets the condition. This is a
good opportunity to create an abstraction for this pattern, similar to `map` or
`filter`. To do that, we can add a function named `all(matching:)` to
`Sequence`. Like `filter`, `all` takes a function that performs the condition
check as an argument. The difference to `filter` is the return type. `all`
returns `true` if all elements in the sequence satisfy the condition, whereas
`filter` returns the elements themselves:

*/

extension Sequence {
    /// Returns `true` iff all elements satisfy the predicate
    func all(matching predicate: (Element) -> Bool) -> Bool {
        for element in self {
            guard predicate(element) else { return false }
        }
        return true
    }
}

/*:
This allows us to rewrite `checkPrimes` in a single line, which makes it easier
to read once you know what `all` does, and it helps us focus on the essential
parts:

*/

func checkPrimes2(_ numbers: [Int]) -> Bool {
    return numbers.all { $0.isPrime }
}


/*:
However, we can't rewrite `checkAllFiles` to use `all`, because `checkFile` is
marked as `throws`. We could easily rewrite `all` to accept a throwing function,
but then we'd have to change `checkPrimes` too, either by annotating
`checkPrimes` as throwing, by using `try!`, or by wrapping the call to `all` in
a `do`/`catch` block. Alternatively, we could define two versions of `all`: one
that `throws` and one that doesn't. Except for the `try` call, their
implementations would be identical.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
