/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Mutability

In recent years, manipulating mutable state has earned a bad reputation, and
often deservedly so. It's named as a major cause of bugs, and most experts
recommend you work with immutable objects where possible, in order to write
safe, maintainable code. Luckily, Swift allows us to write safe code while
preserving an intuitive mutable coding style at the same time.

To see how this works, let's start by showing some of the problems with
mutation. In Foundation, there are two classes for arrays: `NSArray`, and its
subclass, `NSMutableArray`. We can write the following (crashing) program using
`NSMutableArray`:

*/

// --- (Hidden code block) ---
import Foundation
// ---------------------------
/*:
``` swift-example
let mutableArray: NSMutableArray = [1,2,3]
for _ in mutableArray {
    mutableArray.removeLastObject()
}
```

You're not allowed to mutate an `NSMutableArray` while you're iterating through
it, because the iterator works on the original array, and mutating it corrupts
the iterator's internal state. Once you know this, the restriction makes sense,
and you won't make that mistake again. However, consider that there could be a
different method call in the place of `mutableArray.removeLastObject()`, and
that method might mutate `mutableArray`. Now the violation becomes much harder
to see, unless you know exactly what that method does.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
