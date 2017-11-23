/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Protocol Internals 

As we mentioned earlier, when we create a variable that has a protocol type,
it's wrapped in a box called an existential container. Let's take a closer look
at this.

Consider the following pair of functions. Both take a value that conforms to
`CustomStringConvertible` and return the size of the value's type. The only
difference is that one function uses the protocol as a generic constraint,
whereas the other uses it as a type:

*/

func f<C: CustomStringConvertible>(_ x: C) -> Int {
    return MemoryLayout.size(ofValue: x)
}
func g(_ x: CustomStringConvertible) -> Int {
    return MemoryLayout.size(ofValue: x)
}
f(5)
g(5)

/*:
Where does the size difference of 8 bytes versus 40 bytes come from? Because `f`
takes a generic parameter, the integer 5 is passed straight to the function
without any kind of boxing. This is reflected in its size of 8 bytes, which is
the size of `Int` on a 64-bit system. For `g`, the integer is wrapped in an
existential container. For regular (i.e. non-class-constrained) protocols, an
*opaque existential container* is used. Opaque existential containers contain a
buffer (the size of three pointers, or 24 bytes) for the value; some metadata
(one pointer, 8 bytes); and a number of *witness tables* (zero or more
pointers, 8 bytes each). If the value doesn't fit into the buffer, it's stored
on the heap, and the buffer contains a reference to the storage location. The
metadata contains information about the type (so that it can be used with a
conditional cast, for example).

The witness table is what makes dynamic dispatch possible. It encodes the
implementation of a protocol for a specific type: for each method in the
protocol, the table contains an entry that points to the implementation for that
specific type. Sometimes this is also called a *vtable*. In a way, when we
created the first version of `AnyIterator`, we manually wrote a witness table.

Given the witness table, the surprising behavior of `addCircle` at the beginning
of this chapter makes a lot more sense. Because `addCircle` wasn't part of the
protocol definition (i.e. it wasn't a *requirement*), it wasn't in the witness
table either. Therefore, the compiler had no choice but to statically call the
protocol's default implementation. Once we made `addCircle` a protocol
requirement, it was also added to the witness table, and therefore called using
dynamic dispatch.

The size of the opaque existential container depends on the number of witness
tables: it contains one witness table per protocol. For example, `Any` is a
typealias for an empty protocol that has no witness tables at all:

``` swift-example
typealias Any = protocol<>
```

*/

MemoryLayout<Any>.size

/*:
If we combine multiple protocols, one 8-byte chunk gets added per protocol. So
combining four protocols adds 32 bytes:

*/

protocol Prot { }
protocol Prot2 { }
protocol Prot3 { }
protocol Prot4 { }
typealias P = Prot & Prot2 & Prot3 & Prot4
MemoryLayout<P>.size

/*:
For class-only protocols, there's a special existential container called a
*class existential container*, which only has the size of two words (plus one
word per additional witness table) — one for the metadata and one (instead of
three) for a reference to the class:

*/

protocol ClassOnly: AnyObject {}
MemoryLayout<ClassOnly>.size

/*:
Objective-C protocols that get imported into Swift don't have additional
metadata. Therefore, variables whose type is an Objective-C protocol don't have
to be wrapped in an existential container; they only consist of a plain pointer
to their class:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
MemoryLayout<NSObjectProtocol>.size


/*:
### Performance Implications

Existential containers add a level of indirection and therefore generally cause
a performance decrease over generic parameters (assuming the compiler can
specialize the generic code). In addition to the possibly slower method
dispatch, the existential container also acts as a barrier that prevents many
compiler optimizations. For the most part, worrying about this overhead is
premature optimization. However, if you need maximum performance in a tight
loop, it'll be more efficient to use a generic parameter rather than a parameter
that has a protocol type. This way, you can avoid the implicit protocol box.

If you try to pass `[String]` (or any other type) into a function that takes
`[Any]` (or any other array of a protocol rather than a specific type), the
compiler will emit code that maps over the entire array and boxes every value,
effectively making the function call itself — not the function body — an `O(n)`
operation (where `n` is the number of elements in the array). Again, this won't
be an issue in most cases, but if you need to write highly performant code, you
might choose to write your function with a generic parameter rather than a
protocol type:

*/

// Implicit boxing
func printProtocol(array: [CustomStringConvertible]) {
    print(array)
}

// No boxing
func printGeneric<A: CustomStringConvertible>(array: [A]) {
    print(array)
}

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
