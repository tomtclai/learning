/*:
 [Previous page](@previous)

 # Additional Optimizations
 
 In this chapter, we're going to concentrate on optimizing `BTree.insert` even further, squeezing our code to get the last few drops of sweet performance out.
 
 We'll create three more `SortedSet` implementations, creatively naming them
 `BTree2`, `BTree3`, and `BTree4`. To keep this book at a manageable length, we
 aren't going to include the full source code of these three B-tree variants;
 we'll just describe the changes through a few representative code snippets. You
 can find the full source code for all three B-tree variants in [the book's
 GitHub repository][bookrepo].
 
 [bookrepo]: https://github.com/objcio/OptimizingCollections
 
 If you're bored with `SortedSet`s, it's OK to skip this chapter, as the advanced
 techniques it describes are rarely applicable to everyday app development
 work.
 
 ## Inlining `Array`'s Methods
 
 
 `BTree` stores elements and children of a `Node` in standard `Array`s. In the last chapter, this
 made the code relatively easy to understand, which helped us explain B-trees. However, `Array` includes logic for index validation and COW that is
 redundant inside `BTree` — supposing we didn't make any coding mistakes, `BTree` never subscripts an array with an out-of-range index, and it implements its own COW behavior.
 
 Looking at our 
 insertion benchmark chart,
 we see that while `BTree.insert` is extremely close to `SortedArray.insert` at
 small set sizes, there's still a 10–20% performance gap between them. Would
 eliminating `Array`'s (tiny) overhead be enough to close this gap? Let's find
 out!
 
 ![Figure 7.1: Comparing the performance of five different implementations for `SortedSet.insert`.](Images/Insertion5.png)
 
 The Swift standard library includes `UnsafeMutablePointer` and
 `UnsafeMutableBufferPointer` types we can use to implement our own storage
 buffers. They deserve their scary names; working with these types is only
 slightly easier than working with C pointers — the slightest mistake in the
 code that handles them may result in hard-to-debug memory corruption bugs,
 memory leaks, or even worse! On the other hand, if we promise to be super
 careful, we might be able to use these to slightly improve performance.
 
 <!-- begin-exclude-from-preview -->
 
 So let's start writing `BTree2`, our second attempt at implementing B-trees. It
 starts innocently enough:
*/
public struct BTree2<Element: Comparable> {
    fileprivate var root: Node

    public init(order: Int) {
        self.root = Node(order: order)
    }
}
extension BTree2 {
    public init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)
        self.init(order: Swift.max(16, order))
    }
}
/*:
 However, in `Node`, we convert the `elements` array into an unsafe mutable
 pointer that points to the start of a manually allocated buffer. We also need
 to add a stored property for the count of elements currently in the
 buffer; the pointer won't keep track of this on its own:
*/
extension BTree2 {
    class Node {
        let order: Int
        var mutationCount: Int64 = 0
        var elementCount: Int = 0
        let elements: UnsafeMutablePointer<Element>
        var children: ContiguousArray<Node> = []
/*:
 For `BTree2`, we left `children` as an array, although we did change its type
 from `Array` to `ContiguousArray`; the latter may sometimes be slightly faster.
 Remember that most elements are in leaf nodes — speeding up internal nodes may
 not result in a measurable overall improvement, so it's better not to waste too much time on optimizing them.
 
 `Node`'s designated initializer is responsible for allocating our element
 buffer. We allocate space for `order` elements so that the buffer will be able
 to hold one more element than our maximum size. This is important, because
 nodes will grow over the maximum just before we split them:
*/
        init(order: Int) {
            self.order = order
            self.elements = .allocate(capacity: order)
        }
/*:
 In the previous chapter, we didn't use `Array.reserveCapacity(_:)` to
 preallocate storage for the maximum sizes of our two arrays, relying instead on
 `Array`'s automatic storage management. This makes the code simpler, but it has
 two consequences. First, when we insert a new element into a `BTree` node,
 `Array` sometimes needs to allocate a new, larger buffer and move existing
 elements into it. This adds some additional overhead to insert operations.
 Second, `Array` grows its storage buffer in powers of two, so if the
 tree order is just *slightly* above such a number, `Array` may allocate as much
 as 50% more space than we need for a full node. We eliminate both of these
 issues here by always allocating a buffer that's exactly as large as our
 maximum node size.
 
 Since we're manually allocating the buffer, we need to manually deallocate it at some point. The best place to do this is in a custom `deinit`:
*/
        deinit {
            elements.deinitialize(count: elementCount)
            elements.deallocate(capacity: order)
        }
    }
}
/*:
 Note how we have to explicitly deinitialize memory that's occupied by elements,
 returning the buffer to its initial, uninitialized state before deallocating
 it. This ensures that references that may be included in `Element` values
 are correctly released, possibly even deallocating some values that were only
 held by the buffer. Neglecting to deinitialize values will result in memory
 leaks:
*/
extension BTree2 {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}

extension BTree2.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        if isLeaf {
            for i in 0 ..< elementCount {
                try body(elements[i])
            }
        }
        else {
            for i in 0 ..< elementCount {
                try children[i].forEach(body)
                try body(elements[i])
            }
            try children[elementCount].forEach(body)
        }
    }
}

extension BTree2.Node {
    internal func slot(of element: Element) -> (match: Bool, index: Int) {
        var start = 0
        var end = elementCount
        while start < end {
            let mid = start + (end - start) / 2
            if elements[mid] < element {
                start = mid + 1
            }
            else {
                end = mid
            }
        }
        let match = start < elementCount && elements[start] == element
        return (match, start)
    }
}

extension BTree2 {
    public func contains(_ element: Element) -> Bool {
        return root.contains(element)
    }
}

extension BTree2.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)
        if slot.match { return true }
        guard !children.isEmpty else { return false }
        return children[slot.index].contains(element)
    }
}

extension BTree2 {
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}
/*:
 Cloning a node is a nice example of how we may use the `elements` buffer. We
 call the `initialize(from:count:)` method to copy data between buffers. This
 takes care of updating reference counts if necessary. If the node is an
 internal node, we also call `reserveCapacity(_:)` on the new node's `children`
 array to preallocate enough space for holding as many children as we may need.
 Otherwise, we leave `children` empty so that we don't waste memory allocating
 storage we'll never use:
  
*/
extension BTree2.Node {
    func clone() -> BTree2<Element>.Node {
        let node = BTree2<Element>.Node(order: order)
        node.elementCount = self.elementCount
        node.elements.initialize(from: self.elements, count: self.elementCount)
        if !isLeaf {
            node.children.reserveCapacity(order + 1)
            node.children += self.children
        }
        return node
    }
}
extension BTree2.Node {
    func makeChildUnique(at slot: Int) -> BTree2<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else {
            return children[slot]
        }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}

extension BTree2.Node {
    var maxChildren: Int { return order }
    var minChildren: Int { return (maxChildren + 1) / 2 }
    var maxElements: Int { return maxChildren - 1 }
    var minElements: Int { return minChildren - 1 }

    var isLeaf: Bool { return children.isEmpty }
    var isTooLarge: Bool { return elementCount > maxElements }
}

extension BTree2 {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}
/*:
 The `split()` operation we need for insertion can take advantage of `UnsafeMutablePointer`'s
 support for move initialization. In the original code, we had to move elements
 in two phases by first copying them into the new array and then removing them
 from the original array. The unified move operation can be much faster when
 `Element` includes reference-counted values. (It doesn't affect performance for simple value types like `Int` though.)
*/
extension BTree2.Node {
    func split() -> BTree2<Element>.Splinter {
        let count = self.elementCount
        let middle = count / 2
        
        let separator = elements[middle]
        let node = BTree2<Element>.Node(order: self.order)
        
        let c = count - middle - 1
        node.elements.moveInitialize(from: self.elements + middle + 1, count: c)
        node.elementCount = c
        self.elementCount = middle
        
        if !isLeaf {
            node.children.reserveCapacity(self.order + 1)
            node.children += self.children[middle + 1 ... count]
            self.children.removeSubrange(middle + 1 ... count)
        }
        return .init(separator: separator, node: node)
    }
}
/*:
 To insert a new element in the middle of our buffer, we have to implement the
 equivalent of `Array.insert`. To do this, we first have to make room for the
 new element by moving existing items one slot to the right, starting at the
 insertion point:
*/
extension BTree2.Node {
    fileprivate func _insertElement(_ element: Element, at slot: Int) {
        assert(slot >= 0 && slot <= elementCount)
        (elements + slot + 1).moveInitialize(from: elements + slot, count: elementCount - slot)
        (elements + slot).initialize(to: element)
        elementCount += 1
    }
}
/*:
 This is all we need in order to adapt our old `insert` code for `BTree2`:
*/
extension BTree2.Node {
    func insert(_ element: Element) -> (old: Element?, splinter: BTree2<Element>.Splinter?) {
        let slot = self.slot(of: element)
        if slot.match {
            // The element is already in the tree.
            return (self.elements[slot.index], nil)
        }
        mutationCount += 1
        if self.isLeaf {
            _insertElement(element, at: slot.index)
            return (nil, self.isTooLarge ? self.split() : nil)
        }
        let (old, splinter) = makeChildUnique(at: slot.index).insert(element)
        guard let s = splinter else { return (old, nil) }
        _insertElement(s.separator, at: slot.index)
        self.children.insert(s.node, at: slot.index + 1)
        return (old, self.isTooLarge ? self.split() : nil)
    }
}

extension BTree2 {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let s = splinter {
            let root = BTree2<Element>.Node(order: root.order)
            root.elementCount = 1
            root.elements.initialize(to: s.separator)
            root.children = [self.root, s.node]
            self.root = root
        }
        return (inserted: old == nil, memberAfterInsert: old ?? element)
    }
}
extension BTree2 {
    struct UnsafePathElement: Equatable {
        unowned(unsafe) let node: Node
        var slot: Int

        init(_ node: Node, _ slot: Int) {
            self.node = node
            self.slot = slot
        }

        var isLeaf: Bool { return node.isLeaf }
        var isAtEnd: Bool { return slot == node.elementCount }
        var value: Element? {
            guard slot < node.elementCount else { return nil }
            return node.elements[slot]
        }
        var child: Node {
            return node.children[slot]
        }

        static func ==(left: UnsafePathElement, right: UnsafePathElement) -> Bool {
            return left.node === right.node && left.slot == right.slot
        }
    }
}

extension BTree2 {
    public struct Index: Comparable {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64

        fileprivate var path: [UnsafePathElement]
        fileprivate var current: UnsafePathElement

        init(startOf tree: BTree2) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, 0)
            while !current.isLeaf { push(0) }
        }

        init(endOf tree: BTree2) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, tree.root.elementCount)
        }
    }
}

extension BTree2.Index {
    fileprivate func validate(for root: BTree2<Element>.Node) {
        precondition(self.root === root)
        precondition(self.mutationCount == root.mutationCount)
    }

    fileprivate static func validate(_ left: BTree2<Element>.Index, _ right: BTree2<Element>.Index) {
        precondition(left.root === right.root)
        precondition(left.mutationCount == right.mutationCount)
        precondition(left.root != nil)
        precondition(left.mutationCount == left.root!.mutationCount)
    }
}

extension BTree2.Index {
    fileprivate mutating func push(_ slot: Int) {
        path.append(current)
        let child = current.node.children[current.slot]
        current = BTree2<Element>.UnsafePathElement(child, slot)
    }

    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
}

extension BTree2.Index {
    fileprivate mutating func formSuccessor() {
        precondition(!current.isAtEnd, "Cannot advance beyond endIndex")
        current.slot += 1
        if current.isLeaf {
            while current.isAtEnd, current.node !== root {
                pop()
            }
        }
        else {
            while !current.isLeaf {
                push(0)
            }
        }
    }
}

extension BTree2.Index {
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
                push(c.isLeaf ? c.elementCount - 1 : c.elementCount)
            }
        }
    }
}

extension BTree2.Index {
    public static func ==(left: BTree2<Element>.Index, right: BTree2<Element>.Index) -> Bool {
        BTree2<Element>.Index.validate(left, right)
        return left.current == right.current
    }

    public static func <(left: BTree2<Element>.Index, right: BTree2<Element>.Index) -> Bool {
        BTree2<Element>.Index.validate(left, right)
        switch (left.current.value, right.current.value) {
        case let (a?, b?): return a < b
        case (nil, _): return false
        default: return true
        }
    }
}

extension BTree2: SortedSet {
    public var startIndex: Index { return Index(startOf: self) }
    public var endIndex: Index { return Index(endOf: self) }

    public subscript(index: Index) -> Element {
        get {
            index.validate(for: root)
            return index.current.value!
        }
    }

    public func formIndex(after i: inout Index) {
        i.validate(for: root)
        i.formSuccessor()
    }

    public func index(after i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formSuccessor()
        return i
    }

    public func formIndex(before i: inout Index) {
        i.validate(for: root)
        i.formPredecessor()
    }

    public func index(before i: Index) -> Index {
        i.validate(for: root)
        var i = i
        i.formPredecessor()
        return i
    }
}

extension BTree2 {
    public var count: Int {
        return root.count
    }
}

extension BTree2.Node {
    var count: Int {
        return children.reduce(elementCount) { $0 + $1.count }
    }
}

extension BTree2 {
    public struct Iterator: IteratorProtocol {
        let tree: BTree2
        var index: Index

        init(_ tree: BTree2) {
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
 To create `BTree2`, we essentially manually inlined `Array`'s
 implementation from the standard library directly into our B-tree code,
 removing functionality that we don't need.
 
 Benchmarking results are shown in the chart below.
 Insertion has consistently become 10–20% faster. We've eliminated the last
 remaining performance gap between B-trees and sorted arrays: `BTree2.insert`
 matches or exceeds the performance of all previous `SortedSet` implementations
 across the entire size spectrum.
 
 ![Figure 7.2: Comparing insertion performance of six `SortedSet` implementations.](Images/Insertion6.png)
 
 As a nice side effect, eliminating `Array`'s index validation checks also
 boosts iteration performance by a factor of two; 
 see the chart below.
 `BTree2.for-in` is just four times slower than `SortedArray`; that's a pretty
 sizable improvement!
 
 ![Figure 7.3: Comparing the iteration performance of six `SortedSet` implementations.](Images/Iteration6.png)
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/