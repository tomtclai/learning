/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Copy-On-Write (The Expensive Way)

To arrive at a working implementation, let's take the term *copy-on-write*
literally: every time we need to mutate `_data`, we'll make a copy of it first
and then mutate the copy. This approach won't be very efficient because we'll
make a ton of unnecessary copies, but it will achieve our goal of giving
`MyData` value semantics — other instances referencing the original `_data`
object won't be affected by the mutation.

Instead of mutating `_data` directly, we access it exclusively through a
computed property, `_dataForWriting`. It's the getter of this property that
copies the `NSMutableData` instance and returns the copy:

*/

// --- (Hidden code block) ---
import Foundation

// ---------------------------
struct MyData {
    fileprivate var _data: NSMutableData
    fileprivate var _dataForWriting: NSMutableData {
        mutating get {
            _data = _data.mutableCopy() as! NSMutableData
            return _data
        }
    }
    init() {
        _data = NSMutableData()
    }
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
Because `_dataForWriting` mutates the struct (it assigns a new value to the
`_data` property), the getter has to be marked as `mutating`. This means we can
only use it on variables declared with `var`.

We can use `_dataForWriting` in our `append` method, which now also needs to be
marked as `mutating`:

*/

extension MyData {
    mutating func append(_ byte: UInt8) {
        var mutableByte = byte
        _dataForWriting.append(&mutableByte, length: 1)
    }
}

/*:
Our struct now has value semantics. If we assign the value of `x` to the
variable `y`, both variables are still pointing to the same underlying
`NSMutableData` object. However, the moment we use `append` on either one of the
variables, a copy gets made:

*/

let theData = NSData(base64Encoded: "wAEP/w==")!
var x = MyData(theData)
let y = x
x._data === y._data
x.append(0x55)
y
x._data === y._data

/*:
This strategy works, but it's wasteful if we mutate the same variable multiple
times. Consider the following example:

*/

var buffer = MyData(NSData())
for byte in 0..<5 as CountableRange<UInt8> {
    buffer.append(byte)
}

/*:
Each time we call `append`, the underlying `_data` object gets copied. Because
`buffer` doesn't share its storage with other `MyData` instances, it'd have been
a lot more efficient (and just as safe) to mutate it in place.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
