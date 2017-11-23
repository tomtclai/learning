/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Value Types

We're often dealing with objects that need an explicit *lifecycle*: they're
initialized, changed, and destroyed. For example, a file handle has a clear
lifecycle: it's opened, actions are performed on it, and then we need to close
it. If we open two file handles that otherwise have the same properties, we
still want to keep them separate. In order to compare two file handles, we check
whether they point to the same address in memory. Because we compare addresses,
file handles are best implemented as reference types, using objects. This is
what the `FileHandle` class in Foundation does.

Other types don't need to have a lifecycle. For example, a URL is created and
then never changed. More importantly, it doesn't need to perform any action when
it's destroyed (in contrast to the file handle, which needs to be closed). When
we compare two URL variables, we don't care whether they point to the same
address in memory, rather we check whether they point to the same URL. Because
we compare URLs by their properties, we say that they're *values*. In
Objective-C, they were implemented as immutable objects using the `NSURL` class.
However, the Swift counterpart, `URL`, is a struct.

In all software, there are many objects that have a lifecycle — file handles,
notification centers, networking interfaces, database connections, and view
controllers are some examples. For all these types, we want to perform specific
actions on initialization and when they're destroyed. When comparing these
types, we don't compare their properties, but instead compare their memory
addresses. All of these types are implemented as classes, and all of them are
reference types.

There are also many values at play in most software. URLs, binary data, dates,
errors, strings, notifications, and numbers are only defined by their
properties. When we compare them, we're not interested in their memory
addresses. All of these types can be implemented using structs.

Values never change; they're immutable. This is (mostly) a good thing, because
code that works with immutable data is much easier to understand. The
immutability automatically makes such code thread-safe too: anything that can't
change can be safely shared across threads.

In Swift, structs are designed to build values. Structs can't be compared by
reference; we can only compare their properties. And although we can declare
mutable struct *variables* (using `var`), it's important to understand that the
mutability only refers to the variable and not the underlying value. Mutating a
property of a struct variable is conceptually the same as assigning a whole new
struct (with a different value for the property) to the variable.

Structs have a single owner. For instance, if we pass a struct variable to a
function, that function receives a copy of the struct, and it can only change
its own copy. This is called *value semantics* (sometimes also called copy
semantics). Contrast this with the way objects work: they get passed by
reference and can have many owners. This is called *reference semantics*.

Because structs only have a single owner, it's not possible to create a
reference cycle. But with classes and functions, we need to always be careful to
not create reference cycles. We'll look at reference cycles in the section on
memory.

The fact that values are copied all the time may sound inefficient; however, the
compiler can optimize away many superfluous copy operations. It can do this
because structs are very basic things. A struct copy is a shallow bitwise copy
(except if it contains any classes — then it needs to increase the reference
count for those). When structs are declared with `let`, the compiler knows for
certain that none of those bits can be mutated later on. And there are no hooks
for the developer to know *when* the struct is being copied, unlike with similar
value types in C++. This simplicity gives the compiler many more possibilities
for eliminating copy operations or optimizing a constant structure to be passed
by reference rather than by value.

Copy optimizations of a value *type* that might be done by the compiler aren't
the same as the copy-on-write behavior of a type with value *semantics*.
Copy-on-write has to be implemented by the developer, and it works by detecting
that the contained class has shared references.

Unlike the automatic elimination of value type copies, you don't get
copy-on-write for free. But the two optimizations — the compiler potentially
eliminating unnecessary "dumb" shallow copies, and the code inside types like
`Array` that perform "smart" copy-on-write — complement each other. We'll look
at how to implement your own copy-on-write mechanism shortly.

If a struct is composed out of other structs, the compiler can enforce
immutability. Also, when using structs, the compiler can generate really fast
code. For example, the performance of operations on an array containing just
structs is usually much better than the performance of operations on an array
containing objects. This is because structs usually have less indirection: the
values are stored directly inside the array's memory, whereas an array
containing objects contains just the references to the objects. Finally, in many
cases, the compiler can put structs on the stack rather than on the heap.

When interfacing with Cocoa and Objective-C, we often need to use classes. For
example, when implementing a delegate for a table view, there's no choice: we
must use a class. Many of Apple's frameworks rely heavily on subclassing.
However, depending on the problem domain, we can still create a class where the
objects are values. For example, in the Core Image framework, the `CIImage`
objects are immutable: they represent an image that never changes.

It's not always easy to decide whether your new type should be a struct or a
class. Both behave very differently, and knowing the differences will help you
make a decision. In the examples in the rest of this chapter, we'll look in more
detail at the implications of value types and provide some guidance for when to
use structs.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
