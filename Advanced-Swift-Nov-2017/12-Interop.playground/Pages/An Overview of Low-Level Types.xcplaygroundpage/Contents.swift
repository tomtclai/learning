/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## An Overview of Low-Level Types

There are many types in the standard library that provide low-level access to
memory. Their sheer number can be overwhelming, as can daunting names like
`UnsafeMutableRawBufferPointer`. The good news is that they're named
consistently, so each type's purpose can be deduced from its name. Here are the
most important naming parts:

  - A **managed** type has automatic memory management. The compiler will
    allocate, initialize, and free the memory for you.

  - An **unsafe** type doesn't provide automated memory management (as opposed
    to *managed*) . You have to allocate, initialize, deallocate, and
    deinitialize the memory explicitly.

  - A **buffer** type works on multiple (contiguously stored) elements rather
    than a single element and provides a `Collection` interface.

  - A **pointer** type has pointer semantics (just like a C pointer).

  - A **raw** type contains untyped data. It's the equivalent of a `void*` in C.
    Types that don't contain *raw* in their name have typed data.

  - A **mutable** type allows the mutation of the memory it points to.

If you want raw storage but don't need to interact with C, you can use the
`ManagedBuffer` class to allocate the memory. This is what Swift's collections
use under the hood to manage their memory. It consists of a single header value
(for storing data such as the number of elements) and contiguous memory for the
elements. It also has a `capacity` property, which isn't the same as the number
of actual elements: for example, an `Array` with a `count` of 17 might own a
buffer with a capacity of 32, meaning that 15 more elements can be added before
the `Array` has to allocate more memory. There's also a variant called
`ManagedBufferPointer`, but it doesn't have many applications outside the
standard library and [may be removed in the
future](https://github.com/apple/swift-evolution/pull/545).

Sometimes you need to do manual memory management. For example, you might want
to pass a Swift object to a C function with the goal of retrieving it later. C
APIs that use callbacks (function pointers) often take an additional context
argument (usually an untyped pointer, or `void*`) that they pass on to each
invocation of the callback in order to work around C's lack of closures. When
you call such a function from Swift, it'd be convenient to be able to pass a
native Swift object as the context value. However, C doesn't know about Swift's
memory management. If the API is synchronous, you can just pass in the Swift
object and convert it back from the untyped pointer when you receive it in the
callback, and all will be fine (we'll look at this in detail in the next
section). However, if the API is asynchronous, you have to manually retain and
release that object, because otherwise the Swift runtime may deallocate it once
it goes out of scope. In order to do that, there's the `Unmanaged` type. It has
methods for `retain` and `release`, as well as initializers that either modify
or keep the current retain count.

### Pointers

In addition to the `OpaquePointerType` we've already seen, Swift has eight more
pointer types that map to different classes of C pointers.

The base type, `UnsafePointer`, is similar to a `const` pointer in C. It's
generic over the data type of the memory it points to, so `UnsafePointer<Int>`
corresponds to `const int*`.

Notice that C makes a difference between `const int*` (a *mutable pointer* to
*immutable data*, i.e. you can't write to the pointed data using this pointer)
and `int* const` (an *immutable pointer*, i.e. you can't change where this
pointer points to). `UnsafePointer` in Swift is equivalent to the former
variant. As always, you control the mutability of the pointer itself by
declaring the variable with `var` or `let`.

You can create an unsafe pointer from one of the other pointer types using an
initializer. Swift also supports a special syntax for calling functions that
take unsafe pointers. You can pass any *mutable* variable of the correct type to
such a function by prefixing it with an ampersand, thereby making it an *in-out
expression*:

*/

var x = 5
func fetch(p: UnsafePointer<Int>) -> Int {
    return p.pointee
}
fetch(p: &x)

/*:
This looks exactly like the `inout` parameters we covered in the functions
chapter, and it works in a similar manner — although in this case, nothing is
passed back to the caller via this value because the pointer isn't mutable. The
pointer that Swift creates behind the scenes and passes to the function is
guaranteed to be valid only for the duration of the function call. Don't try to
return the pointer from the function and access it after the function has
returned — the result is undefined.

There's also a mutable variant, named `UnsafeMutablePointer`. This struct works
just like a regular C pointer; you can dereference the pointer and change the
value of the memory, which then gets passed back to the caller via the in-out
expression:

*/

func increment(p: UnsafeMutablePointer<Int>) {
    p.pointee += 1
}
var y = 0
increment(p: &y)
y

/*:
Rather than using an in-out expression, you can also allocate memory directly
using `UnsafeMutablePointer`. The rules for allocating memory in Swift are
similar to the rules in C: after allocating the memory, you first need to
initialize it before you can use it. Once you're done with the pointer, you need
to deallocate the memory:

*/

// Allocate and initialize memory for two Ints
let z = UnsafeMutablePointer<Int>.allocate(capacity: 2)
z.initialize(to: 42, count: 2)
z.pointee
// Pointer arithmetic:
(z+1).pointee = 43
// Subscripts:
z[1]
// Deallocate the memory
// If Pointee is a non-trivial type (e.g. a class), you must
// call deinitialize before calling deallocate.
z.deallocate(capacity: 2)
// Don't access pointee after deallocate

/*:
We saw another example of this in the chapter on strings when we allocated a
pointer to an `NSRange` for the purpose of receiving a value back from a
Foundation API.

In C APIs, it's also very common to have a pointer to a sequence of bytes with
no specific element type (`void*` or `const void*`). The equivalent counterparts
in Swift are the `UnsafeMutableRawPointer` and `UnsafeRawPointer` types. C APIs
that use `void*` or `const void*` get imported as these types. Unless you really
need to operate on raw bytes, you'd usually directly convert these types into
`Unsafe[Mutable]Pointer` or other typed variants by using one of their instance
methods (such as `assumingMemoryBound(to:)`, `bindMemory(to:)`, or
`load(fromByteOffset:as:)`).

Unlike C, Swift uses optionals to distinguish between nullable and non-nullable
pointers. Only values with an optional pointer type can represent a null
pointer. Under the hood, the memory layout of an `UnsafePointer<T>` and an
`Optional<UnsafePointer<T>>` is exactly identical; the compiler is smart enough
to map the `.none` case to the all-zeros bit pattern of the null pointer.

Sometimes a C API has an opaque pointer type. For example, in the cmark library,
we saw that the type `cmark_node*` gets imported as an `OpaquePointer`. The
definition of `cmark_node` isn't exposed in the header, and therefore, we can't
access the pointee's memory. You can convert opaque pointers to other pointers
using an initializer.

In Swift, we usually use the `Array` type to store a sequence of values
contiguously. In C, an array is often returned as a pointer to the first element
and an element count. If we want to use such a sequence as a collection, we
could turn the sequence into an `Array`, but that makes a copy of the elements.
This is often a good thing (because once they're in an array, the elements are
memory managed by the Swift runtime). However, sometimes you don't want to make
copies of each element. For those cases, there are the
`Unsafe[Mutable]BufferPointer` types. You initialize them with a pointer to the
start element and a count. From then on, you have a (mutable) random-access
collection. The buffer pointers make it a lot easier to work with C collections.

Finally, the `Unsafe[Mutable]RawBufferPointer` types make it easier to work with
raw memory as collections (they provide the low-level equivalent to `Data` and
`NSData`).

> While pointers require you to manually allocate and free memory, they do
> perform the standard ARC memory management operations on the elements you
> store through a pointer. When you have an unsafe mutable (buffer) pointer
> whose `Pointee` type is a class type, it'll retain every object you store with
> `initialize` and release it again when you call `deinitialize`.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
