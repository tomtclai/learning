/*:
 [Previous page](@previous)

 # Red-Black Trees
 
 
 *Self-balancing binary search trees* provide efficient
 algorithms for implementing sorted collections. In particular, these data structures can be used
 to implement sorted sets so that the insertion of any element only
 takes logarithmic time. This is a really attractive feature — remember, our
 `SortedArray` implemented insertions in linear time.
 
 The expression, "self-balancing binary search tree," looks kind of technical. Each
 word has a specific meaning, so I'll quickly explain them.
 
 A *tree* is a data structure with data stored inside *nodes*,
 arranged in a branching, tree-like structure. Each tree has a single node at
 the top called the *root node*. (The root is put on the top because computer
 scientists have been drawing trees upside down for decades. This is because it's
 more practical to draw tree diagrams this way, and not because they don't know
 what an actual tree looks like. Or at least I hope so, anyway.) If a node has
 no children, then it's called a *leaf node*; otherwise, it's an *internal node*.
 A tree usually has many leaf nodes.
 
 In general, internal nodes may have any number of child nodes, but in
 *binary trees*, nodes may only have two children, called *left* and *right*.
 Some nodes may have two children, while some may have only a left child, only a
 right child, or no child at all.
 
 ![Figure 4.1: A binary search tree. Node 6 is the root node and nodes 6, 3, and 8 are internal nodes, while nodes 2, 4, and 9 are leaves.](Images/SearchTree@3x.png)
 
 In *search trees*, the values inside nodes are comparable in some way, and
 nodes are arranged such that for every node in the tree, all values inside the
 left subtree are less than the value of the node, and all values to the right
 are greater than it. This makes it easy to find any particular element.
 
 By *self-balancing*, we mean that the data structure has some sort of mechanism
 that guarantees the tree remains nice and bushy with a short height, no
 matter which values it contains and in what order the values are inserted. If the tree was allowed to grow lopsided,
 even simple operations could become inefficient. (As an extreme example, a tree
 where each node has at most one child works like a linked list — not very
 efficient at all.)
 
 There are many ways to create self-balancing binary trees; in this section,
 we're going to implement the variant called *red-black trees*. This particular
 flavor needs to store a single extra bit of information in every node to
 implement the self-balancing part. That extra bit is the node's color, which
 can be either red or black.
 
 ![Figure 4.2: An example red-black tree.](Images/RedBlackTree@3x.png)
 
 A red-black tree always keeps its nodes arranged and colored so that the
 following properties are all true:
 
 1. The root node is black.
 2. Red nodes only have black children. (If they have any, that is.)
 3. Every path from the root node to an empty spot in the tree
    contains the same number of black nodes.
 
 Empty spots are places where new nodes can be added to the tree, i.e. where a
 node has no left or right child. To grow a tree one node larger, we just need
 to replace one of its empty spots with a new node.
 
 The first property is there to make our algorithms a little bit simpler;
 it doesn't really affect the tree's shape at all. The last two properties
 ensure that the tree remains nicely dense, where no empty spot in the tree is
 more than twice as far from the root node as any other.
 
 To fully understand these balancing properties, it's useful to play with them
 a little, exploring their edge cases. For example, it's possible to construct
 a red-black tree that consists solely of black nodes;
 the tree below is one example.
 
 ![Figure 4.3: An example red-black tree where every node is black.](Images/RedBlackTree-Black@3x.png)
 
 If we try to construct more examples, we'll soon realize that the third
 red-black property restricts such trees into a particular shape where all
 internal nodes have two children and all leaf nodes are on the same level.
 Trees with this shape are called *perfect trees* because they're so perfectly
 balanced and symmetrical. This is the ideal shape all balanced trees
 aspire to, because it puts every node as close to the root as possible.
 
 Unfortunately, it'd be unreasonable to require balancing algorithms to
 maintain perfect trees: indeed, it's only possible to construct perfect
 binary trees with certain node counts. There's no perfect binary tree with
 four nodes, for example.
 
 To make red-black trees practical, the third red-black property therefore uses
 a weaker definition of balancing, where red nodes aren't counted. However, to make sure
 things don't get *too* unruly, the second property limits the number of
 red nodes to something reasonable: it ensures that on any particular path in the tree, the number of red nodes will never exceed the number of black ones.
 
 <!-- begin-exclude-from-preview -->
 
 ## Algebraic Data Types
 
 Now that we have a rough idea of what red-black trees are supposed to be, let's
 get right into their implementation, starting with a node's color. This
 information is traditionally tucked inside an unused bit in the node's binary
 representation using low-level hacks so that it doesn't take up extra space.
 But we like clean, safe code, so we'll represent the color using two cases of a
 regular enumeration:
*/
public enum Color {
    case black
    case red
}
/*:
 > The Swift compiler may sometimes be able to tuck the color
 > value into such an unused bit on its own, without us having to do
 > anything. The binary layout of Swift types is much more flexible than
 > in C/C++/Objective-C, and the compiler has considerable freedom in
 > deciding how to pack things up. This is especially the case for enums
 > with associated values, where the compiler is often able to find
 > unused bit patterns to represent cases without allocating extra space
 > for distinguishing between them. For example, an `Optional` wrapping a
 > reference type fits into the same space as the reference itself. The
 > `Optional.none` case is represented by an (all-zero) bit pattern that's
 > never used by any valid reference. (Incidentally, the same all-zero
 > bit pattern represents the null pointer in C and the `nil` value in
 > Objective-C, allowing some measure of binary compatibility.)
 
 A tree itself is either empty, or it has a root node with a color, a value, and
 two children: left and right. Swift allows enum cases to include field values,
 which makes it possible to translate this description into a second enum type:
*/
public enum RedBlackTree<Element: Comparable> {
    case empty
    indirect case node(Color, Element, RedBlackTree, RedBlackTree)
}
/*:
 In real code, we'd usually give labels to the fields of a node so that their
 roles are clear. We keep them unnamed here only to prevent unfortunate line
 breaks in the code samples. Sorry about that.
 
 We have to use the `indirect case` syntax because the children of a node are
 trees themselves. The `indirect` keyword highlights the presence of recursive
 nesting to readers of our code, and it also allows the compiler to box node values
 into some hidden heap-allocated reference type. (It's necessary to do this to
 prevent trouble, like the compiler not being able to assign a specific storage
 size to values of the enum. Recursive data structures are tricky.)
 
 Enums with fields like this are Swift's way of defining [*algebraic data
 types*][adt], which (as we'll soon see) provide a particularly powerful and
 elegant way of building data structures.
 
 [adt]: https://en.wikipedia.org/wiki/Algebraic_data_type
 
 Having defined the skeleton of our new red-black tree type, we're now ready to
 move on to implementing `SortedSet` methods on it.
 
 
 ## Pattern Matching and Recursion
 
 When working with algebraic data types, we typically use pattern matching to
 break down the problem we want to solve into a number of distinct cases. Then
 we solve each of these cases one by one, often relying on recursion to solve a
 particular case in terms of the solution of a slightly smaller variant of the
 same problem.
 
 ### `contains`
 
 For example, let's see an implementation for `contains`. Our search tree stores
 values in a specific order, and we can rely on this to split the problem of
 finding an element into four smaller cases:
 
 1. If the tree is empty, then it doesn't contain any elements, so `contains` must return `false`.
 2. Otherwise, the tree must have a root node at the top. If the value stored there happens to equal the element we're looking for, then we know that the tree contains the element; `contains` should return `true` in this case.
 3. Otherwise, if the root value is greater than the element we're looking for, then the element is definitely not inside the right subtree. The tree contains the element if and only if the left subtree contains it.
 4. Otherwise, the root value is less than the element, so we only need to look inside the right subtree.
 
 We can translate this recipe directly into Swift using a `switch` statement:
*/
public extension RedBlackTree {
    func contains(_ element: Element) -> Bool {
        switch self {
        case .empty:
            return false
        case .node(_, element, _, _):
            return true
        case let .node(_, value, left, _) where value > element:
            return left.contains(element)
        case let .node(_, _, _, right):
            return right.contains(element)
        }
    }
}
/*:
 Swift's pattern matching syntax is a natural way to express these kinds of
 structural conditions. Most methods we define on `RedBlackTree` will have this
 exact same structure, although the details will of course be different.
 
 ### `forEach`
 
 In `forEach`, we want to call a closure on all elements inside the tree in
 ascending order. This is easy to do if the tree is empty: we don't need to do
 anything. Otherwise, we need to visit all elements inside the left subtree, then
 the element stored in the root node, and finally all elements inside the right
 subtree.
 
 This all lends itself nicely to another recursive method that uses a `switch`
 statement:
*/
public extension RedBlackTree {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        switch self {
        case .empty:
            break
        case let .node(_, value, left, right):
            try left.forEach(body)
            try body(value)
            try right.forEach(body)
        }
    }
}
/*:
 This example turned out to be even shorter than `contains`, but you can see it
 shares the same structure: a few pattern matching cases in a `switch` statement,
 flavored with occasional uses of recursion in the case bodies.
 
 This algorithm is doing a so-called *inorder walk* on the tree. It's useful to
 know this term; it may pop up at any time during polite dinner table
 conversation, provided you dine with the same kind of friends as I do. When
 we do an inorder walk in a search tree, we visit elements "in order," from
 smallest to largest.
 
 
 ## Tree Diagrams
 
 Next, we'll take a little detour to do an interesting custom implementation for
 `CustomStringConvertible`. (As I hope you remember, we've already written a
 generic version in the introduction.)
 
 When working on a new data structure, it's usually worth investing a
 little extra time to make sure we're able to print out the exact structure of
 our values in an easily understandable format. The investment usually pays back
 in spades by making debugging a lot easier. For red-black trees, we're going to
 *really* make an effort and use Unicode art to construct elaborate little tree
 diagrams.
 
 We start with a property that returns a symbolic representation for `Color`.
 Little black and white squares will do the job just fine:
*/
extension Color {
    public var symbol: String {
        switch self {
        case .black: return "■"
        case .red:   return "□"
        }
    }
}
/*:
 (Another option would be to use black and red emoji circles, i.e. ⚫️ and 🔴. They look a bit too loud to me, but I won't judge you if you like them. Use cats and dogs for all I care!)
 
 We'll use a clever adaptation of the `forEach` function to generate the diagram
 itself. To change things up a bit, I'll leave it up to you to figure out how it
 works. I promise it's not as tricky as it looks! (Hint: experiment with
 changing some of the string literals to see what changes in the resulting
 output below.)
*/
extension RedBlackTree: CustomStringConvertible {
    func diagram(_ top: String, _ root: String, _ bottom: String) -> String {
        switch self {
        case .empty:
            return root + "•\n"
        case let .node(color, value, .empty, .empty):
            return root + "\(color.symbol) \(value)\n"
        case let .node(color, value, left, right):
            return right.diagram(top + "    ", top + "┌───", top + "│   ")
                + root + "\(color.symbol) \(value)\n"
                + left.diagram(bottom + "│   ", bottom + "└───", bottom + "    ")
        }
    }

    public var description: String {
        return self.diagram("", "", "")
    }
}
/*:
 Let's see what `diagram` does for some simple tree values. `RedBlackTree` is
 just an enum, so we can construct arbitrary trees by manually nesting enum
 cases.
 
 1. An empty tree is printed as a small black dot. This is implemented by the first `case` pattern in the `diagram` method above:
*/
    let emptyTree: RedBlackTree<Int> = .empty
emptyTree
/*:
 2. A tree with a single node matches the second `case` pattern, so it's printed on a single line consisting of its color and value:
*/
    let tinyTree: RedBlackTree<Int> = .node(.black, 42, .empty, .empty)
tinyTree
/*:
 3. Finally, a tree with a root containing non-empty children matches the third case. Its description looks similar to the previous case, except the root node has grown left and right limbs displaying its children:
*/
    let smallTree: RedBlackTree<Int> = 
        .node(.black, 2, 
            .node(.red, 1, .empty, .empty), 
            .node(.red, 3, .empty, .empty))
smallTree
/*:
 Even more complicated trees are displayed, well, like trees:
*/
let bigTree: RedBlackTree<Int> =
    .node(.black, 9,
        .node(.red, 5,
            .node(.black, 1, .empty, .node(.red, 4, .empty, .empty)),
            .node(.black, 8, .empty, .empty)),
        .node(.red, 12,
            .node(.black, 11, .empty, .empty),
            .node(.black, 16,
                .node(.red, 14, .empty, .empty),
                .node(.red, 17, .empty, .empty))))
bigTree
/*:
 Isn't this neat? Working with algebraic data types can be so effortless that
 you sometimes don't even realize you're doing something that's supposed to be
 complicated.
 
 We now return to our regularly scheduled programming. Let's continue building
 our sorted set implementation.
 
 ## Insertion
 
 In `SortedSet`, we defined insertion as a mutating function. For the case of
 our red-black trees, however, it's going to be much easier to define a
 functional variant that returns a brand-new tree instead of modifying
 the existing one. Here's a suitable signature for it:

```swift
func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) 
```

 Given a function like this, we can implement mutating insertion by assigning
 the tree it returns to `self`:
*/
extension RedBlackTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) 
    {
        let (tree, old) = inserting(element)
        self = tree
        return (old == nil, old ?? element)
    }
}
/*:
 For `inserting`, we're going to implement a beautiful pattern matching algorithm
 first published by [Chris Okasaki in 1999][okasaki99-doi].
 
 [okasaki99-doi]: https://dx.doi.org/10.1017%2FS0956796899003494
 
 Remember that red-black trees need to satisfy three requirements:
 
 1. The root node is black.
 2. Red nodes only have black children. (If they have any, that is.)
 3. Every path from the root node to an empty spot in the tree
    contains the same number of black nodes.
 
 One way to ensure the first requirement is to just insert the element as if the
 requirement didn't exist. If the result happens to come out with a red root,
 then it's easy enough to paint it black, and doing this won't affect any of the
 other requirements. (The second requirement only cares about red nodes, so we
 could paint every node black, and it'd still hold. As for the third
 requirement: the root node is on every path inside the tree, so painting it
 black will consistently increment the number of black nodes on every path by
 one. Therefore, if the tree satisfied the third requirement before we painted
 its root black, then the repainted tree won't violate it either.)
 
 All this consideration leads us to define `inserting` as a short wrapper
 function dedicated to ensuring the first requirement. It delegates the actual
 insertion to some internal helper function we have yet to define:
*/
extension RedBlackTree {
    public func inserting(_ element: Element) -> (tree: RedBlackTree, existingMember: Element?) {
        let (tree, old) = _inserting(element)
        switch tree {
        case let .node(.red, value, left, right):
            return (.node(.black, value, left, right), old)
        default:
            return (tree, old)
        }
    }
}
/*:
 Let's tackle this `_insertion` method next. Its primary job is to find the
 correct place where the specified element can be inserted into the tree as a
 new leaf node. This task is similar to `contains`, because we need to follow
 the same path down the tree as we would when looking for an existing element. So
 it shouldn't come as a shock to find that `_insertion` and `contains` have the
 exact same structure; they just need to return *slightly* different things in
 each `case` statement.
 
 Let's go through each of the four cases one by one, explaining the code as we go:
*/
extension RedBlackTree {
    func _inserting(_ element: Element) -> (tree: RedBlackTree, old: Element?) 
    {
        switch self {
/*:
 First, to insert a new element into an empty tree, we simply need to create a
 root node with the specified value: 
*/
        case .empty:
            return (.node(.red, element, .empty, .empty), nil)
/*:
 Notably, this violates the first requirement, since we're creating a tree with
 a red root. But that's not a problem, since `inserting` will fix this after we
 return. Additionally, the other two requirements are fine.
 
 Let's move on to the second case! If the root node has the same value as the
 one we're trying to insert, then the tree already contains it, so we can safely
 return `self`, along with a copy of the existing member:
*/
        case let .node(_, value, _, _) where value == element:
            return (self, value)
/*:
 Since `self` was supposed to satisfy all requirements, returning it unmodified
 won't break them either.
 
 Otherwise, the value should be inserted into either the left or right subtree of
 the root node, depending on how it compares to the root value — so we need to
 do a recursive call. If the return value indicates the value wasn't already in
 the tree, then we need to return a copy of our root node, where the previous
 version of the same subtree is replaced by this new one. (Otherwise, we just
 return `self` again.)
*/
        case let .node(color, value, left, right) where value > element:
            let (l, old) = left._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, l, right), nil)

        case let .node(color, value, left, right):
            let (r, old) = right._inserting(element)
            if let old = old { return (self, old) }
            return (balanced(color, value, left, r), nil)
        }
    }
}
/*:
 The two cases above make calls to a mysterious `balanced` function before
 returning the new tree. This function is where the red-black magic happens.
 (The `_inserting` function is otherwise mostly identical to how we'd define
 insertion into a common everyday binary search tree; there's very little in it
 that's specific to red-black trees.)
 
 ## Balancing
 
 The job of the `balanced` method is to detect if a balancing requirement is
 broken, and if so, to fix the tree by cleverly rearranging its nodes and returning
 a tree that satisfies the criteria.
 
 The `_inserting` code above creates new nodes as red leaf nodes; in most cases,
 this is done in a recursive call, the result of which is then inserted as a child of
 an existing node. Which red-black requirements may be broken by this?
 
 The first requirement is safe, since it's about the root node, not a child (and
 we take care of the root in `inserting`, so here we can safely ignore it anyway).
 Since the third property doesn't care about red nodes, inserting a new red
 leaf node won't ever break it either. However, nothing in the code prevents us
 from inserting a red node under a red parent, so we may end up violating the second
 property.
 
 
 So `balanced` only needs to check the second requirement and somehow fix it
 without breaking the third. In a valid red-black tree, a red node always has a
 black parent; so when insertion breaks the second requirement, the result
 always matches one of the cases (1–4) below.
 
 ![All four situations in which a red node may have a red child after inserting a single element. The labels *x*, *y*, and *z* stand for values, while *a*, *b*, *c*, and *d* are (possibly empty) subtrees. If the tree matches any of the patterns 1–4, then its nodes need to be reorganized into the pattern R.](Images/BalancePatterns@3x.png)
 
 
 
 We can implement rebalancing by detecting if our tree matches one of these patterns after insertion,
 and if so, reorganize the tree so that it matches pattern R. This resulting
 pattern cleverly restores the second requirement without breaking the third.
 
 Can you guess which tool we're going to use to implement this?
 
 By some sort of amazing coincidence, this particular problem is an excellent
 demonstration of the power of pattern matching on algebraic data types.
 Let's start by turning the five diagrams in the figure above into Swift expressions.
 When we created our fancy Unicode tree descriptions, we saw how carefully
 constructed Swift expressions can be used to build small trees; now we just
 need to apply this knowledge to the following diagrams:
 
 ```
   1: .node(.black, z, .node(.red, y, .node(.red, x, a, b), c), d)
   2: .node(.black, z, .node(.red, x, a, .node(.red, y, b, c)), d)
   3: .node(.black, x, a, .node(.red, z, .node(.red, y, b, c), d))
   4: .node(.black, x, a, .node(.red, y, b, .node(.red, z, c, d)))
   R: .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
 ```
 
 At this point, we're essentially done! To get a correct implementation of the
 `balanced` function, we just need to take these expressions and bolt
 them onto a `switch` statement:

```swift
extension RedBlackTree {
    func balanced(_ color: Color, _ value: Element, _ left: RedBlackTree, _ right: RedBlackTree) -> RedBlackTree {
        switch (color, value, left, right) {
        case let (.black, z, .node(.red, y, .node(.red, x, a, b), c), d),
            let (.black, z, .node(.red, x, a, .node(.red, y, b, c)), d),
            let (.black, x, a, .node(.red, z, .node(.red, y, b, c), d)),
            let (.black, x, a, .node(.red, y, b, .node(.red, z, c, d))):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        default:
            return .node(color, value, left,  right)
        }
    }
}
```

 This is a remarkable way of programming.
 In essence, we translated the picture above directly into Swift
 in such a way that the five diagrams we used to explain the task are still
 recognizable in the code!
 
 There's a slight problem though. While the above is perfectly valid Swift
 code, unfortunately [it crashes version 4 of the Swift compiler][sr2924].
 To work around this bug, we need to handle each case separately, repeating the
 exact same body four times:
 
 [sr2924]: https://bugs.swift.org/browse/SR-2924
*/
extension RedBlackTree {
    func balanced(_ color: Color, _ value: Element, _ left: RedBlackTree, _ right: RedBlackTree) -> RedBlackTree {
        switch (color, value, left, right) {
        case let (.black, z, .node(.red, y, .node(.red, x, a, b), c), d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, z, .node(.red, x, a, .node(.red, y, b, c)), d):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, z, .node(.red, y, b, c), d)):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        case let (.black, x, a, .node(.red, y, b, .node(.red, z, c, d))):
            return .node(.red, y, .node(.black, x, a, b), .node(.black, z, c, d))
        default:
            return .node(color, value, left, right)
        }
    }
}
/*:
 This workaround dilutes the concentrated wonder of the original a little bit,
 but thankfully the magic still shines through. (And hopefully the bug will be fixed
 in a future compiler release.)
 
 To see if insertion actually works, let's create a red-black tree containing
 numbers from 1 to 20:
*/
var set = RedBlackTree<Int>.empty
for i in (1 ... 20).shuffled() {
    set.insert(i)
}
set
/*:
 It all seems to work fine! Hurray! We can see that the tree we get satisfies
 all three red-black tree properties.
 
 We shuffle the numbers before inserting them, so we get a brand-new variant of
 the tree each time we execute this code. The book's playground is perfect for
 trying this.
 
 ## Collection
 
 
 Implementing protocols like `Collection` is where algebraic data types start to
 get a little inconvenient to work with.  We have to define a suitable index
 type, and the easiest way to do this is to just use an element itself as the index,
 like so:
*/
extension RedBlackTree {
    public struct Index {
        fileprivate var value: Element?
    }
}
/*:
 The value is an optional because we'll use the `nil` value to represent the
 end index.
 
 Collection indices must be comparable. Thankfully, our elements are comparable too, which makes it easy to implement this requirement. The only tricky thing is that
 we must ensure the end index compares *greater* than anything else:
*/
extension RedBlackTree.Index: Comparable {
    public static func ==(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        return left.value == right.value
    }

    public static func <(left: RedBlackTree<Element>.Index, right: RedBlackTree<Element>.Index) -> Bool {
        if let lv = left.value, let rv = right.value { 
            return lv < rv 
        }
        return left.value != nil
    }
}
/*:
 Next, we implement specialized versions of the `min()` and `max()` extension
 methods of `Sequence` to retrieve the smallest and largest elements of a
 tree. We'll need these below to implement index advancement.
 
 The smallest element is the value stored in the leftmost node; here we use
 pattern matching and recursion to find it:
*/
extension RedBlackTree {
    func min() -> Element? {
        switch self {
        case .empty: 
            return nil 
        case let .node(_, value, left, _): 
            return left.min() ?? value
        }
    }
}
/*:
 Finding the largest element can be done in a similar way. However, to keep
 things interesting, here's a version of `max()` that rolls the recursion into
 a loop:
*/
extension RedBlackTree {
    func max() -> Element? {
        var node = self
        var maximum: Element? = nil
        while case let .node(_, value, _, right) = node {
            maximum = value
            node = right
        }
        return maximum
    }
}
/*:
 Notice how much more difficult it is to understand this code, compared to `min()`. Instead of
 using a simple expression to define the result, this version uses a `while` loop
 that keeps mutating some internal state. To see how it works, you have to run
 the code in your mind, figuring out how `node` and `maximum` change as the loop
 progresses. But fundamentally, these are just two different ways of expressing
 the same algorithm, and it makes sense to get used to both. The iterative
 version can sometimes run slightly faster, so by using it we can trade a little
 bit of readability in exchange for a little bit of additional performance. But
 it's usually easier to start with a recursive solution, and we can always rewrite
 the code if benchmarks tell us it'd be worth the price of decreased
 readability.
 
 Now that we have the `min()` and `max()` methods, we can start implementing `Collection`.
 
 Let's begin with the basics: `startIndex`, `endIndex`, and `subscript`:
*/
extension RedBlackTree: Collection {
    public var startIndex: Index { return Index(value: self.min()) }
    public var endIndex: Index { return Index(value: nil) }

    public subscript(i: Index) -> Element {
        return i.value!
    }
}
/*:
 `Collection` implementations should always document their rules about index
 invalidation. In our case, we could formally specify that an index, `i`, that was
 originally created for tree, `t`, is a *valid index* in some other tree, `u`, if
 and only if either `i` is the end index or the value `t[i]` is also contained
 in `u`. This definition allows people to reuse some indices after certain tree
 mutations, which can be a useful feature. (This rule is different than, say,
 the way `Array` indices work, because in our case, the index is based on the
 value, not the position, of a particular member. This is a slightly unusual way
 to define index invalidation, but it doesn't violate `Collection`'s semantic
 requirements.)
 
 Our subscript implementation is particularly short because it simply unwraps
 the value inside the index. However, this isn't very nice, because it doesn't
 verify that the value stored in the index is actually inside the tree. We can
 subscript any tree with any index, and we'll get a result that may or may not
 make sense. While `Collection` implementations are free to set their own rules
 about index invalidation, they should make some effort to verify that those
 rules are followed at runtime. Subscripting a collection with an invalid index
 is a serious coding error best handled by trapping rather than
 silently returning some weird value. But this will have to do for now, and I
 promise we'll do better from here on out.
 
 Unfortunately, `startIndex` calls `min()`, which is a logarithmic
 operation. This is a problem because `Collection` requires `startIndex` and
 `endIndex` implementations to finish in constant time. One relatively simple
 way to fix this would be to cache the minimum value in or near the root of the
 tree, by, say, introducing a simple wrapper struct around the tree value. (I'll
 leave implementing this as an exercise for you, Dear Reader. Or we could just
 move on and pretend this paragraph never happened!)
 
 Anyway, we now need to implement `index(after:)`, which reduces to finding the
 smallest element inside the tree that's larger than a particular value. We'll
 write a utility function to do this. To keep our promise about index
 validation, the function will also return a boolean value indicating whether or
 not the element originally stored in the index is inside the tree so that we
 can set a precondition for it:
*/
extension RedBlackTree: BidirectionalCollection {
    public func index(after i: Index) -> Index {
        let v = self.value(following: i.value!)
        precondition(v.found)
        return Index(value: v.next)
    }
}
/*:
 The `value(following:)` function is yet another subtle variation on the theme of `contains`. Its logic is quite tricky though, and it deserves a second look:
*/
extension RedBlackTree {
    func value(following element: Element) -> (found: Bool, next: Element?) {
        switch self {
            case .empty:
                return (false, nil)
            case .node(_, element, _, let right):
                return (true, right.min())
            case let .node(_, value, left, _) where value > element:
                let v = left.value(following: element)
                return (v.found, v.next ?? value)
            case let .node(_, _, _, right):
                return right.value(following: element)
        }
    }
}
/*:
 The trickiest part is what happens in case 3, when the element is inside the
 left subtree. Usually the element following it is in the same subtree, so a
 recursive call will return the correct result. But when `element` is the maximum
 value in `left`, the call returns `(true, nil)`. In this case, we need to
 return the value following the `left` subtree, which is the value stored in the
 parent node itself.
 
 We also need to be able to go the other way to find the preceding value. To
 keep things interesting, we'll do this variant using iteration rather than
 recursion:
*/
extension RedBlackTree {
    func value(preceding element: Element) -> (found: Bool, next: Element?) {
        var node = self
        var previous: Element? = nil
        while case let .node(_, value, left, right) = node {
            if value > element {
                node = left
            }
            else if value < element {
                previous = value
                node = right
            }
            else {
                return (true, left.max() ?? previous)
            }
        }
        return (false, previous)
    }
}
/*:
 Note how the purpose of the variable `previous` here is equivalent to the
 application of the nil-coalescing operator `??` in the original tricky case
 above. (Such post-processing of recursive results can't be directly converted
 into iterative code, but we can always eliminate post-processing by adding new
 parameters to the function so that it can do the processing before returning
 from the recursive call. These extra parameters become variables like
 `previous` in the iterative code.)
 
 To complete the implementation of `BidirectionalCollection`, we just need to
 add a method that calls `value(preceding:)` to find the predecessor of an index:
*/
extension RedBlackTree {
    public func index(before i: Index) -> Index {
        if let value = i.value {
            let v = self.value(preceding: value)
            precondition(v.found)
            return Index(value: v.next)
        }
        else {
            return Index(value: max()!)
        }
    }
}
/*:
 Defining `index(after:)` and `index(before:)` this way is definitely more
 complicated than in our previous efforts. The end result will also probably be
 quite slow at runtime — all these recursive lookups make the algorithms cost
 $O(\log n)$ time instead of the more typical $O(1)$. This doesn't violate any
 `Collection` rules; it just makes iteration using indexing slower than usual.
 
 Finally, let's see an implementation for `count`; it's yet another exciting
 opportunity for practicing pattern matching and recursion:
*/
extension RedBlackTree {
    public var count: Int {
        switch self {
        case .empty:
            return 0
        case let .node(_, _, left, right):
            return left.count + 1 + right.count
        }
    }
}
/*:
 If we were to forget to specialize `count`, its default implementation would count the
 number of steps between `startIndex` and `endIndex`, and that would be
 considerably slower than this — $O(n\log n)$ vs. our $O(n)$. But this
 implementation is nothing to write home about either: it still has to visit every node in
 the tree.
 
 > We could speed this up by having all nodes remember the number of
 > elements under them, which would turn our tree into a so-called *order
 > statistic tree*. (We'd need to update insertion and any other
 > mutations to carefully maintain this extra information. Using this
 > kind of extension is called *augmenting the tree*. Adding element
 > counts is just one of many useful ways a tree can be augmented.)
 >
 > Order statistic trees provide a number of interesting benefits aside from
 > speeding up `count`. For example, it's possible to find the $i$th
 > smallest/largest value in such a tree in just $O(\log n)$ steps, for any
 > $i$. However, this doesn't come for free: we'd pay for it with increased
 > memory overhead and code complexity.
 
 And there you have it, `RedBlackTree` is now a `BidirectionalCollection`,
 complete with all the extensions we know and love from stdlib:
*/
let evenMembers = set.lazy.filter { $0 % 2 == 0 }.map { "\($0)" }.joined(separator: ", ")
evenMembers
/*:
 To finish things off, we'll implement `SortedSet`. Luckily, we've already
 fulfilled all its requirements except for the empty initializer — and adding
 that one is no big deal either:
*/
extension RedBlackTree: SortedSet {
    public init() {
        self = .empty
    }
}
/*:
 All done! For (almost) finishing this chapter, you deserve a challenge: try implementing
 `SetAlgebra`'s `remove(_:)` operation. Pro tip: ignore red-black tree requirements
 in the first version you write. Once you have working code, start thinking
 about how to rebalance the tree after a deletion. (It's fair game to look it up
 on the web or in your favorite algorithm book; it's challenging enough to
 implement this stuff while looking at a reference!)
 
 ## Performance
 
 We expect most operations on `RedBlackTree` to take $O(\log n)$ time, except
 `forEach`, which should be $O(n)$ — it performs one recursive call for each
 node (and empty slot) inside the tree.
 Executing our usual benchmarks proves this to be largely correct;
 the chart below plots the results produced on my Mac.
 
 ![Benchmark results for `RedBlackTree` operations. The plot shows input size vs. average execution time for a single iteration on a log-log chart.](Images/RedBlackTreeBenchmark.png)
 
 The curves are rather noisy. This is because red-black trees allow quite a
 large variation on the shape of the tree. The depth of the tree depends not
 just on the number of elements, but also (to a much lesser extent) on the
 (random) order we insert them. The performance of most operations is largely
 proportional to the tree's depth, so we have shaky curves. But this is
 small-scale noise; it doesn't affect the overall shape.
 
 Iteration using `forEach` is an $O(n)$ operation, so its amortized plot should
 be a horizontal line. Its middle part indeed looks flat, but somewhere around 20,000
 or so elements, it gradually slows down and starts to grow at a logarithmic
 rate. This is because even though `forEach` visits elements in increasing
 order, their locations in memory are essentially random: they were determined at the
 time the nodes were originally allocated for insertion. Red-black trees are
 terrible at keeping neighboring elements close to each other, and this makes
 them rather ill-suited for the memory architecture in today's computers.
 
 But `forEach` is still much faster than `for-in`; incrementing an index is a
 relatively complicated $O(\log n)$ operation that essentially needs to look up
 an element from scratch, while the inorder walk always knows exactly where to
 find the next value.
 
 The widening gap between `contains` and `for-in` is another demonstration of
 the effects of caching. The successive `index(after:)` calls in `for-in` visit
 new elements at random memory locations, but most of the path stays the same,
 so `for-in` is still relatively cache-friendly. Not so with `contains`, where
 every iteration visits a brand-new random path in the tree — memory accesses
 are rarely repeated, making the cache ineffective. 
 
 To see just how slow indexing-based iteration is in `RedBlackTree`, it's
 useful to compare it to our previous implementations. As you can see in
 the chart below,
 a `for-in` loop over the elements of a `RedBlackTree` is 200–1,000 times slower
 than over the elements of a `SortedArray`, and the curves are slowly diverging,
 proving the expected $O(\log n)$ vs. $O(1)$ algorithmic complexities.
 
 ![Comparing the performance of three `index(after:)` implementations.](Images/Iteration3.png)
 
 
 We'll fix most of this slowdown in future chapters, but at least some of it
 is due to a (seemingly) unavoidable tradeoff between lookups and mutations:
 iteration is fastest when elements are stored in huge contiguous buffers, but
 such buffers are also the least convenient data structures for doing fast
 insertions. Any optimization that improves insertion performance is likely to
 involve breaking storage up into smaller chunks, which, as a side effect, makes iteration
 slower.
 
 In red-black trees, elements are stored individually wrapped into separate
 heap-allocated tree nodes, which is probably the worst way to store elements if
 you want to quickly iterate over them. It doesn't help that in this particular
 design, we use an $O(\log n)$ algorithm to find the next index, but, perhaps
 surprisingly, this isn't where the `for` loop spends most of its time:
 replacing the `for-in` benchmark with `forEach` still leaves `RedBlackTree`
 90–200 times slower than `SortedArray`.
 
 Well, that's a bummer. But insertion gets faster, right? Well, let's see!
 The chart below compares the performance of `RedBlackTree.insert` to our previous implementations.
 
 ![Comparing the performance of three `insert` implementations.](Images/Insertion3.png)
 
 We can see that at large sizes, the algorithmic advantage of red-black trees
 clearly pays off. Inserting 4 million elements into a red-black tree
 is about 50–100 times faster than a sorted array. (It takes just 33 *seconds*, which
 compares nicely to `OrderedSet`'s 26 *minutes*.) If we added more elements, the
 gap would keep widening even further.
 
 However, `SortedArray` clearly beats `RedBlackTree` when we have less than about
 50,000 elements. Sorted arrays have much better locality of reference than
 red-black trees: even though we need to perform more memory accesses to insert
 a new element into a sorted array, these accesses are very close together. As
 long as we fit in the various caches (L1, L2, TLB, what have you), the
 regularity of these accesses compensates for their larger number.
 
 The growth rate of the `RedBlackTree.insert` curve is the best we can
 do — there's no data structure that solves the general `SortedSet` problem
 with better asymptotic performance. But this doesn't mean there's no room for
 improvement!
 
 To make insertions faster, we need to start optimizing our implementation,
 speeding it up by some constant factor. This won't change the shape of its
 benchmark curve, but it will uniformly push it downward on the log-log chart.
 
 Ideally, we want to push the `insert` curve down far enough so that it reaches
 or exceeds `SortedArray` performance for all sizes while maintaining the
 logarithmic growth rate.
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/