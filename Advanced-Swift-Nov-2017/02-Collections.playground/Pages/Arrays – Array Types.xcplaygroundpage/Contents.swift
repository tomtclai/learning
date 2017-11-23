/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Array Types

#### Slices

In addition to accessing a single element of an array by subscript (e.g.
`fibs[0]`), we can also access a range of elements by subscript. For example, to
get all but the first element of an array, we can do the following:

*/

// --- (Hidden code block) ---
let fibs = [0, 1, 1, 2, 3, 5]
// ---------------------------
let slice = fibs[1...]
slice
type(of: slice)

/*:
This gets us a slice of the array starting at the second element. The type of
the result is `ArraySlice`, not `Array`. `ArraySlice` is a *view* on arrays.
It's backed by the original array, yet it provides a view on just the slice.
This makes certain the array doesn't need to get copied. The `ArraySlice` type
has the same methods defined as `Array` does, so you can use a slice as if it
were an array. If you do need to convert a slice into an array, you can just
construct a new array out of the slice:

*/

let newArray = Array(slice)
type(of: newArray)

/*:
![Array Slices](artwork/arrayslice.png)

#### Bridging

Swift arrays can bridge to Objective-C. They can also be used with C, but we'll
cover that in a later chapter. Because `NSArray` can only hold objects, the
compiler and runtime will automatically wrap incompatible values (for example,
Swift enums) in an opaque box object. A number of value types (such as `Int`,
`Bool`, and `String`, but also `Dictionary` and `Set`) are bridged automatically
to their Objective-C counterparts.

> A universal bridging mechanism for all Swift types to Objective-C doesn't just
> make working with arrays more pleasant. It also applies to other collections,
> like dictionaries and sets, and it opens up a lot of potential for future
> enhancements to the interoperability between Swift and Objective-C. For
> example, a future Swift version might allow Swift value types to conform to
> `@objc` protocols.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
