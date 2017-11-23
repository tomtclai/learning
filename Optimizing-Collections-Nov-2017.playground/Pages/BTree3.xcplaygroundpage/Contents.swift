/*:
 [Previous page](@previous)

 <!-- begin-exclude-from-preview -->
 
 ## Optimizing Insertion into Shared Storage
 
 
 So far, whenever we've measured insertion performance, we've always assumed the
 storage of our sorted set is entirely unique to it. But we never benchmarked what
 happens when we insert elements into sets with shared storage. 
 
 Let's devise a benchmark for measuring shared insertions! One way to do this is
 to measure how much time it takes to insert a bunch of elements when we make a
 full copy of the entire set after every insertion:

```swift
extension SortedSet {
    func sharedInsertBenchmark(_ input: [Element]) {
        var set = Self()
        var copy = set
        for value in input {
            set.insert(value)
            copy = set
        }
        _ = copy // Prevents warning about the variable never being read.
    }
}
```

 The chart below
 displays the results of running this new benchmark on the `SortedSet`
 implementations we've made thus far.
 
 ![Figure 7.4: Amortized time of a single insertion into shared storage.](Images/SharedInsertion.png)
 
 Clearly, our `NSOrderedSet` wrapper wasn't built for this kind of abuse; once
 we pass a couple thousand values, it becomes roughly a thousand times slower
 than `SortedArray`. And `SortedArray` doesn't fare much better either: to
 dissociate their storage from their copies, both of these array-based sorted
 sets need to make a full copy of every single value stored in them. This doesn't
 change their insertion implementation's asymptotic performance (it's still
 $O(n)$), but it does add a sizeable constant factor. In the case of
 `SortedArray`, the `sharedInsert` benchmark is about 3.5 times slower than
 plain `insert`.
 
 Our two red-black tree implementations behave much better: for
 each insertion, they only need to make a copy of nodes that happen to fall on
 the path toward the newly inserted element. `RedBlackTree` does this anyway:
 its insertion performance is exactly the same whether or not its nodes are
 shared. But `RedblackTree2` is unable to use its fancy in-place mutations: all of its
 `isKnownUniquelyReferenced` calls return false, so it becomes slightly slower
 than `RedBlackTree` at this particular benchmark.
 
 `BTree2` starts off really promising, but it slows down rather dramatically at
 around 64,000 elements. At this stage, the tree is getting close to growing a
 third level; its (second-level) root node contains enough elements that having
 to make a copy of it considerably weighs down insertions. This gets much
 worse as the tree gains its third level, ending up on a performance level
 that's about 6 times slower than red-black trees. (`BTree.insert`'s asymptotic
 performance remains $O(\log n)$; the slowdown just adds a huge constant factor.)
 
 We want our B-trees to be much faster than red-black trees on every chart. Can
 we somehow prevent this bump from happening in the shared storage case? Well,
 of course we can! 
 
 Our theory is that the slowdown occurs because of large internal nodes. We also
 know that internal nodes *usually* don't contribute much to B-tree performance,
 because most values are stored in leaf nodes. Therefore, we're probably able
 to mess with internal nodes whichever way we like — it won't affect the
 charts much. So what if we drastically restricted the maximum size of our
 internal nodes while leaving leaf nodes alone?
*/
public struct BTree3<Element: Comparable> {
    fileprivate var root: Node

    public init(order: Int) {
        self.root = Node(order: order)
    }
}

extension BTree3 {
    public init() {
        let order = (cacheSize ?? 32768) / (4 * MemoryLayout<Element>.stride)
        self.init(order: Swift.max(16, order))
    }
}

extension BTree3 {
    class Node {
        let order: Int
        var mutationCount: Int64 = 0
        var elementCount: Int = 0
        let elements: UnsafeMutablePointer<Element>
        var children: ContiguousArray<Node> = []

        init(order: Int) {
            self.order = order
            self.elements = .allocate(capacity: order)
        }

        deinit {
            elements.deinitialize(count: elementCount)
            elements.deallocate(capacity: order)
        }
    }
}

extension BTree3 {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root.forEach(body)
    }
}

extension BTree3.Node {
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

extension BTree3.Node {
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

extension BTree3 {
    public func contains(_ element: Element) -> Bool {
        return root.contains(element)
    }
}

extension BTree3.Node {
    func contains(_ element: Element) -> Bool {
        let slot = self.slot(of: element)
        if slot.match { return true }
        guard !children.isEmpty else { return false }
        return children[slot.index].contains(element)
    }
}

extension BTree3 {
    fileprivate mutating func makeRootUnique() -> Node {
        if isKnownUniquelyReferenced(&root) { return root }
        root = root.clone()
        return root
    }
}

extension BTree3.Node {
    func clone() -> BTree3<Element>.Node {
        let node = BTree3<Element>.Node(order: order)
        node.elementCount = self.elementCount
        node.elements.initialize(from: self.elements, count: self.elementCount)
        if !isLeaf {
            node.children.reserveCapacity(order + 1)
            node.children += self.children
        }
        return node
    }
}

extension BTree3.Node {
    func makeChildUnique(at slot: Int) -> BTree3<Element>.Node {
        guard !isKnownUniquelyReferenced(&children[slot]) else {
            return children[slot]
        }
        let clone = children[slot].clone()
        children[slot] = clone
        return clone
    }
}

extension BTree3.Node {
    var maxChildren: Int { return order }
    var minChildren: Int { return (maxChildren + 1) / 2 }
    var maxElements: Int { return maxChildren - 1 }
    var minElements: Int { return minChildren - 1 }

    var isLeaf: Bool { return children.isEmpty }
    var isTooLarge: Bool { return elementCount > maxElements }
}

extension BTree3 {
    struct Splinter {
        let separator: Element
        let node: Node
    }
}

extension BTree3.Node {
    func split() -> BTree3<Element>.Splinter {
        let count = self.elementCount
        let middle = count / 2
        
        let separator = elements[middle]
        let node = BTree3<Element>.Node(order: self.order)
        
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

extension BTree3.Node {
    fileprivate func _insertElement(_ element: Element, at slot: Int) {
        assert(slot >= 0 && slot <= elementCount)
        (elements + slot + 1).moveInitialize(from: elements + slot, count: elementCount - slot)
        (elements + slot).initialize(to: element)
        elementCount += 1
    }
}

extension BTree3.Node {
    func insert(_ element: Element) -> (old: Element?, splinter: BTree3<Element>.Splinter?) {
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
/*:
 It turns out this is shockingly easy to do: we just need to make a tiny
 one-line change in `BTree2.insert`:
*/
extension BTree3 {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let root = makeRootUnique()
        let (old, splinter) = root.insert(element)
        if let s = splinter {
            let root = BTree3<Element>.Node(order: 16) // <--
            root.elementCount = 1
            root.elements.initialize(to: s.separator)
            root.children = [self.root, s.node]
            self.root = root
        }
        return (inserted: old == nil, memberAfterInsert: old ?? element)
    }
}
/*:
 The marked line is inside the code block that adds a new level to the tree. The
 order number we use for the new root also gets applied to all nodes that'll
 be split off of it — so by using a small order number here instead of `self.order`,
 we ensure that *all* internal nodes get initialized with this order
 instead of with the value originally given to `BTree`'s initializer. (New leaf nodes
 are always split off from existing leaves, so this number won't ever get
 applied to them.)
*/
extension BTree3 {
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

extension BTree3 {
    public struct Index: Comparable {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64

        fileprivate var path: [UnsafePathElement]
        fileprivate var current: UnsafePathElement

        init(startOf tree: BTree3) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, 0)
            while !current.isLeaf { push(0) }
        }

        init(endOf tree: BTree3) {
            self.root = tree.root
            self.mutationCount = tree.root.mutationCount
            self.path = []
            self.current = UnsafePathElement(tree.root, tree.root.elementCount)
        }
    }
}

extension BTree3.Index {
    fileprivate func validate(for root: BTree3<Element>.Node) {
        precondition(self.root === root)
        precondition(self.mutationCount == root.mutationCount)
    }

    fileprivate static func validate(_ left: BTree3<Element>.Index, _ right: BTree3<Element>.Index) {
        precondition(left.root === right.root)
        precondition(left.mutationCount == right.mutationCount)
        precondition(left.root != nil)
        precondition(left.mutationCount == left.root!.mutationCount)
    }
}

extension BTree3.Index {
    fileprivate mutating func push(_ slot: Int) {
        path.append(current)
        let child = current.node.children[current.slot]
        current = BTree3<Element>.UnsafePathElement(child, slot)
    }

    fileprivate mutating func pop() {
        current = self.path.removeLast()
    }
}

extension BTree3.Index {
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

extension BTree3.Index {
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

extension BTree3.Index {
    public static func ==(left: BTree3<Element>.Index, right: BTree3<Element>.Index) -> Bool {
        BTree3<Element>.Index.validate(left, right)
        return left.current == right.current
    }

    public static func <(left: BTree3<Element>.Index, right: BTree3<Element>.Index) -> Bool {
        BTree3<Element>.Index.validate(left, right)
        switch (left.current.value, right.current.value) {
        case let (a?, b?): return a < b
        case (nil, _): return false
        default: return true
        }
    }
}

extension BTree3: SortedSet {
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

extension BTree3 {
    public var count: Int {
        return root.count
    }
}

extension BTree3.Node {
    var count: Int {
        return children.reduce(elementCount) { $0 + $1.count }
    }
}

extension BTree3 {
    public struct Iterator: IteratorProtocol {
        let tree: BTree3
        var index: Index

        init(_ tree: BTree3) {
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
 Naming this new variant `BTree3` and rerunning our benchmark gets us the chart
 below.
 Our theory was correct: limiting the size of internal nodes did in fact
 eliminate the slowdown! `BTree3` is about 2–2.5 times faster than
 `RedBlackTree`, even for huge sets. (Creating a `BTree3` of 4 million elements in this laborious manner takes just 15 seconds; `BTree2` took 10 times as long.)
 
 ![Figure 7.5: Amortized time of a single insertion into shared storage.](Images/SharedInsertion2.png)
 
 Limiting the size of internal nodes increases the typical height of the tree, so
 it does affect some B-tree operations. Thankfully though, the effect is mostly
 negligible: it slows down `contains` and the in-place mutating flavor of
 `insert` only by about 10%, and it doesn't affect iteration methods at all.
 For instance,
 the chart below
 compares `BTree3`'s in-place insertion performance to our other implementations.
 
 ![Figure 7.6: Amortized time of a single insertion into uniquely held storage.](Images/Insertion7.png)
 
 That was surprisingly easy, wasn't it?
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/