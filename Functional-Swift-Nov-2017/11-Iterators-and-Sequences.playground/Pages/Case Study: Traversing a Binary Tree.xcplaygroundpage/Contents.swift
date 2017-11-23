/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Case Study: Traversing a Binary Tree

To illustrate sequences and iterators, we'll consider defining a traversal on a
binary tree. Recall our definition of binary trees from Chapter 9:

*/

indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(
        BinarySearchTree<Element>, 
        Element, 
        BinarySearchTree<Element>
    )
}

/*:
We can use the append operator, `+`, which we defined for iterators earlier in
this chapter, to produce sequences of elements of a binary tree. For example,
the `makeIterator` traversal visits the left subtree, the root, and the right
subtree, in that order:

*/

// --- (Hidden code block) ---
func +<I: IteratorProtocol, J: IteratorProtocol>(
    first: I, second: @escaping @autoclosure () -> J)
    -> AnyIterator<I.Element> where I.Element == J.Element
{
    var one = first
    var other: J? = nil
    return AnyIterator {
        if other != nil {
            return other!.next()
        } else if let result = one.next() {
            return result
        } else {
            other = second()
            return other!.next()
        }
    }
}
// ---------------------------
extension BinarySearchTree: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        switch self {
        case .leaf: return AnyIterator { return nil }
        case let .node(l, element, r):
            return l.makeIterator() + CollectionOfOne(element).makeIterator() +
                r.makeIterator()
        }
    }
}

/*:
If the tree has no elements, we return an empty iterator. If the tree has a
node, we combine the results of the two recursive calls, together with the
single value stored at the root, using the append operator on iterators.
`CollectionOfOne` is a type from the standard library. Note that we defined `+`
in a lazy way. If we would've used the first (eager) definition of `+`, the
`makeIterator` method would've visited the entire tree before returning.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
