/*:
 [Previous page](@previous)

 # B-Trees
 
 
 The raw performance of a small sorted array seems impossible to beat. So let's
 not even try; instead, let's build a sorted set entirely out of small sorted
 arrays! 
 
 It's easy enough to get started: we just insert elements into a single array
 until we reach some predefined maximum size. Let's say we want to keep our
 arrays below five elements and we've already inserted four values:
 
 ![](Images/BTree1@3x.png)
 
 If we now need to insert the value 10, we get an array that's too large:
 
 ![](Images/BTree2@3x.png)
 
 We can't keep it like this, so we have to do something. One option is to cut
 the array into two halves, extracting the middle element to serve as a sort of
 separator value between them:
 
 ![](Images/BTree3@3x.png)
 
 Now we have a cute little tree structure with leaf nodes containing small
 sorted arrays. This seems like a promising approach: it combines sorted arrays
 and search trees into a single unified data structure, hopefully giving us
 array-like super-fast insertions at small sizes, all while retaining tree-like
 logarithmic performance for large sets. Synergy!
 
 Let's see what happens when we try adding more elements. We can keep inserting
 new values in the two leaf arrays until one of them gets too large again:
 
 ![](Images/BTree4@3x.png)
 
 When this happens, we need to do another split, giving us three arrays and two
 separators:
 
 ![](Images/BTree5@3x.png)
 
 What should we do with those two separator values? We store all other elements
 in sorted arrays, so it seems like a reasonable idea to put these separators in
 a sorted array of their own:
 
 ![](Images/BTree6@3x.png)
 
 So apparently each node in our new array-tree hybrid will hold a small sorted
 array. Nice and consistent; I love it so far.
 
 Now let's say we want to insert the value 20 next. This goes in the rightmost
 array, which already has four elements — so we need to do another split,
 extracting 16 from the middle as a new separator. No biggie, we can just
 insert it into the array at the top:
 
 ![](Images/BTree7@3x.png)
 
 Lovely! We can keep going like this; inserting 25, 26, and 27 overflows the rightmost array again, extracting the new separator, 25:
 
 ![](Images/BTree8@3x.png)
 
 However, the top array is now full, which is worrying. Let's say we insert 18,
 21, and 22 next, so we end up with the situation below:
 
 ![](Images/BTree9@3x.png)
 
 What next? We can't leave the separator array bloated like this. Previously, we
 handled oversized arrays by splitting them — why not try doing the same now?
 
 ![](Images/BTree10@3x.png)
 
 Oh, how neat: splitting the second-level array just adds a third level to our
 tree. This gives us a way to keep inserting new elements indefinitely; when the
 third-level array fills up, we can just add a fourth level, and so on, ad
 infinitum:
 
 ![](Images/BTree11@3x.png)
 
 We've just invented a brand-new data structure! This is so exciting.
 
 Unfortunately, it turns out that [Rudolf Bayer and Ed McCreight already had the
 same idea][bayer72] way back in 1971, and they named their invention *B-tree*.
 What a bummer! I wrote an entire book to introduce a thing that's almost half a
 century old. How embarrassing. 
 
 Fun fact: red-black trees were actually derived from a special case of B-trees
 in 1978. These are all ancient data structures.
 
 [bayer72]: https://dx.doi.org/10.1007%2Fbf00288683
 
 ## B-Tree Properties
 
 As we've seen, *B-trees* are search trees like red-black trees, but their
 layout is different. In a B-tree, nodes may have hundreds (or even thousands)
 of children, not just two. The number of children isn't entirely unrestricted,
 though: this number must fit inside a certain range.
 
 The maximum number of children a node may have is determined when the tree is
 created — this number is called the *order* of a B-tree. (The order of a
 B-tree has nothing to do with the ordering of its elements.) Note that the
 maximum number of elements stored in a node is one less than the tree's order.
 This can be a source of off-by-one indexing errors, so it's important to keep
 in mind as we work on B-tree internals.
 
 In the previous section, we built an example B-tree of order 5. In practice,
 the order is typically between 100 and 2,000, so 5 is unusually low. However,
 nodes with 1,000 children wouldn't easily fit on the page; it's easier to
 understand B-trees by drawing toy examples.
 
 To help in finding our way inside the tree, each internal node stores one element
 between each of its children, similar to how a node in a red-black tree
 contains a single value sorted between its left and right subtrees. So a
 B-tree node with 1,000 children will contain 999 elements neatly sorted in
 increasing order.
 
 To keep lookup operations fast, B-trees maintain the following balancing
 invariants:
 
 1. **Maximum size:** All nodes store a maximum of `order - 1` elements, sorted in increasing order.
 
 2. **Minimum size:** Non-root nodes must never be less than half full, i.e. the number of elements in all nodes except the root node must be at least `(order - 1) / 2`.
 
 3. **Uniform depth:** All leaf nodes must be at the same depth in the tree, counting from the root node at the top.
 
 Note that the last two properties are a natural consequence of the way we do
 insertions; we didn't have to do anything special to prevent nodes from
 getting too small or to make sure all leaves are on the same level. (These
 properties are much harder to maintain in other B-tree operations, though. For
 instance, removing an element may result in an undersized node that needs to be
 fixed.)
 
 According to these rules, nodes in a B-tree of order 1,000 will hold anywhere
 between 499 and 999 elements (inclusive). The single exception is the root node,
 which isn't constrained by the lower bound: it may contain 0 to 999 elements.
 (This is so we can create B-trees with, say, less than 499 elements.)
 Therefore, a single B-tree node on its own may have the same number of elements
 as a red-black tree that is *10–20 levels* deep!
 
 Storing so many elements in a single node has two major advantages:
 
 1. **Reduced memory overhead.** Each value in a red-black tree is stored in a separate, heap-allocated node that also includes a pointer to a method lookup table, its reference count, and the two references for the node's left and right children. Nodes in a B-tree store elements in bulk, which can considerably reduce memory allocation overhead. (The exact savings depends on the size of the elements and the order of the tree.)
 
 2. **Access patterns better suited for memory caching.** B-tree nodes store their elements in small contiguous buffers. If the buffers are sized so that they fit well within the L1 cache of the CPU, operations working on them can be considerably faster than the equivalent code operating on red-black trees, the values of which are scattered all over the heap.
 
 To understand how dense B-trees really are, consider that adding an extra level
 to a B-tree multiplies the maximum number of elements it may store by its order.
 For example, here's how the minimum and maximum element counts grow as we increase the depth of a B-tree of order 1,000:
 
 ```
  Depth          Minimum size              Maximum size
 ────────────────────────────────────────────────────────
      1                     0                       999
      2                   999                   999 999
      3               499 999               999 999 999
      4           249 999 999           999 999 999 999
      5       124 999 999 999       999 999 999 999 999
      6    62 499 999 999 999   999 999 999 999 999 999
      ⋮                     ⋮                         ⋮ 
      n   2*⎣order/2⎦^(n-1)-1               order^n - 1
 ```
 
 Clearly, we'll rarely, if ever, work with B-trees that are more than a handful of
 levels deep. Theoretically, the depth of a B-tree is $O(\log n)$, where $n$ is
 the number of elements. But the base of this logarithm is so large that, given
 the limited amount of memory available in any real-world computer, it's in
 fact not too much of a stretch to say that B-trees have $O(1)$ depth for any
 input size we may reasonably expect to see in practice. 
 
 > This last sentence somehow seems to make sense, even though the same
 > line of thinking would lead me to say that any practical algorithm
 > runs in $O(1)$ time, with the constant limit being my remaining
 > lifetime — obviously, I don't find algorithms that finish after my
 > death very practical at all. On the other hand, you could arrange
 > all particles in the observable universe into a 1,000-order B-tree
 > that's just 30 levels or so deep; so it does seem rather pointless and
 > nitpicky to keep track of the logarithm.
 
 Another interesting consequence of such a large fan-out is that in B-trees, the
 *vast* majority of elements are stored in leaf nodes. Indeed, in a B-tree of
 order 1,000, at least 99.8% of elements will always reside in leaves. Therefore,
 for operations that process B-tree elements in bulk (such as iteration), we
 mostly need to concentrate our optimization efforts on making sure leaf nodes
 are processed fast: the time spent on internal nodes often won't even
 register in benchmarking results. 
 
 Weirdly, despite this, the number of nodes in a B-tree is still technically
 proportional to the number of its elements, and most B-tree algorithms have the
 same "big-O" performance as the corresponding binary tree code. In a way,
 B-trees play tricks with the simplifying assumptions behind the big-O notation:
 constant factors often do matter in practice. This should be no surprise by
 now. After all, if we didn't care about constant factors, we could've ended
 this book after the chapter on `RedBlackTree`!
 
 <!-- begin-exclude-from-preview -->
 
 ## Basic Definitions
 
 Enough talking, let's get to work!
 
 We begin implementing B-trees by defining a public wrapper struct around a root
 node reference, just like we did in `RedblackTree2`:
*/
public struct BTree<Element: Comparable> {
    fileprivate var root: Node

    init(order: Int) {
        self.root = Node(order: order)
    }
}
/*:
 In `RedblackTree2`, `root` was an optional reference so that empty trees didn't need
 to allocate anything. Making the root non-optional will make our code a little
 bit shorter though, and this time brevity makes sense.
 
 The node class needs to hold two buffers: one for storing elements, and the other
 for storing child references. The simplest approach is to use arrays, so let's
 start with that.
 
 To make it easier to test our tree, the tree order is not a compile-time
 constant: we're able to customize it using the initializer above. To
 accommodate this, we'll store the order inside every node as a read-only stored
 property, for easy access:
*/
extension BTree {
    final class Node {
        let order: Int
        var mutationCount: Int64 = 0
        var elements: [Element] = []
        var children: [Node] = []

        init(order: Int) {
            self.order = order
        }
    }
}
/*:
 We also added the `mutationCount` property from the previous chapter. As
 promised, storing a per-node mutation count is now a lot less wasteful — a
 typical node will contain several kilobytes of data, so adding an extra 8 bytes
 won't matter at all:
 
 The figure below
 shows how our example B-tree would be represented as a `BTree`. Note the
 arrangement of indices in the `elements` and `children` arrays: for all `i` in
 `0 ..< elements.count`, the value `elements[i]` is larger than any value in
 `children[i]`, but less than all values in `children[i + 1]`.
 
 ![Figure 6.1: The example B-tree, as represented by `BTree`.](Images/BTreeImplementation@3x.png)
 
 
 ## The Default Initializer
 
 It's nice that we allow the user to set a custom tree order, but we also need
 to define a parameterless initializer for `SortedSet`. What order should we use
 by default?
 
 One option is to just set a concrete default in the code:

```swift
extension BTree {
    public init() { self.init(order: 1024) }
}
```

 However, we can do better than that. Benchmarking indicates that B-trees are
 fastest when the maximum size of the element buffer is about a quarter of the
 size of the L1 memory cache inside the CPU. Darwin OS (the kernel
 underlying all of Apple's operating systems) provides a `sysctl` query for
 getting the size of the cache, while Linux has a `sysconf` query for the same.
 Here's one way to access these from Swift:
*/
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif

public let cacheSize: Int? = {
    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        var result: Int = 0
        var size = MemoryLayout<Int>.size
        let status = sysctlbyname("hw.l1dcachesize", &result, &size, nil, 0)
        guard status != -1 else { return nil }
        return result
    #elseif os(Linux)
        let result = sysconf(Int32(_SC_LEVEL1_DCACHE_SIZE))
        guard result != -1 else { return nil }
        return result
    #else
        return nil // Unknown platform
    #endif
}()
/*:
 > There are lots of other `sysctl` names on Darwin; you can get a list
 > of the most popular and useful ones by typing `man 3 sysctl` in a
 > Terminal window.  Also, `sysctl -a` gets you a full list of every
 > available query along with their current values. On Linux, `getconf
 > -a` gets you a similar list, and the `confnames.h` header file lists
 > the symbolic names you can use as a parameter for `sysconf`.
 
 Once we know the cache size, we can use it to define the no-params initializer using the standard library's `MemoryLayout` construct to find the number
 of bytes an element needs inside a contiguous memory buffer:
*/
extension BTree {
    public init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)
        self.init(order: Swift.max(16, order))
    }
}
/*:
 If we can't determine the cache size, we use a reasonable-looking default
 value. The call to `max` ensures that we'll have an adequately bushy tree even
 if the elements are huge.
 
 ## Iteration with `forEach`
 
 Let's see what `forEach` looks like in a B-tree. Like before, the wrapper
 struct's `forEach` method simply forwards the call to the root node:
*/
extension BTree {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}
/*:
 But how do we visit all elements under a node? Well, if the node is a leaf
 node, we just have to call `body` on all its elements. If the node has
 children, we need to interleave element visits with recursive calls to
 visit each of the child nodes, one by one:
*/
extension BTree.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if children.isEmpty {
            try elements.forEach(body)
        }
        else {
            for i in 0 ..< elements.count {
                try children[i].forEach(body)
                try body(elements[i])
            }
            try children[elements.count].forEach(body)
        }
    }
}
/*:
 Note that elements under the first child have values that are less than the
 first element, so we need to start with a recursive call. Also, there's an
 extra child beyond the last element which contains elements that are larger than it is — we
 have to add an additional call to cover it as well.
 
 ## Lookup Methods
 
 In order to find a specific element in a B-tree, we first need to write a
 utility method for finding an element inside a particular node.
 
 Since the elements inside a node are stored in a sorted array, this task
 is reduced to the same binary search algorithm we wrote for `SortedArray`. To
 make things easier, this version of the function also incorporates the final
 membership test:
*/
extension BTree.Node {
    internal func slot(of element: Element) -> (match: Bool, index: Int) {
        var start = 0
        var end = elements.count
        while start < end {
            let mid = start + (end - start) / 2
            if elements[mid] < element {
                start = mid + 1
            }
            else {
                end = mid
            }
        }
        let match = start < elements.count && elements[start] == element
        return (match, start)
    }
}
/*:
 We're going to call indices inside a node *slots*, in order to differentiate them from
 the collection indices we'll define later. (A slot may be used as an index
 in either array — `elements` or `children` — inside the node.)
 
 We now have a way to calculate slots, which is exactly what we need to write an
 implementation for `contains`. Once again, the wrapper struct just forwards the
 call to the root node:
*/
extension BTree {
    public func contains(_ element: Element) -> Bool {
        return root.contains(element)
    }
}
/*:
 `Node.contains` starts by calling `slot(of:)`. If it finds a matching
 slot, then the element we're looking for is definitely in the tree, so
 `contains` should return `true`. Otherwise, we can use the returned index value to
 narrow the search to a specific child node:
*/
extension BTree.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)
        if slot.match { return true }
        guard !children.isEmpty else { return false }
        return children[slot.index].contains(element)
    }
}
/*:
 As we can see, B-trees combine sorted array algorithms and search tree
 algorithms into something new and exciting. (Given their age, calling B-trees
 *new* might be a stretch, but they're definitely exciting, aren't they?)
 
 ## Implementing Copy-On-Write
 
 The first cut of COW for B-trees will use the same sort of helper methods
 we've written like a billion times by now. The helper for the root node is
 especially boring:
*/
extension BTree {
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}
/*:
 Yawn!
 
 The `clone` method needs to do a shallow copy of the node properties. Note
 that `elements` and `children` are arrays, so they have their own
 implementation for COW. This is somewhat redundant in this case, but it does
 make our code shorter:
*/
extension BTree.Node {
    func clone() -> BTree<Element>.Node {
        let clone = BTree<Element>.Node(order: order)
        clone.elements = self.elements
        clone.children = self.children
        return clone
    }
}
/*:
 We don't need to copy the mutation counter, because we'll never compare its
 value between different nodes: it's only used to differentiate between
 versions of one particular node instance.
 
 Children are stored in an array rather than as individual properties, so their
 COW helper is slightly more interesting because we need to add a parameter that tells
 the function which child we intend to mutate later:
*/
extension BTree.Node {
    func makeChildUnique(at slot: Int) -> BTree<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else {
            return children[slot]
        }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}
/*:
 Luckily, Swift arrays include super-secret special magic sauce so that their
 subscripts allow in-place mutation of their elements. The same magic enables
 `isKnownUniquelyReferenced` to keep working even though we're calling it on a
 subscript expression and not a simple stored property. (Unfortunately, it's not
 yet possible to provide these so-called *mutating addressors* in our own
 collections; the technology behind them is immature and is only available
 to the standard library.)
 
 ## Utility Predicates
 
 Before we move on, it's worth defining a couple of predicate
 properties on node values:
*/
extension BTree.Node {
    var isLeaf: Bool { return children.isEmpty }
    var isTooLarge: Bool { return elements.count >= order }
}
/*:
 We'll use the `isLeaf` property to determine if an instance is a leaf node,
 while `isTooLarge` returns true if the node has too many elements and must be split.
 
 ## Insertion
 
 It's time to implement insertion. We'll follow the same procedure we outlined in the introduction of this chapter; we just need to translate it into working Swift code. 
 
 We'll start by defining a simple struct that consists of an element and a node.
 I like to call this construct a *splinter*:
*/
extension BTree {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}
/*:
 The `separator` value of a splinter must be less than any of the elements
 inside its `node`. A splinter is like a thin slice of a node: it consists of a
 single element and the child node that immediately follows it. Hence the name!
 
 Next, we'll define a method that splits a node in half, extracting half of the
 elements into a new splinter:
*/
extension BTree.Node {
    func split() -> BTree<Element>.Splinter {
        let count = self.elements.count
        let middle = count / 2

        let separator = self.elements[middle]

        let node = BTree<Element>.Node(order: order)
        node.elements.append(contentsOf: self.elements[middle + 1 ..< count])
        self.elements.removeSubrange(middle ..< count)
        
        if !isLeaf {
            node.children.append(contentsOf: self.children[middle + 1 ..< count + 1])
            self.children.removeSubrange(middle + 1 ..< count + 1)
        }
        return .init(separator: separator, node: node)
    }
}
/*:
 The only tricky aspect in this function is index management: it's easy to make
 an off-by-one error somewhere and leave the tree broken.
 
 ![Figure 6.2: The result of splitting an oversized node with values 4-8. The `split()` operation returns a splinter with a new node containing elements 7 and 8, leaving the original node with elements 4 and 5.](Images/BTreeSplit@3x.png)
 
 Let's see how we can use splinters and splitting to insert a new element into a
 node:
*/
extension BTree.Node {
    func insert(_ element: Element) -> (old: Element?, splinter: BTree<Element>.Splinter?) {
/*:
 The method starts by finding the slot in the node corresponding to the new
 element. If the element is already there, it just returns the value without
 modifying anything:
*/
        let slot = self.slot(of: element)
        if slot.match {
            // The element is already in the tree.
            return (self.elements[slot.index], nil)
        }
/*:
 Otherwise, it needs to actually insert it, so it must increment the mutation counter:
*/
        mutationCount += 1
/*:
 Inserting a new element into a leaf node is simple: we just need to insert it
 at the correct slot in the `elements` array. However, the extra element may
 make the node too big. When that happens, we cut it in half using `split()` and
 return the resulting splinter:
*/
        if self.isLeaf {
            elements.insert(element, at: slot.index)
            return (nil, self.isTooLarge ? self.split() : nil)
        }
/*:
 If the node has children, then we need to make a recursive call to insert it
 into the child at the correct slot. `insert` is a mutating method, so we must
 call `makeChildUnique(at:)` to make a COW copy when necessary. If the recursive
 `insert` call returns a splinter, we must insert it into `self` at the slot
 we already calculated:
*/
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)
        guard let s = splinter else { return (old, nil) }
        elements.insert(s.separator, at: slot.index)
        children.insert(s.node, at: slot.index + 1)
        return (nil, self.isTooLarge ? self.split() : nil)
    }
}
/*:
 So if we insert an element with a path in the B-tree that has full nodes at its end,
 then `insert` triggers a cascade of splits, propagating upward from the
 insertion point toward the root of the tree. 
 
 If all nodes on the path are full, then the root node itself gets split. When
 that happens, we need to add an extra level to the tree — which is done by creating a new root
 node one level above the previous one — containing the old root and the
 splinter. The best place to do this is in the public `insert` method inside the
 `BTree` struct, though we must remember to call `makeRootUnique` before mutating anything in the tree:
*/
extension BTree {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let splinter = splinter {
            let r = Node(order: root.order)
            r.elements = [splinter.separator]
            r.children = [root, splinter.node]
            self.root = r
        }
        return (old == nil, old ?? element)
    }
}
/*:
 That's all it takes to insert elements into a B-tree. The code is definitely
 not as elegant as `RedBlackTree`, but I think it's a great deal nicer than
 what we had in `RedblackTree2`. 
 
 Benchmarking insertion performance gets us
 the chart below.
 For small sets, we're now definitely within shooting distance of `SortedArray`:
 `BTree.insert` is just 10–15% slower. Even better, for large sets, the same
 code also improves on `RedblackTree2`'s insertion speed by a factor of 3.5! Creating
 a `BTree` by randomly inserting 4 million individual elements takes just three
 seconds.
 
 ![Figure 6.3: Comparing the performance of five different implementations for `SortedSet.insert`.](Images/Insertion5.png)
 
 As a balanced search tree, `B-tree.insert` has the same $O(\log n)$ asymptotic
 performance as `RedBlackTree` and `RedblackTree2`, but it also incorporates the
 memory access patterns of `SortedArray`, leading to a dramatic speedup for all
 input sizes, big and small. Sometimes combining two data structures gets us a
 third that's more than just the sum of its parts!
 
 ## Implementing Collection
 
 The biggest design challenge in implementing `Collection` is to come up with a
 nice index type. For B-trees, we're going to follow in `RedblackTree2`'s footsteps
 and have each index contain a full path inside the tree.
 
 ### B-Tree Paths
 
 A path inside a B-tree can be represented by a series of slots starting with
 the root node. But to make things more efficient, we'll also include references
 to all the nodes along the path.
 
 Indices must not contain strong references to parts of the collection. In
 `RedblackTree2`, we initially satisfied this requirement using zeroing weak
 references. This time, we'll apply what we learned at the end of the last
 chapter, and we'll use unsafe unowned references instead. As we've seen, these
 have no reference counting overhead, so they're a tiny bit faster. This small
 advantage really adds up in our iteration microbenchmark: for `RedblackTree2`, it led
 to a 200% speedup.
 
 In exchange for raw performance, the language provides absolutely no safety net
 for dereferencing `unowned(unsafe)` references; their targets may not exist
 anymore, or they may contain some data that's not what we expect. They work similar to C
 pointers in this respect.
 
 This isn't a problem for valid indices, as their trees are still in the exact
 same state as they were when they were created. But we have to be extra careful
 with invalid indices, as they may have broken node references on their path.
 Looking at the target of a broken record results in undefined behavior. The app may crash,
 or it may silently produce corrupt data. (This is different than simple
 `unowned` references, which still do a little bit of reference counting to ensure
 a guaranteed trap when their target has disappeared.)
 
 Let's start writing code. We'll represent a B-tree path using an array of
 `UnsafePathElement`s, which we define as a struct holding a node reference and a slot
 number:
*/
extension BTree {
    struct UnsafePathElement {
        unowned(unsafe) let node: Node
        var slot: Int

        init(_ node: Node, _ slot: Int) {
            self.node = node
            self.slot = slot
        }
    }
}
/*:
 That `node` there is one scary-looking declaration for a stored property.
 
 We'll also define a handful of computed properties for accessing common aspects of
 a path element, including the value it references, the corresponding child node preceding
 this value, whether the associated node is a leaf, and whether the path element
 is pointing at the end of the node:
*/
extension BTree.UnsafePathElement {
    var value: Element? {
        guard slot < node.elements.count else { return nil }
        return node.elements[slot]
    }
    var child: BTree<Element>.Node {
        return node.children[slot]
    }
    var isLeaf: Bool { return node.isLeaf }
    var isAtEnd: Bool { return slot == node.elements.count }
}
/*:
 Note that the slot may be the one immediately after the last element inside the
 node, so a path element may not always have a corresponding value. Internal
 nodes have a child node at every slot though.
 
 It'll be useful to be able to compare path elements for equality, so let's
 also implement `Equatable`:
*/
extension BTree.UnsafePathElement: Equatable {
    static func ==(left: BTree<Element>.UnsafePathElement, right: BTree<Element>.UnsafePathElement) -> Bool {
        return left.node === right.node && left.slot == right.slot
    }
}
/*:
 ### B-Tree Indices
 
 Here's the definition of `BTreeIndex`. It looks similar to `RedblackTree2Index`, in that it
 just holds a list of path elements, along with a weak reference to the root node
 and mutation count at the time the index was created. Note that we still use a
 weak reference to the root node — because it allows us to safely validate an
 index on its own — when we have no concrete tree value to match with the index:
*/
extension BTree {
    public struct Index {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64

        fileprivate var path: [UnsafePathElement]
        fileprivate var current: UnsafePathElement
/*:
 In most cases, advancing an index inside a B-tree can be done by simply
 incrementing the slot value of the final path element. Storing this "hot"
 element outside the array as a separate `current` property makes this common
 case a tiny bit faster. (`Array`'s own index validation and the inherent
 indirection in accessing the array's underlying storage buffer would add a
 little bit of extra overhead.) Such micro-optimizations are normally
 unnecessary (or even harmful). However, we've already decided to use unsafe
 references, and this additional complication seems almost trivial in
 comparison; it's certainly less dangerous.
 
 We also need two internal initializers for creating the `startIndex` and
 `endIndex` of a tree. The former constructs the path to the first element inside the tree, while the latter just puts the path after the last element in the root node:
*/
        init(startOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, 0)
            while !current.isLeaf { push(0) }
        }

        init(endOf tree: BTree) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, tree.root.elements.count)
        }
    }
}
/*:
 In theory, `startIndex` is an $O(\log n)$ operation; but as we've seen, the
 depth of a B-tree is more like $O(1)$ in practice, so in this case, we aren't
 really breaking `Collection`'s performance requirement at all.
 
 ### Index Validation
 
 Index validation is done in basically the same way as in `RedblackTree2`, except the
 root reference may not be `nil` in any valid B-tree index. Even the empty tree
 has a root node.
 
 All mutations on `BTree` values are careful to change either the root reference
 or the root's mutation count so that when both of these match the values in an
 index, we know the index is still valid and it's safe to look at its path:
*/
extension BTree.Index {
    fileprivate func validate(for root: BTree<Element>.Node) {
        precondition(self.root === root)
        precondition(self.mutationCount == root.mutationCount)
    }

    fileprivate static func validate(_ left: BTree<Element>.Index, _ right: BTree<Element>.Index) {
        precondition(left.root === right.root)
        precondition(left.mutationCount == right.mutationCount)
        precondition(left.root != nil)
        precondition(left.mutationCount == left.root!.mutationCount)
    }
}
/*:
 We'll need the static index validation method in our `Equatable` and
 `Comparable` implementations. This method is the reason why we couldn't change
 the weak reference to the root node into `unowned(unsafe)` — it needs to be
 able to validate indices without an externally supplied tree context.
 
 ### Index Navigation
 
 To navigate inside the tree, we define two helper methods, `push` and `pop`.
 `push` takes a slot number in the child node associated with the current path
 and appends it to the end of the path. `pop` simply removes the last element on
 the path:
*/
extension BTree.Index {
    fileprivate mutating func push(_ slot: Int) {
        path.append(current)
        let child = current.node.children[current.slot]
        current = BTree<Element>.UnsafePathElement(child, slot)
    }

    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
}
/*:
 Given these two functions, we can define a method that advances an index to the
 next element inside the tree. For the vast majority of cases, the method just
 needs to increment the slot of the current (i.e. last) path element. The only
 exceptions are when (1) there are no more elements in the corresponding leaf
 node, or (2) the current node isn't a leaf. (Both of these cases are
 relatively rare.)
*/
extension BTree.Index {
    fileprivate mutating func formSuccessor() {
        precondition(!current.isAtEnd, "Cannot advance beyond endIndex")
        current.slot += 1
        if current.isLeaf {
            // This loop will rarely execute even once.
            while current.isAtEnd, current.node !== root {
                // Ascend to the nearest ancestor that has further elements.
                pop()
            }
        }
        else {
            // Descend to the start of the leftmost leaf node under us.
            while !current.isLeaf {
                push(0)
            }
        }
    }
}
/*:
 Finding the predecessor index is similar, although we need to slightly
 reorganize the code because we need to look out for the start of the node and not
 the end:
*/
extension BTree.Index {
    fileprivate mutating func formPredecessor() {
        if current.isLeaf {
            while current.slot == 0, current.node !== root {
                pop()
            }
            precondition(current.slot > 0, "Cannot go below startIndex")
            current.slot -= 1
        }
        else {
            while !current.isLeaf {
                let c = current.child
                push(c.isLeaf ? c.elements.count - 1 : c.elements.count)
            }
        }
    }
}
/*:
 The functions above are all private helper methods, so it's OK for them to
 assume that the index has already been validated by their caller.
 
 ### Comparing Indices
 
 Indices must be comparable, so we need to implement the equality and less-than
 operators too. Since these functions are public entry points, we must remember
 to validate indices before accessing any of their path elements:
*/
extension BTree.Index: Comparable {
    public static func ==(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        return left.current == right.current
    }

    public static func <(left: BTree<Element>.Index, right: BTree<Element>.Index) -> Bool {
        BTree<Element>.Index.validate(left, right)
        switch (left.current.value, right.current.value) {
        case let (a?, b?): return a < b
        case (nil, _): return false
        default: return true
        }
    }
}
/*:
 ### Collection Conformance
 
 We now have everything we need to make `BTree` conform to `BidirectionalCollection`; in the implementation of each method, we just need to call one of the index methods above. We also need to remember to validate any indices before calling anything that doesn't implement validation on its own:
*/
extension BTree: SortedSet {
    public var startIndex: Index { return Index(startOf: self) }
    public var endIndex: Index { return Index(endOf: self) }

    public subscript(index: Index) -> Element {
        index.validate(for: root)
        return index.current.value!
    }

    public func formIndex(after i: inout Index) {
        i.validate(for: root)
        i.formSuccessor()
    }

    public func formIndex(before i: inout Index) {
        i.validate(for: root)
        i.formPredecessor()
    }

    public func index(after i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formSuccessor()
        return i
    }

    public func index(before i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formPredecessor()
        return i
    }
}
/*:
 ### Counting the Number of Elements
 
 Iteration using indexing only takes $O(n)$ time now, but all that index
 validation may slow things down quite a bit. As such, it makes sense to include
 specialized implementations for basic `Collection` members, like the
 `count` property:
*/
extension BTree {
    public var count: Int {
        return root.count
    }
}

extension BTree.Node {
    var count: Int {
        return children.reduce(elements.count) { $0 + $1.count }
    }
}
/*:
 Note that `Node.count` uses recursion inside the closure it gives to `reduce`.
 It needs to visit every node inside the B-tree, and because we technically have
 $O(n)$ nodes, the count will finish in $O(n)$ time. (This is still much faster
 than counting each element one by one though.)
 
 > Since B-tree nodes are so big, it would make sense to include a
 > subtree count inside each node, making the data structure an *order
 > statistic tree*. This would make `count` an $O(1)$ operation, and
 > it would allow looking up the *i*th element inside the tree in just
 > $O(\log n)$ time. We won't implement this here; check out the official
 > [BTree][BTree-github] package for a full implementation of this idea.
 
 [BTree-github]: https://github.com/lorentey/BTree
 
 ### Custom Iterator
 
 We should also define a custom iterator type in order to eliminate index validation overhead in simple `for-in` loops. The following is a straightforward adaptation of the one we made for `RedblackTree2`:
*/
extension BTree {
    public struct Iterator: IteratorProtocol {
        let tree: BTree
        var index: Index

        init(_ tree: BTree) {
            self.tree = tree
            self.index = tree.startIndex
        }

        public mutating func next() -> Element? {
            guard let result = index.current.value else { return nil }
            index.formSuccessor()
            return result
        }
    }
    
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}
/*:
 ### Iteration Performance
 
 We used every tool in our toolbox to optimize the performance of iteration
 inside B-trees:
 
 - **Algorithmic improvement:** Indices are represented by full paths into the tree so that index advancement can be implemented in amortized $O(1)$ time.
 
 - **Optimizing for the typical case:** The vast majority of values inside B-trees are stored in the `elements` arrays of leaf nodes. By extracting the last path element into its own stored property, we ensured we advance over such elements using as few operations as possible.
 
 - **Improved locality of reference:** By arranging our values into arrays with a size that's a function of the cache size, we built a data structure that's perfectly adapted to the multi-layered memory architecture in our computers.
 
 - **Validation shortcuts:** We implemented a custom iterator so that we can eliminate redundant index validation during iteration.
 
 - **Careful use of unsafe operations:** Inside paths, we use unsafe references to tree nodes so that creating/modifying index paths doesn't involve reference count operations. Index validation ensures we never encounter broken references.
 
 So how fast is iteration over B-trees? Pretty darned fast! 
 The chart below has our microbenchmark results.
 
 ![Figure 6.4: Comparing the performance of iteration in five `SortedSet` implementations.](Images/Iteration5.png)
 
 We were quite happy with `RedblackTree2`'s final iteration performance; however,
 `BTree` is in a completely different league: it's about 40 times faster!
 `SortedArray` is 8 times faster still though, so there's some room for
 improvement.
 
 ## Examples
*/
// This extension is (unfortunately) necessary to prevent the playground from crashing.
extension BTree: CustomStringConvertible {
    public var description: String {
        return "<BTree>"
    }
}
var set = BTree<Int>(order: 5)
for i in (1 ... 250).shuffled() {
    set.insert(i)
}
set
let evenMembers = set.reversed().lazy.filter { $0 % 2 == 0 }.map { "\($0)" }.joined(separator: ", ")
evenMembers
/*:
 ## Performance Summary
 
 The chart below
 summarizes the performance of `BTree` on our four standard microbenchmarks.
 Remarkably, iteration using `for-in` is now much faster than using `forEach` — this is the opposite of what we had with red-black trees.
 
 ![Figure 6.5: Benchmark results for `BTree` operations.](Images/BTree.png)
 
 Our benchmarks use `Int` elements on a 64-bit MacBook with an L1 cache of
 32 kilobytes — so `BTree<Int>` has a default order of 1,024. Therefore, the first
 node split happens when we insert the 1,024th element, converting the tree from a
 single node into three nodes arranged in two levels. This point is clearly
 visible on the chart as a sudden jump at the 1,000 size. 
 
 The size at which the tree grows a third level isn't as precisely
 predetermined — it happens somewhere between 500,000 and 1 million items. The
 curves for `insert` and `contains` exhibit faster growth at this range, which is
 consistent with having to recurse a level deeper.
 
 To get four-level B-trees, we need to insert about 1 billion integers. 
 The chart below
 extends the `BTree.insert` chart to such monstrously huge sets. The insertion
 curve has three clearly distinguishable phases corresponding to B-trees of one, two,
 and three levels, and at the right edge of the chart we can clearly make out the
 beginnings of the upward curve that marks the fourth tree layer. At this point
 though, the benchmark has eaten up all 16 GB of physical memory in my MacBook,
 forcing macOS to start compressing pages and even paging out some of the data
 to the SSD. Clearly, some (most?) of that final growth spurt is due to paging
 and not the addition of the fourth B-tree layer. Extending the benchmark even
 further to the right would push beyond the limits of this particular machine.
 
 ![Figure 6.6: Creating a B-tree by random insertions.](Images/BTree-Insertion.png)
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/