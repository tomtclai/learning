/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Choosing Between Unowned and Weak References

Should you prefer unowned or weak references in your own APIs? Ultimately, this
question boils down to the lifetimes of the objects involved. If the objects
have *independent lifetimes* — that is, if you can't make any assumptions about
which object will outlive the other — a weak reference is the only possible
choice.

On the other hand, if you can guarantee that the non-strongly referenced object
has *the same lifetime* as its counterpart or will always outlive it, an unowned
reference is often more convenient. This is because it doesn't have to be
optional and the variable can be declared with `let`, whereas weak references
must always be optional `var`s. Same-lifetime situations are very common,
especially when the two objects have a parent-child relationship. When the
parent controls the child's lifetime with a strong reference and you can
guarantee that no other objects know about the child, the child's back reference
to its parent can always be unowned.

Unowned references also have less overhead than weak references, so accessing a
property or calling a method on an unowned reference will be slightly faster;
this should only be a factor in very performance-critical code paths, however.

The downside of preferring unowned references is of course that your program may
crash if you make a mistake in your lifetime assumptions. Personally, we often
find ourselves preferring `weak` even when `unowned` could be used because the
former forces us to explicitly check if the reference is still valid at every
point of use. We might want to refactor some code at a later point, and our
earlier assumptions about object lifetimes might not be valid anymore.

But there's definitely an argument to be made to [always use the modifier that
captures the lifetime
characteristics](https://www.uraimo.com/2016/10/27/unowned-or-weak-lifetime-and-performance/)
you expect your code to have in order to make them explicit. If you or someone
else later changes the code in a way that invalidates those assumptions, a hard
crash is arguably the sensible way to alert you to the problem — assuming you
find the bug during testing.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
