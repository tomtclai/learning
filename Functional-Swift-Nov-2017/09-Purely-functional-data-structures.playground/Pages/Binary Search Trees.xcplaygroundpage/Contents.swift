/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Binary Search Trees

When Swift was released, it didn't have a built-in type for sets, like
Foundation's `NSSet`. While we could've written a Swift wrapper around `NSSet`,
we'll instead explore a slightly different approach. Our aim is, once again, not
to define a comprehensive set type (the `Set` type was added to the standard
library in Swift 2), but rather to demonstrate how recursive enumerations can be
used to define efficient data structures.

In our little library, we'll implement the following three set operations:

  - `isEmpty` — checks whether or not a set is empty

  - `contains` — checks whether or not an element is in a set

  - `insert` — adds an element to an existing set

As a first attempt, we may use arrays to represent sets. These three operations
are almost trivial to implement:

*/

struct MySet<Element: Equatable> {
    var storage: [Element] = []

    var isEmpty: Bool {
        return storage.isEmpty
    }

    func contains(_ element: Element) -> Bool {
        return storage.contains(element)
    }

    func inserting(_ x: Element) -> MySet {
        return contains(x) ? self : MySet(storage: storage + [x])
    }
}

/*:
While simple, the drawback of this implementation is that many of the operations
perform linearly in the size of the set. For large sets, this may cause
performance problems.

There are several possible ways to improve performance. For example, we could
ensure the array is sorted and use binary search to locate specific elements.
Instead, we'll define a *binary search tree* to represent our sets. We can build
a tree structure in the traditional C style, maintaining pointers to subtrees at
every node. However, we can also define such trees directly as an enumeration in
Swift using the `indirect` keyword:

*/

indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>,
        Element, BinarySearchTree<Element>)
}

/*:
This definition states that every tree is either:

  - a `leaf` without associated values, or

  - a `node` with three associated values, which are the left subtree, a value
    stored at the node, and the right subtree.

Before defining functions on trees, we can write a few example trees by hand:

*/

let leaf: BinarySearchTree<Int> = .leaf
let five: BinarySearchTree<Int> = .node(leaf, 5, leaf)

/*:
The `leaf` tree is empty; the `five` tree stores the value `5` at a node, but
both subtrees are empty. We can generalize these constructions with two
initializers: one that builds an empty tree, and one that builds a tree with a
single value:

*/

extension BinarySearchTree {
    init() {
        self = .leaf
    }

    init(_ value: Element) {
        self = .node(.leaf, value, .leaf)
    }
}

/*:
Just as we saw in the previous chapter, we can write functions that manipulate
trees using switch statements. As the `BinarySearchTree` enumeration itself is
recursive, it should come as no surprise that many functions we write over trees
will also be recursive. For example, the following function counts the number of
elements stored in a tree:

*/

extension BinarySearchTree {
    var count: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, right):
            return 1 + left.count + right.count
        }
    }
}

/*:
In the base case for leaves, we can return `0` immediately. The case for nodes
is more interesting: we compute the number of elements stored in both subtrees
*recursively*. We then return their sum and add `1` to account for the value
stored at this node.

Similarly, we can write an `elements` property that computes the array of
elements stored in a tree:

*/

extension BinarySearchTree {
    var elements: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
}

/*:
The `count` and `elements` properties are very similar. For the `leaf` case,
there's a base case. In the `node` case, they recursively call themselves for
the child nodes and combine the results with the element. We can define an
abstraction for this, sometimes called a `fold` or `reduce`:

*/

extension BinarySearchTree {
    func reduce<A>(leaf leafF: A, node nodeF: (A, Element, A) -> A) -> A {
        switch self {
        case .leaf:
            return leafF
        case let .node(left, x, right):
            return nodeF(left.reduce(leaf: leafF, node: nodeF),
                         x,
                         right.reduce(leaf: leafF, node: nodeF))
        }
    }
}

/*:
This allows us to write `elements` and `count` with very little code:

*/

extension BinarySearchTree {
    var elementsR: [Element] {
        return reduce(leaf: []) { $0 + [$1] + $2 }
    }
    var countR: Int {
        return reduce(leaf: 0) { 1 + $0 + $2 }
    }
}

/*:
Now let's return to our original goal, which is writing an efficient set library
using trees. We have an obvious choice for checking whether or not a tree is
empty:

*/

extension BinarySearchTree {
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
}

/*:
Note that in the `node` case for the `isEmpty` property, we can immediately
return `false` without examining the subtrees or the node's value.

If we try to write naive versions of `insert` and `contains`, however, it seems
that we haven't gained much. But if we restrict ourselves to *binary search
trees*, we can perform much better. A (non-empty) tree is said to be a binary
search tree if all of the following conditions are met:

  - all the values stored in the left subtree are *less* than the value stored
    at the root

  - all the values stored in the right subtree are *greater* than the value
    stored at the root

  - both the left and right subtrees are binary search trees

The way we implement the `BinarySearchTree` in this chapter comes with a
disadvantage: we can't strictly enforce the tree to be a binary search tree,
because you can just construct any tree "by hand." In the real world, we should
encapsulate the enum as a private implementation detail so that we can guarantee
the tree to be a binary search tree. We omit this here for the sake of
simplicity.

We can write an (inefficient) check to ascertain if a `BinarySearchTree` is in
fact a binary search tree:

*/

extension BinarySearchTree {
    var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, x, right):
            return left.elements.all { y in y < x }
                && right.elements.all { y in y > x }
                && left.isBST
                && right.isBST
        }
    }
}

/*:
The `all` function checks if a property holds for all elements in an array. It's
defined as an extension on `Sequence`:

*/

extension Sequence{
    func all(predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}

/*:
The crucial property of binary search trees is that they admit an efficient
lookup operation, akin to binary search in an array. As we traverse the tree to
determine whether or not an element is in the tree, we can rule out (up to) half
of the remaining elements in every step. For example, here is one possible
definition of the `contains` function that determines whether or not an element
occurs in the tree:

*/

extension BinarySearchTree {
    func contains(_ x: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(_, y, _) where x == y:
            return true
        case let .node(left, y, _) where x < y:
            return left.contains(x)
        case let .node(_, y, right) where x > y:
            return right.contains(x)
        default:
            fatalError("The impossible occurred")
        }
    }
}

/*:
The `contains` function now distinguishes four possible cases:

  - If the tree is empty, the `x` isn't in the tree and we return `false`.

  - If the tree is non-empty and the value stored at its root is equal to `x`,
    we return `true`.

  - If the tree is non-empty and the value stored at its root is greater than
    `x`, we know that if `x` is in the tree, it must be in the left subtree.
    Hence, we recursively search for `x` in the left subtree.

  - Similarly, if `x` is greater than the value stored at the root, we proceed
    by searching the right subtree.

Unfortunately, the Swift compiler isn't yet clever enough to see that these four
cases cover all the possibilities, so we need to insert a dummy default case.

Insertion searches through the binary search tree in exactly the same fashion:

*/

extension BinarySearchTree {
    mutating func insert(_ x: Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(x)
        case .node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = .node(left, y, right)
        }
    }
}

/*:
Instead of checking first whether or not the element is already contained in the
binary search tree, `insert` finds a suitable location to add the new element.
If the tree is empty, it builds a tree with a single element. If the element is
already present, it returns the original tree. Otherwise, the `insert` function
continues recursively, navigating to a suitable location to insert the new
element.

The `insert` function is written as a `mutating` function. However, this is very
different from mutation in a class-based data structure. The actual *values*
aren't mutated, just the variables. For example, in the case of insertion, the
new tree is constructed out of the branches of the old tree. These branches
never get mutated. Data structures with this behavior are sometimes called
*persistent data structures*. We can verify the behavior by looking at a usage
example:

*/

let myTree: BinarySearchTree<Int> = BinarySearchTree()
var copied = myTree
copied.insert(5)
myTree.elements
copied.elements

/*:
The worst-case performance of `insert` and `contains` on binary search trees is
still linear — after all, we could have a very unbalanced tree, where every left
subtree is empty. More clever implementations, such as 2-3 trees, AVL trees, or
red-black trees, avoid this by maintaining the invariant that each tree is
suitably balanced. Furthermore, we haven't written a `delete` operation, which
would also require rebalancing. These are tricky operations for which there are
plenty of well-documented implementations in the literature — once again, this
example serves as an illustration of working with recursive enumerations and
does not pretend to be a complete library.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
