/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
Classes are reference types. If you create an instance of a class and assign it
to a new variable, both variables point to the same object:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let mutableArray: NSMutableArray = [1, 2, 3]
let otherArray = mutableArray
mutableArray.add(4)
otherArray

/*:
Because both variables refer to the same object, they now both refer to the
array `[1, 2, 3, 4]`, since changing the value of one variable also changes the
value of the other variable. This is a very powerful thing, but it's also a
great source of bugs. Calling a method might change something you didn't expect
to change, and your invariant won't hold anymore.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
