/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Copy-On-Write (The Efficient Way)

To provide efficient copy-on-write behavior, we need to know whether an object
(e.g. the `NSMutableData` instance) is uniquely referenced. If it's a unique
reference, we can modify the object in place. Otherwise, we create a copy of the
object before modifying it. In Swift, we can use the `isKnownUniquelyReferenced`
function to find out if a reference has only one owner. If you pass in an
instance of a Swift class to this function, and if no one else has a strong
reference to the object, the function returns `true`. If there are other strong
references, it returns `false`. Unfortunately, it also returns `false` for
Objective-C classes. Therefore, it doesn't make sense to use the function with
`NSMutableData` directly. However, we can write a simple Swift class that wraps
any Objective-C object (or any other value) into a Swift object:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
final class Box<A> {
    var unbox: A
    init(_ value: A) { self.unbox = value }
}

var x = Box(NSMutableData())
isKnownUniquelyReferenced(&x)

/*:
If we have multiple references to the same object, the function will return
`false`:

*/

var y = x
isKnownUniquelyReferenced(&x)

/*:
This also works when the references are inside a struct and not just global
variables. Using this knowledge, we can now write a variant of `MyData`, which
checks whether `_data` is uniquely referenced before mutating it. Let's also add
a `print` statement to quickly see during debugging how often we make a copy:

*/

struct MyData {
    private var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)
                print("Making a copy")
            }
            return _data.unbox
        }
    }
    init() {
        _data = Box(NSMutableData())
    }
    init(_ data: NSData) {
        _data = Box(data.mutableCopy() as! NSMutableData)
    }
}

// --- (Hidden code block) ---
extension MyData: CustomDebugStringConvertible {
    var debugDescription: String {
        return _data.unbox.debugDescription
    }
}
// ---------------------------
/*:
In the `_dataForWriting` getter, we now need to unbox the `_data` property to
access the `NSMutableData` instance. The `append` method can remain unchanged
because the logic for when to make a copy is fully contained inside
`_dataForWriting`:

*/

extension MyData {
    mutating func append(_ byte: UInt8) {
        var mutableByte = byte
        _dataForWriting.append(&mutableByte, length: 1)
    }
}

/*:
To test out our code, let's write the loop again:

*/

var bytes = MyData()
var copy = bytes
for byte in 0..<5 as CountableRange<UInt8> {
    print("Appending 0x\(String(byte, radix: 16))")
    bytes.append(byte)
}
bytes
copy

/*:
If we run the code above, we can see that our debug statement only gets printed
once: when we call `append` for the first time. In subsequent iterations, the
uniqueness is detected and no copy gets made.

This technique allows you to create custom structs that retain value semantics
while still being just as efficient as you would be working with objects or
pointers. As a user of the struct, you don't need to worry about copying these
structs manually — the implementation will take care of it for you. Because
copy-on-write is combined with optimizations done by the compiler, many
unnecessary copy operations can be removed.

When you define your own structs and classes, it's important to pay attention to
the expected copying and mutability behavior. Structs are expected to have value
semantics. When using a class inside a struct, we need to make sure that it's
truly immutable. If this isn't possible, we either need to take extra steps
(like above), or just use a class, in which case consumers of our data don't
expect it to behave like a value.

Most data structures in the Swift standard library are value types using
copy-on-write. For example, arrays, dictionaries, sets, and strings are all
structs. This makes it simpler to understand code that uses those types. When we
pass an array to a function, we know the function can't modify the original
array: it only works on a copy of the array. Also, the way arrays are
implemented, we know that no unnecessary copies will be made. Contrast this with
the Foundation data types, where it's best practice to always manually copy
types like `NSArray` and `NSString`. When working with Foundation data types,
it's easy to forget to manually copy the object and instead accidentally write
unsafe code.

Even when you could create a struct, there might still be very good reasons to
use a class. For example, you might want an immutable type that only has a
single instance, or maybe you're wrapping a reference type and don't want to
implement copy-on-write. Or, you might need to interface with Objective-C, in
which case, structs might not work either. By defining a restrictive interface
for your class, it's still very possible to make it immutable.

It might also be interesting to wrap existing types in enums, which are also
value types, just like structs. In the chapter on wrapping CommonMark, we'll
provide an enum-based interface to a reference type.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
