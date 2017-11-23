/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Implementing Copy-On-Write

As an example of a custom type with copy-on-write behavior, let's recreate the
`Data` struct from Foundation and use the `NSMutableData` class as our internal
reference type. `Data` has value semantics, and it behaves just like `Array`:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
var input: [UInt8] = [0x0b,0xad,0xf0,0x0d]
var other: [UInt8] = [0x0d]
var d = Data(bytes: input)
var e = d
d.append(contentsOf: other)
d
e

/*:
As we can see above, `d` and `e` are independent: adding a byte to `d` doesn't
change the value of `e`.

Writing the same example using `NSMutableData`, we can see that types with
reference semantics behave differently:

*/

var f = NSMutableData(bytes: &input, length: input.count)
var g = f
f.append(&other, length: other.count)
f
g

/*:
Both `f` and `g` refer to the same object (in other words: they point to the
same piece of memory), so changing one also changes the other. We can even
verify that they refer to the same object by using the `===` operator:

*/

f === g


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
