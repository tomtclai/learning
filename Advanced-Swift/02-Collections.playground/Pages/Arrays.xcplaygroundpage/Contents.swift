/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Arrays

### Arrays and Mutability

Arrays are the most common collections in Swift. An array is an ordered
container of elements that all have the same type, with random access to each
element. As an example, to create an array of numbers, we can write the
following:

*/

// The Fibonacci numbers
let fibs = [0, 1, 1, 2, 3, 5]

/*:
If we try to modify the array defined above (by using `append(_:)`, for
example), we get a compile error. This is because the array is defined as a
constant, using `let`. In many cases, this is exactly the right thing to do; it
prevents us from accidentally changing the array. If we want the array to be a
variable, we have to define it using `var`:

*/

var mutableFibs = [0, 1, 1, 2, 3, 5]

/*:
Now we can easily append a single element or a sequence of elements:

*/

mutableFibs.append(8)
mutableFibs.append(contentsOf: [13, 21])
mutableFibs

/*:
There are a couple of benefits that come with making the distinction between
`var` and `let`. Constants defined with `let` are easier to reason about because
they're immutable. When you read a declaration like `let fibs = ...`, you know
that the value of `fibs` will never change — it's enforced by the compiler. This
helps greatly when reading through code. However, note that this is only true
for types that have value semantics. A `let` variable to a class instance (i.e.
a reference type) guarantees that the *reference* will never change, i.e. you
can't assign another object to that variable. However, the object the reference
points to *can* change. We'll go into more detail on these differences in the
chapter on structs and classes.

Arrays, like all collection types in the standard library, have value semantics.
When you assign an existing array to another variable, the array contents are
copied over. For example, in the following code snippet, `x` is never modified:

*/

var x = [1,2,3]
var y = x
y.append(4)
y
x

/*:
The statement `var y = x` makes a copy of `x`, so appending `4` to `y` won't
change `x` — the value of `x` will still be `[1, 2, 3]`. The same thing happens
when you pass an array into a function; the function gets a local copy, and any
changes it makes don't affect the caller.

Contrast this with the approach to mutability taken by `NSArray` in Foundation.
`NSArray` has no mutating methods — to mutate an array, you need an
`NSMutableArray`. But just because you have a non-mutating `NSArray` reference
does *not* mean the array can't be mutated underneath you:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
let a = NSMutableArray(array: [1,2,3])
// I don't want to be able to mutate b
let b: NSArray = a
// But it can still be mutated — via a
a.insert(4, at: 3)
b

/*:
The correct way to write this is to manually create a copy upon assignment:

*/

let c = NSMutableArray(array: [1,2,3])
// I don't want to be able to mutate d
let d = c.copy() as! NSArray
c.insert(4, at: 3)
d

/*:
In the example above, it's very clear that we need to make a copy — `a` is
mutable, after all. However, when passing around arrays between methods and
functions, this isn't always so easy to see.

In Swift, there's just one array type, and mutability is controlled by declaring
with `var` instead of `let`. But there's no reference sharing — when you declare
a second array with `let`, you're guaranteed it'll never change.

Making so many copies could be a performance problem, but in practice, all
collection types in the Swift standard library are implemented using a technique
called copy-on-write, which makes sure the data is only copied when necessary.
So in our example, `x` and `y` shared internal storage up the point where
`y.append` was called. In the chapter on structs and classes, we'll take a
deeper look at value semantics, including how to implement copy-on-write for
your own types.

*/


/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
