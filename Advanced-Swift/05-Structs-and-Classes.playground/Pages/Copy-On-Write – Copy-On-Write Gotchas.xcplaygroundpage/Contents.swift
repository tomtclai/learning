/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Copy-On-Write Gotchas

Unfortunately, it's all too easy to introduce accidental copies. To see this
behavior, we'll create a very simple struct that contains a reference to an
empty Swift class. The struct has a single `mutating` method, `change`, which
checks whether or not the reference should be copied. Rather than copying, it
just returns a string indicating whether or not a copy would have occurred:

*/

final class Empty { }

struct COWStruct {
    var ref = Empty()

    mutating func change() -> String {
        if isKnownUniquelyReferenced(&ref) {
            return "No copy"
        } else {
            return "Copy"
        }
        // Perform actual change
    }
}

/*:
For example, if we create a variable and immediately mutate it, the variable
isn't shared. Therefore, the reference is unique and no copy is necessary:

*/

var s = COWStruct()
s.change()

/*:
As we'd expect, when we create a second variable, the reference is shared, and a
copy is necessary the moment we call `change`:

*/

var original = COWStruct()
var copy = original
original.change()

/*:
When we put one of our structs in an array, we can mutate the array element
directly, and no copy is necessary. This is because accessing an element via
array subscripting has direct access to the memory location:

*/

var array = [COWStruct()]
array[0].change()

/*:
If we go through an intermediate variable, though, a copy is made:

*/

var otherArray = [COWStruct()]
var x = array[0]
x.change()

/*:
Somewhat surprisingly, all other types — including dictionaries, sets, and your
own types — behave very differently. For example, the dictionary subscript looks
up the value in the dictionary and then returns the value. Because we're dealing
with value semantics, a copy is returned. Therefore, calling `change()` on that
value will make a copy, as the `COWStruct` is no longer uniquely referenced:

*/

var dict = ["key": COWStruct()]
dict["key"]?.change()

/*:
If you want to avoid making copies when you put a copy-on-write struct inside a
dictionary, you can wrap the value inside a class box, effectively giving the
value reference semantics.

When you're working with your own structs, you need to keep this in mind. For
example, if we create a container that simply stores a value, we can either
modify the storage property directly, or we can access it indirectly, such as
through a subscript. When we directly access it, we get the copy-on-write
optimization, but when we access it indirectly through a subscript, a copy is
made:

*/

struct ContainerStruct<A> {
    var storage: A
    subscript(s: String) -> A {
        get { return storage }
        set { storage = newValue }
    }
}

var d = ContainerStruct(storage: COWStruct())
d.storage.change()
d["test"].change()

/*:
The implementation of the `Array` subscript uses a special technique to make
copy-on-write work, but unfortunately, no other types currently use this. The
Swift team mentioned that they [hope to generalize it to
dictionaries](https://twitter.com/slava_pestov/status/778488750514970624).

The way `Array` implements the subscript is by using *addressors*. An addressor
allows for direct access to memory. Instead of returning the element, an array
subscript returns an addressor for the element. This way, the element memory can
be modified in place, and unnecessary copies can be eliminated. You can use
addressors in your own code, but as they're not officially documented, they're
bound to change. For more information, see the
[Accessors.rst](https://github.com/apple/swift/blob/master/docs/proposals/Accessors.rst)
document in the Swift repository.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
