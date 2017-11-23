/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
If we naively wrap `NSMutableData` in a struct, we don't get value semantics
automatically. For example, we could try the following:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
struct MyData {
    var _data: NSMutableData
    init(_ data: NSData) {
        _data = data.mutableCopy() as! NSMutableData
    }
}

// --- (Hidden code block) ---
extension MyData: CustomDebugStringConvertible {
    var debugDescription: String {
        return _data.debugDescription
    }
}
// ---------------------------
/*:
If we copy a struct variable, a shallow copy is made. This means the reference
to the `NSMutableData` object, and not the object itself, will get copied:

*/

let theData = NSData(base64Encoded: "wAEP/w==")!
let x = MyData(theData)
let y = x
x._data === y._data

/*:
We can add an `append` function, which delegates to the underlying `_data`
property, and again, we can see that we've created a struct without value
semantics:

*/

extension MyData {
    func append(_ byte: UInt8) {
        var mutableByte = byte
        _data.append(&mutableByte, length: 1)
    }
}

x.append(0x55)
y

/*:
Because we're only modifying the object `_data` is referring to, we don't even
have to mark `append` as `mutating`. After all, the reference stays constant,
and the struct too. Therefore, we were able to declare `x` and `y` using `let`,
even though they were mutable.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
