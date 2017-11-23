/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Sets

The third major collection type in the standard library is `Set`. A set is an
unordered collection of elements, with each element appearing only once. You can
essentially think of a set as a dictionary that only stores keys and no values.
Like `Dictionary`, `Set` is implemented with a hash table and has similar
performance characteristics and requirements. Testing a value for membership in
the set is a constant-time operation, and set elements must be `Hashable`, just
like dictionary keys.

Use a set instead of an array when you need to test efficiently for membership
(an `O(n)` operation for arrays) and the order of the elements is not important,
or when you need to ensure that a collection contains no duplicates.

`Set` conforms to the `ExpressibleByArrayLiteral` protocol, which means that we
can initialize it with an array literal like this:

*/

let naturals: Set = [1, 2, 3, 2]
naturals
naturals.contains(3)
naturals.contains(0)

/*:
Note that the number `2` appears only once in the set; the duplicate never even
gets inserted.

Like all collections, sets support the common operations we've already seen: you
can iterate over the elements in a `for` loop, `map` or `filter` them, and do
all other sorts of things.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
