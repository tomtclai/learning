/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Specialized Collections

Like all well-designed protocols, `Collection` strives to keep its requirements
as small as possible. In order to allow a wide array of types to become
collections, the protocol shouldn't require conforming types to provide more
than is absolutely necessary to implement the desired functionality.

Two particularly interesting limitations are that a `Collection` can't move its
indices backward, and that it doesn't provide any functionality for mutating the
collection, such as inserting, removing, or replacing elements. That isn't to
say that conforming types can't have these capabilities, of course, only that
the protocol makes no assumptions about them.

Some algorithms have additional requirements, though, and it would be nice to
have generic variants of them, even if only some collections can use them. For
this purpose, the standard library includes four specialized collection
protocols, each of which refines `Collection` in a particular way in order to
enable new functionality (the quotes are from the standard library
documentation):

  - **`BidirectionalCollection`** — "A collection that supports backward as well
    as forward traversal."

  - **`RandomAccessCollection`** — "A collection that supports efficient
    random-access index traversal."

  - **`MutableCollection`** — "A collection that supports subscript assignment."

  - **`RangeReplaceableCollection`** — "A collection that supports replacement
    of an arbitrary subrange of elements with the elements of another
    collection."

Let's discuss them one by one.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
