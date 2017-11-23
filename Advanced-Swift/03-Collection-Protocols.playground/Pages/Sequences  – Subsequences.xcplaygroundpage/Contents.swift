/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Subsequences

`Sequence` has another associated type, named `SubSequence`:

``` swift-example
protocol Sequence {
    associatedtype Element
    associatedtype Iterator: IteratorProtocol
        where Iterator.Element == Element
    associatedtype SubSequence
    // ...
}
```

`SubSequence` is used as the return type for operations that return slices of
the original sequence:

  - **`prefix`** and **`suffix`** — take the first or last *n* elements

  - **`prefix(while:)`** — take elements from the start as long as they conform
    to a condition

  - **`dropFirst`** and **`dropLast`** — return subsequences where the first or
    last *n* elements have been removed

  - **`drop(while:)`** — drop elements until the condition ceases to be true,
    and then return the rest

  - **`split`** — break up the sequence at the specified separator elements and
    return an array of subsequences

If you don't specify a type for `SubSequence`, the compiler will infer it to be
`AnySequence<Element>` because `Sequence` provides default implementations for
the above methods with that return type. If you want to use your own subsequence
type, you must provide custom implementations for these methods.

It can sometimes be convenient if `SubSequence == Self`, i.e. if subsequences
have the same type as the base sequence, because this allows you to pass a slice
everywhere the base collection is expected. The standard library collections
have separate slice types, however; the main motivation for this is to avoid
accidental memory "leaks" that can be caused by a tiny slice that keeps its base
collection (which may be very large) alive much longer than anticipated. Making
slices their own types makes it easier to bind their lifetimes to local scopes.

In an ideal world, the associated type declaration would include constraints to
ensure that `SubSequence` (a) is also a sequence, and (b) has the same element
and subsequence types as its base sequence. It should look something like this:

``` swift-example
associatedtype SubSequence: Sequence
    where Element == SubSequence.Element,
        SubSequence.SubSequence == SubSequence
```

This didn't make it into Swift 4.0 because the compiler lacks support for
recursive protocol constraints (`Sequence` would reference itself). However, we
expect these in a future Swift release. Until then, you may find yourself having
to add some or all of these constraints to your own `Sequence` extensions to
help the compiler understand the types. The standard library was designed from
the start with recursive constraints in mind; many `Sequence` and `Collection`
APIs will be easier to understand once this feature is implemented because
they'll be able to drop the explicit constraints that are currently still
necessary.

The following example checks if a sequence starts with the same *n* elements
from the head and the tail. It does this by comparing the sequence's prefix with
the reversed suffix:

*/

extension Sequence where Element: Equatable, SubSequence: Sequence, 
    SubSequence.Element == Element
{
    func headMirrorsTail(_ n: Int) -> Bool {
        let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)
    }
}

[1,2,3,4,2,1].headMirrorsTail(2)

/*:
The comparison using `elementsEqual` only passes type checking if we tell the
compiler that the subsequence is also a sequence, and that its elements have the
same type as the base sequence's elements (which we constrained to `Equatable`).

*/


/*:
We show another example of sequence extensions like this in the chapter on
generics.

### A Linked List

As an example of a custom sequence, let's implement one of the most basic data
structures of all: a singly linked list, defined using indirect enums. A linked
list node is one of either two things: a node with a value and a reference to
the next node, or a node indicating the end of the list. We can define it like
this:

*/

/// A singly linked list
enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

/*:
The `indirect` keyword here indicates that the compiler should represent the
`node` value as a reference. Swift enums are value types. This means they hold
their values directly in the variable, rather than the variable holding a
reference to the location of the value. This has many benefits, as we'll see in
the structs and classes chapter. But value types can't refer to themselves
recursively because doing so would make it impossible for the compiler to
calculate their size. The `indirect` keyword allows an enum case to be held as a
reference and thus allows the enum to hold a reference to itself.

We prepend an element to a list by creating a new node, with the `next:` value
set to the current node:

*/

let emptyList = List<Int>.end
let oneElementList = List.node(1, next: emptyList)

/*:
We can create a method for prepending to make this process a little easier. We
name this method `cons`, because that's the name of the operation in LISP (it's
short for "construct," and adding elements onto the front of the list is
sometimes called "consing"):

*/

extension List {
    /// Return a new list by prepending a node with value `x` to the
    /// front of a list.
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

// A 3-element list, of (3 2 1)
let list = List<Int>.end.cons(1).cons(2).cons(3)

/*:
The chaining syntax makes it clear how a list is constructed, but it's also kind
of ugly. We can add conformance to `ExpressibleByArrayLiteral` to be able to
initialize a list with an array literal. The implementation first reverses the
input array (because lists are built from the end) and then uses `reduce` to
prepend the elements to the list one by one, starting with the `.end` node:

*/

extension List: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in
            partialList.cons(element)
        }
    }
}

let list2: List = [3,2,1]

/*:
This list type has an interesting property: it's
"[persistent](https://en.wikipedia.org/wiki/Persistent_data_structure)." The
nodes are immutable — once created, you can't change them. Consing another
element onto the list doesn't copy the list; it just gives you a new node that
links onto the front of the existing list.

This means two lists can share a tail:

![List Sharing](artwork/list-share.png)

The immutability of the list is key here. If you could change the list (say,
remove the last entry, or update the element held in a node), then this sharing
would be a problem — `x` might change the list, and the change would affect `y`.

Still, we can define `mutating` methods on `List` to push and pop elements
(because the list is also a stack, with consing as push and unwrapping the next
element as pop):

*/

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }

    mutating func pop() -> Element? {
        switch self {
        case .end: return nil
        case let .node(x, next: tail):
            self = tail
            return x
        }
    }
}

/*:
But didn't we just say that the list had to be immutable for the persistence to
work? How can it have mutating methods?

These mutating methods don't change the list. Instead, they just change the part
of the list the variables refer to:

*/

var stack: List<Int> = [3,2,1]
var a = stack
var b = stack

a.pop()
a.pop()
a.pop()

stack.pop()
stack.push(4)

b.pop()
b.pop()
b.pop()

stack.pop()
stack.pop()
stack.pop()

/*:
This shows us the difference between values and variables. The nodes of the list
are values; they can't change. A node of three and a reference to the next node
can't become some other value; it'll be that value forever, just like the number
three can't change. It just is. Just because these values in question are
structures with references to each other doesn't make them less value-like.

A variable `a`, on the other hand, can change the value it holds. It can be set
to hold a value of an indirect reference to any of the nodes or to the value
`end`. But changing `a` doesn't change these nodes; it just changes which node
`a` refers to.

This is what these mutating methods on structs do — they take an implicit
`inout` argument of `self`, and they can change the value `self` holds. This
doesn't change the list, but rather which part of the list the variable
currently represents. In this sense, through `indirect`, the variables have
become iterators into the list:

![List Iteration](artwork/list-iteration.png)

You can, of course, declare your variables with `let` instead of `var`, in which
case the variables will be constant (i.e. you can't change the value they hold
once they're set). But `let` is about the variables, not the values. Values are
constant by definition.

Now this is all just a logical model of how things work. In reality, the nodes
are actually places in memory that point to each other. And they take up space,
which we want back if it's no longer needed. Swift uses automated reference
counting (ARC) to manage this and frees the memory for the nodes that are no
longer used:

![List Memory Management](artwork/list-arc.png)

We'll discuss `inout` in more detail in the chapter on functions, and we'll
cover mutating methods as well as ARC in the structs and classes chapter.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
