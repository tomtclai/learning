/*:
 [Previous page](@previous)

 # The Copy-On-Write Optimization
 
 
 `RedBlackTree` creates a brand-new tree every time we insert a new element.
 The new tree shares some of its nodes with the original, but nodes on the
 entire path from the root to the new node are replaced with newly allocated
 nodes. This is the "easy" way to implement value semantics, but it's a bit
 wasteful.
 
 When the nodes of a tree value aren't shared between other values, it's
 OK to mutate them directly — nobody will mind, because nobody else knows about
 that particular tree instance. Direct mutation will eliminate most of the
 copying and allocation, often resulting in a dramatic speedup.
 
 We've already seen how Swift supports implementing optimized copy-on-write
 value semantics for reference types by providing the
 `isKnownUniquelyReferenced` function. Unfortunately, Swift 4 doesn't give us
 tools to implement COW for algebraic data types. We don't have access to the
 private reference type Swift uses to box up nodes, so we have no way to
 determine if a particular node is uniquely referenced. (The compiler itself
 doesn't have the smarts *(yet?)* to do the COW optimization on its own
 either.) There's also no easy way to directly access a value stored inside an enum case
 without extracting a separate copy of it. (Note that `Optional` does
 provide direct access to the value stored in it via its forced unwrapping `!`
 operator. However, the tools for implementing similar in-place access for our
 own enum types aren't available for use outside the standard library.)
 
 So to implement COW, we need to give up on our beloved algebraic data types for
 now and rewrite everything into a more conventional (dare I say *tedious*?)
 imperative style, using boring old structs and classes, with a sprinkle of
 optionals.
 
 ## Basic Definitions
 
 First, we need to define a public struct that'll represent sorted set values.
 The `RedBlackTree2` type below is just a small wrapper around a reference to a
 tree node that serves as its storage. `OrderedSet` worked the same way, so this pattern is already quite familiar to
 us by now:
*/
public struct RedBlackTree2<Element: Comparable>: SortedSet {
    fileprivate var root: Node? = nil
    
    public init() {}
}
/*:
 Next, let's take a look at the definition of our tree nodes:
*/
extension RedBlackTree2 {
    class Node {
        var color: Color
        var value: Element
        var left: Node? = nil
        var right: Node? = nil
        var mutationCount: Int64 = 0

        init(_ color: Color, _ value: Element, _ left: Node?, _ right: Node?) {
            self.color = color
            self.value = value
            self.left = left
            self.right = right
        }
    }
}
/*:
 Beyond the fields we had in the original enum case for `RedBlackTree.node`,
 this class also includes a new property called `mutationCount`. Its value is a
 count of how many times the node was mutated since its creation. This will be
 useful in our `Collection` implementation, where we'll use it to create a
 new design for indices. (We explicitly use a 64-bit integer so that it's
 unlikely the counter will ever overflow, even on 32-bit systems. Storing an
 8-byte counter in every node isn't really necessary, as we'll only use the
 value stored inside root nodes. Let's ignore this fact for now; it's simpler to do
 it this way, and we'll find a way to make this less wasteful in the next
 chapter.)
 
 But let's not jump ahead! 
 
 Using a separate type to represent nodes vs. trees means we can make the
 node type a private implementation detail to the public `RedBlackTree2`.
 External users of our collection won't be able to mess around with it, which is
 a nice bonus — everybody was able to see the internals of `RedBlackTree`, and anyone
 could use Swift's enum literal syntax to create any tree they wanted, which would easily
 break our red-black tree invariants.
 
 The `Node` class is an implementation detail of the `RedBlackTree2` struct;
 nesting the former in the latter expresses this relationship neatly. This also
 prevents naming conflicts with other
 types named `Node` in the same module. Additionally, it simplifies the syntax a little
 bit: `Node` automatically inherits `RedBlackTree2`'s `Element` type parameter,
 so we don't have to explicitly specify it.
 
 > Again, tradition dictates that the 1-bit `color` property should
 > be packed into an unused bit in the binary representation of one
 > of `Node`'s reference properties; but it'd be unsafe, fragile, and
 > fiddly to do that in Swift. It's better to simply keep `color` as a
 > standalone stored property and to let the compiler set up storage for
 > it.
 
 Note that we essentially transformed the two-case `RedBlackTree` enum into
 optional references to the `Node` type. The `.empty` case is represented by
 a `nil` optional, while a non-`nil` value represents a `.node`. `Node` is a
 heap-allocated reference type, so we've made the previous solution's implicit
 boxing an explicit feature, giving us direct access to the heap reference
 and enabling the use of `isKnownUniquelyReferenced`.
 
 <!-- begin-exclude-from-preview -->
 
 ## Rewriting Simple Lookup Methods
 
 `forEach` is a nice example of how we can rewrite algorithms from algebraic
 data types to structs and classes. We typically need to make two methods — a public method for the wrapper struct, and a private method for the node type.
 
 The struct method doesn't need to do anything if the tree is empty. Otherwise,
 it just needs to forward the call to the tree's root node. We can use optional chaining
 to express this succinctly:
*/
extension RedBlackTree2 {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try root?.forEach(body)
    }
}
/*:
 The nodes' `forEach` method does most of the actual work for performing an
 inorder walk:
*/
extension RedBlackTree2.Node {
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try left?.forEach(body)
        try body(value)
        try right?.forEach(body)
    }
}
/*:
 Optional chaining once again results in nice and compact code.
 Lovely!
 
 We could write a similar recursive implementation of `contains`, but
 let's instead choose a more procedural solution. We'll use a `node`
 variable to navigate the tree, always moving it a step closer to the element
 we're looking for:
*/
extension RedBlackTree2 {
    public func contains(_ element: Element) -> Bool {
        var node = root
        while let n = node {
            if n.value < element {
                node = n.right
            }
            else if n.value > element {
                node = n.left
            }
            else {
                return true
            }
        }
        return false
    }
}
/*:
 This function distinctly resembles binary search from Chapter 2, even though it
 works with branching references rather than indices in a flat buffer.
 For our balanced trees, it also has the same logarithmic complexity.
 
 ## Tree Diagrams
 
 Obviously we want to keep our cool tree diagrams, so let's rewrite the
 `diagram` method. The original was a method on `RedBlackTree`, and that got
 turned into an `Optional<Node>`. It's not currently possible to define
 extension methods on optional types wrapping generics, so the easiest way to
 rewrite the method is by turning it into a free-standing function:
*/
private func diagram<Element>(for node: RedBlackTree2<Element>.Node?, _ top: String = "", _ root: String = "", _ bottom: String = "") -> String {
    guard let node = node else {
        return root + "•\n"
    }
    if node.left == nil && node.right == nil {
        return root + "\(node.color.symbol) \(node.value)\n"
    }
    return diagram(for: node.right, top + "    ", top + "┌───", top + "│   ")
        + root + "\(node.color.symbol) \(node.value)\n"
        + diagram(for: node.left, bottom + "│   ", bottom + "└───", bottom + "    ")
}

extension RedBlackTree2: CustomStringConvertible {
    public var description: String {
        return diagram(for: root)
    }
}
/*:
 ## Implementing Copy-On-Write
 
 The easiest way to implement COW is to define little helper methods we can
 call to ensure we have unique references before mutating anything. We'll need
 to define one helper for each property we have that stores a reference value.
 In our case, that's three methods: one for the `root` reference inside the
 `RedBlackTree2` struct, and one each for both child references (`left` and `right`)
 inside `Node`.
 
 In all three cases, the helper method needs to check if its corresponding
 reference is unique, and if not, it needs to replace it with a new copy of its
 target. Making a copy of a node just means creating a new one with the same
 properties. Here's a simple function to do exactly that:
*/
extension RedBlackTree2.Node {
    func clone() -> Self {
        return .init(color, value, left, right)
    }
}
/*:
 Now let's define our COW helpers, starting with the one for the root node in `RedBlackTree2`:
*/
extension RedBlackTree2 {
    fileprivate mutating func makeRootUnique() -> Node? {
        if root != nil, !isKnownUniquelyReferenced(&root) {
            root = root!.clone()
        }
        return root
    }
}
/*:
 Remember our `NSOrderedSet` wrapper? It had a method called `makeUnique` that
 did something very similar. But this time, our reference is an optional, which
 makes things slightly more complicated. Thankfully, the standard library has an
 overload for `isKnownUniquelyReferenced` that takes an optional value, so we're
 covered on that front at least.
 
 When we're doing low-level work in Swift, such as implementing COW or working
 with unsafe constructs, we often need to be much more careful about the precise
 semantics of our code. For COW, we need to know and care about the details of
 exactly how and when reference counts change, so that we can avoid creating
 temporary references that would break our uniqueness checks.
 
 For example, if you're a seasoned Swift developer, you may be tempted to
 replace that clumsy-looking explicit `nil` check and the forced unwrapping with a
 healthy-looking conditional `let` binding, as in the snippet below:

```swift
if let root = self.root, !isKnownUniquelyReferenced(&root) { // BUG!
    self.root = root.clone()
}
```

 This version may look marginally better, *but it doesn't do the same thing!*
 The `let` binding counts as a new reference to the root node, so in this code,
 `isKnownUniquelyReferenced` will always return `false`. This would completely
 break the COW optimization.
 
 We're doing extremely fragile work here. If we get it wrong, our only
 indication will be that our code gets (much) slower — there's no runtime trap
 for making unnecessary copies!
 
 On the other hand, if we make *fewer* copies than necessary, our code may
 sometimes mutate a shared reference type, which would break value semantics.
 That is a much more serious offense than a performance issue. If we're lucky,
 breaking value semantics will lead to runtime traps such as an unexpected invalid
 index. But usually the effects are subtler: the code that owns the references
 we ignored will sometimes produce incorrect results with no indication that
 anything went wrong. Good luck debugging that!
 
 So be *very, very careful* about the code implementing COW. Even seemingly
 harmless cosmetic improvements may have extremely dire consequences.
 
 Anyway, here are the other two helpers for the two child references inside a
 node. They're both straightforward adaptations of `makeRootUnique`:
*/
extension RedBlackTree2.Node {
    func makeLeftUnique() -> RedBlackTree2<Element>.Node? {
        if left != nil, !isKnownUniquelyReferenced(&left) {
            left = left!.clone()
        }
        return left
    }

    func makeRightUnique() -> RedBlackTree2<Element>.Node? {
        if right != nil, !isKnownUniquelyReferenced(&right) {
            right = right!.clone()
        }
        return right
    }
}
/*:
 ## Insertion
 
 Now we're ready to start rewriting `insert`. Again, we need to split it into
 two parts: a public method in the wrapper struct, and a private one in the node
 class. (`insert` was already split into smaller parts doing individual subtasks, so this is mainly a matter of deciding what goes where.)
 
 The wrapper method is the easier of the two. It's a mutating method, so it must
 call `makeRootUnique` to ensure it's OK to mutate the root node. If
 the tree is empty, we need to create a new root node for the inserted element;
 otherwise we forward the insertion call to the existing root node, which is now
 guaranteed to be unique:
*/
extension RedBlackTree2 {
    @discardableResult
    public mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        guard let root = makeRootUnique() else {
            self.root = Node(.black, element, nil, nil)
            return (true, element)
        }
        defer { root.color = .black }
        return root.insert(element)
    }
}
/*:
 We use a `defer` statement to enforce the first red-black requirement, unconditionally painting the root black. 
 
 The node's `insert` method corresponds to our old friend `_inserting` in
 `RedBlackTree`:
*/
extension RedBlackTree2.Node {
    func insert(_ element: Element)  -> (inserted: Bool, memberAfterInsert: Element) {
        mutationCount += 1
        if element < self.value {
            if let next = makeLeftUnique() {
                let result = next.insert(element)
                if result.inserted { self.balance() }
                return result
            }
            else {
                self.left = .init(.red, element, nil, nil)
                return (inserted: true, memberAfterInsert: element)
            }
        }
        if element > self.value {
            if let next = makeRightUnique() {
                let result = next.insert(element)
                if result.inserted { self.balance() }
                return result
            }
            else {
                self.right = .init(.red, element, nil, nil)
                return (inserted: true, memberAfterInsert: element)
            }
        }
        return (inserted: false, memberAfterInsert: self.value)
    }
}
/*:
 Annoyingly, we had to convert the `switch` statement into an `if` cascade and add
 a bunch of assignments for mutation. But it still has the same structure as the
 original code — in fact, I can *almost* imagine the Swift compiler doing this
 rewrite automatically. (Algebraic data types with automagical COW optimization
 would be a nice compiler improvement for, say, perhaps Swift 10 or so.)
 
 But now we get to balancing. Oh man. 
 
 `RedBlackTree` had a memorable, graceful balancing implementation based on pattern matching — *an elegant weapon for a more civilized age*.
 Such elegance. Very beauty!
 
 And now we need to go and smear a bunch of stinking assignment statements all
 over it:
*/
extension RedBlackTree2.Node {
    func balance() {
        if self.color == .red  { return }
        if left?.color == .red {
            if left?.left?.color == .red {
                let l = left!
                let ll = l.left!
                swap(&self.value, &l.value)
                (self.left, l.left, l.right, self.right) = (ll, l.right, self.right, l)
                self.color = .red
                l.color = .black
                ll.color = .black
                return
            }
            if left?.right?.color == .red {
                let l = left!
                let lr = l.right!
                swap(&self.value, &lr.value)
                (l.right, lr.left, lr.right, self.right) = (lr.left, lr.right, self.right, lr)
                self.color = .red
                l.color = .black
                lr.color = .black
                return
            }
        }
        if right?.color == .red {
            if right?.left?.color == .red {
                let r = right!
                let rl = r.left!
                swap(&self.value, &rl.value)
                (self.left, rl.left, rl.right, r.left) = (rl, self.left, rl.left, rl.right)
                self.color = .red
                r.color = .black
                rl.color = .black
                return
            }
            if right?.right?.color == .red {
                let r = right!
                let rr = r.right!
                swap(&self.value, &r.value)
                (self.left, r.left, r.right, self.right) = (r, self.left, r.left, rr)
                self.color = .red
                r.color = .black
                rr.color = .black
                return
            }
        }
    }
}
/*:
 Yes, this is really what our original balancing function turns into after what
 amounts to a straightforward rewrite to an imperative style. It breaks my heart
 to see it.
 
 We could make this code a little bit easier on the eyes (and probably faster)
 by refactoring it. For example, we could inline `balance` into `insert`,
 eliminating some of the branches by taking into account information about which
 direction we inserted the new element.
 
 But it'd likely be easier to just open a book on data structures and port the
 red-black insertion algorithm we find there into Swift. We aren't going to do
 that here though, because it isn't very interesting, and it wouldn't actually speed
 things up by much.
 
 > If you're interested though, check out the [red-black tree
 > implementation I made][rbt-insert] for Swift 2. I haven't updated it
 > for Swift 3 or 4 because there was no point in doing so — it turned out
 > B-trees, which we're going to discuss in the following chapters, work much better.)
 
 [rbt-insert]: https://github.com/lorentey/RedBlackTree/blob/master/Sources/RedBlackTree.swift#L770-L819
 
 ## Implementing `Collection`
  
 Let's see if this time we can make a better index implementation.
 
 For `RedBlackTree`, we used a dummy index type that was just a wrapper around
 an element value. To implement `index(after:)`, we needed to find the element
 in the tree from scratch, which is an operation with logarithmic complexity.
 
 This means that when we use indexing to iterate over an entire `RedBlackTree`,
 we're doing it in $O(n\log n)$ steps, where $n$ is the count of the
 collection. That's no good at all — iterating over all elements in a collection
 should only take $O(n)$ time! (This isn't an actual `Collection` requirement,
 but it's definitely a reasonable expectation.)
 
 Well. What can we do? One way to speed things up is to have our indices include
 the entire path from the root to a particular element.
 
 However, a wrinkle in this idea is that indices aren't supposed to hold strong references to parts
 of the collection. So let's represent the path with an array of zeroing weak
 references instead.
 
 ### Index Definition
 
 Swift 4 doesn't allow us to directly define an array of weak references, so
 first we need to define a simple wrapper struct holding a weak reference:
*/
private struct Weak<Wrapped: AnyObject> {
    weak var value: Wrapped?

    init(_ value: Wrapped) {
        self.value = value
    }
}
/*:
 We can now declare the path as an array of these `Weak` values and it'll work
 fine. We'll have to remember to append `.value` in the source to extract the
 actual reference (as in `path[0].value`), but this is just a cosmetic issue;
 the wrapper struct has no runtime penalty whatsoever. It's a little bit
 annoying to have to do this dance; adding language support for weak/unowned arrays
 seems like a nice candidate for a *swift-evolution* proposal. But we're here to
 implement a sorted set and not to enhance Swift itself, so let's accept this
 little language blemish for the time being and move on.
 
 Now we're ready to define the actual index type. It's basically a wrapper
 around a path, which is an array of weakly held nodes. To make it easy to
 validate indices, we also include a direct weak reference to the root node and
 a copy of the root node's mutation count at the time the index was created:
*/
extension RedBlackTree2 {
    public struct Index {
        fileprivate weak var root: Node?
        fileprivate let mutationCount: Int64?
    
        fileprivate var path: [Weak<Node>]
    
        fileprivate init(root: Node?, path: [Weak<Node>]) {
            self.root = root
            self.mutationCount = root?.mutationCount
            self.path = path
        }
    }
}
/*:
 The figure below
 depicts an example index instance, pointing to the first value in a simple
 red-black tree. Note how the index uses weak references so that it doesn't
 retain any of the tree nodes. The `isKnownUniquelyReferenced` function only
 counts strong references, so this allows in-place mutations when there are
 outstanding indices. However, this implies that mutations may break node
 references inside previously created indices, so we'll have to be much more
 careful about index validation.
 
 ![Figure 5.1: The start index of a simple red-black tree, as implemented by `RedBlackTree2.Index`. Dashed lines represent weak references.](Images/RedBlackTree-Index@3x.png)
 
 
 ### Start and End Indices
 
 Let's start writing `Collection` methods. 
 
 We can define the `endIndex` as an index with an empty path, which is easy:
*/
extension RedBlackTree2 {
    public var endIndex: Index {
        return Index(root: root, path: [])
    }
/*:
 The start index isn't too difficult either — we just have to construct a path
 to the leftmost element inside the tree:
*/
    // - Complexity: O(log(n)); this violates `Collection` requirements.
    public var startIndex: Index {
        var path: [Weak<Node>] = []
        var node = root
        while let n = node {
            path.append(Weak(n))
            node = n.left
        }
        return Index(root: root, path: path)
    }
}
/*:
 This takes $O(\log n)$ time, once again breaking `Collection`'s corresponding
 requirement. It would certainly be possible to fix this, but it seems trickier
 than in `RedBlackTree`, and it's unclear if the benefits would outweigh the
 effort, so we'll leave it like this for now. If this were a real package, we'd
 need to add a warning to the documentation pointing out the issue, in order to let our
 users know about it. (Some collection operations may become a lot slower as a
 result of this.)
 
 ### Index Validation
 
 Let's discuss index validation next. For `RedBlackTree2`, we need to invalidate all
 existing indices after every mutation, because the mutation may have modified
 or replaced some of the nodes on the path stored inside them.
 
 To do that, we need to verify that the tree's root is identical to the root
 reference in the index, and that they have the same mutation count. The root
 may be `nil` for a valid index in an empty tree, which complicates matters a
 little:
*/
extension RedBlackTree2.Index {
    fileprivate func isValid(for root: RedBlackTree2<Element>.Node?) -> Bool {
        return self.root === root 
            && self.mutationCount == root?.mutationCount
    }
}
/*:
 If this function doesn't trap, then we know it belongs to the correct
 tree, and also that the tree hasn't been mutated since the index was created.
 It's then safe to assume the index path consists of valid references.
 Otherwise, the path may contain zeroed references or nodes with modified values,
 so we must not look at it.
 
 To perform index comparisons, we need to check that the two indices belong to the
 same tree and that they're both valid for that tree. Here's a small static
 function to do that:
*/
extension RedBlackTree2.Index {
    fileprivate static func validate(_ left: RedBlackTree2<Element>.Index, _ right: RedBlackTree2<Element>.Index) -> Bool {
        return left.root === right.root
            && left.mutationCount == right.mutationCount
            && left.mutationCount == left.root?.mutationCount
    }
}
/*:
 ### Subscripting
 
 Subscripting by an index has a really exciting implementation because it
 contains not one, but two exclamation marks:
*/
extension RedBlackTree2 {
    public subscript(_ index: Index) -> Element {
        precondition(index.isValid(for: root))
        return index.path.last!.value!.value
    }
}
/*:
 The use of force unwraps here is justified — subscripting with `endIndex`
 should trap, and so should subscripting with an invalidated index. We could
 provide better error messages, but this will do just fine for now.
 
 ### Index Comparison
 
 Indices must be comparable. To implement this, we can simply retrieve the nodes
 at the end of the two index paths and compare their values, like we did in
 `RedBlackTree`. Let's see how we can get the current node of an index:
*/
extension RedBlackTree2.Index {
    /// Precondition: `self` is a valid index.
    fileprivate var current: RedBlackTree2<Element>.Node? {
        guard let ref = path.last else { return nil }
        return ref.value!
    }
}
/*:
 This property assumes the index is valid; otherwise, the force unwrap may
 fail and trap, crashing our program.
 
 We can now write the code for doing comparisons; it's similar to what we had
 before:
*/
extension RedBlackTree2.Index: Comparable {
    public static func ==(left: RedBlackTree2<Element>.Index, right: RedBlackTree2<Element>.Index) -> Bool {
        precondition(RedBlackTree2<Element>.Index.validate(left, right))
        return left.current === right.current
    }

    public static func <(left: RedBlackTree2<Element>.Index, right: RedBlackTree2<Element>.Index) -> Bool {
        precondition(RedBlackTree2<Element>.Index.validate(left, right))
        switch (left.current, right.current) {
        case let (a?, b?):
            return a.value < b.value
        case (nil, _):
            return false
        default:
            return true
        }
    }
}
/*:
 ### Index Advancement
 
 Finally, we need to implement index advancement. We'll do this by forwarding
 the job to a mutating method on the index type, which we'll write in a moment:
*/
extension RedBlackTree2 {
    public func formIndex(after index: inout Index) {
        precondition(index.isValid(for: root))
        index.formSuccessor()
    }

    public func index(after index: Index) -> Index {
        var result = index
        self.formIndex(after: &result)
        return result
    }
}
/*:
 To find the next index after an existing one, we need to look for the leftmost
 value under the current node's right subtree. If the current node has no right
 child, we need to back up to the nearest ancestor that has the current node
 inside its *left* subtree.
 
 If there's no such ancestor node, then we've reached the end of the
 collection. Having an empty path makes the index equal to the collection's `endIndex` in such a case,
 which is exactly what we want:
*/
extension RedBlackTree2.Index {
    /// Precondition: `self` is a valid index other than `endIndex`.
    mutating func formSuccessor() {
        guard let node = current else { preconditionFailure() }
        if var n = node.right {
            path.append(Weak(n))
            while let next = n.left {
                path.append(Weak(next))
                n = next
            }
        }
        else {
            path.removeLast()
            var n = node
            while let parent = self.current {
                if parent.left === n { return }
                n = parent
                path.removeLast()
            }
        }
    }
}
/*:
 For `BidirectionalCollection`, we also need to be able to step backward from any index.
 The code for doing this has the exact same structure as
 `index(before:)`, except we need to swap left and right, and we need to
 handle the `endIndex` specially:
*/
extension RedBlackTree2 {
    public func formIndex(before index: inout Index) {
        precondition(index.isValid(for: root))
        index.formPredecessor()
    }

    public func index(before index: Index) -> Index {
        var result = index
        self.formIndex(before: &result)
        return result
    }
}

extension RedBlackTree2.Index {
    /// Precondition: `self` is a valid index other than `startIndex`.
    mutating func formPredecessor() {
        let current = self.current
        precondition(current != nil || root != nil)
        if var n = (current == nil ? root : current!.left) {
            path.append(Weak(n))
            while let next = n.right {
                path.append(Weak(next))
                n = next
            }
        }
        else {
            path.removeLast()
            var n = current
            while let parent = self.current {
                if parent.right === n { return }
                n = parent
                path.removeLast()
            }
        }
    }
}
/*:
 ## Examples
 
 Phew, we're all done! Let's play around with this new type here:
*/
var set = RedBlackTree2<Int>()
for i in (1 ... 20).shuffled() {
    set.insert(i)
}
set

set.contains(13)

set.contains(42)

set.filter { $0 % 2 == 0 }
/*:
 ## Performance Benchmarks
 
 Running our usual benchmarks on `RedBlackTree2` gets us the results below.
 The curves for `insert`, `contains`, and `forEach` have shapes that are roughly similar
 to what we saw with `RedBlackTree`. But the `for-in` benchmark looks really
 weird!
 
 ![Figure 5.2: Benchmark results for `RedBlackTree2` operations. The plot shows input size vs. average execution time for a single iteration on a log-log chart.](Images/RedBlackTree2Benchmark.png)
 
 ### Optimizing Iteration Performance
 
 We redesigned our index type so that `index(after:)` has amortized constant
 time. We seem to have succeeded at this: the `for-in` curve is nicely flat,
 with only the slightest increase at large set sizes. But it's way high up on
 the chart! For sets smaller than 100,000 elements, apparently it's faster to
 insert an element than it is to iterate over one. That makes no sense.
 
 The figure below
 compares `for-in` performance between `RedBlackTree` and `RedBlackTree2`. We
 can see that `RedBlackTree2.index(after:)` is indeed an (amortized)
 constant-time operation: its curve remains flat even for huge sets.
 `RedBlackTree`'s logarithmic index advancement is asymptotically worse, but it
 starts much lower, so it only gets slower than `RedBlackTree2` at about 16
 million elements, which is far beyond the range displayed on our benchmarking chart.
 This isn't very impressive at all.
 
 ![Figure 5.3: Comparing the performance of `for-in` implementations in tree-based sorted sets.](Images/TreeIteration1.png)
 
 
 To make `RedBlackTree2` competitive with the primitive indices of `RedBlackTree`, we
 need to speed up its indexing operations by a factor of four. While this
 should be possible, it's not immediately obvious how we can achieve it.
 Regardless, let's try!
 
 One idea is to eliminate index validation, which is a major contributor to the
 cost of iteration. Completely removing it would normally be a bad idea, but in the
 special case of a `for-in` loop, it's unnecessary: the collection
 remains the same throughout the iteration, so validation can never fail. To get
 rid of it, we can replace `Collection`'s default `IndexingIterator` with a
 specialized implementation of `IteratorProtocol` that handles indices directly:
*/
extension RedBlackTree2 {
    public struct Iterator: IteratorProtocol {
        let tree: RedBlackTree2
        var index: RedBlackTree2.Index
        
        init(_ tree: RedBlackTree2) {
            self.tree = tree
            self.index = tree.startIndex
        }
    
        public mutating func next() -> Element? {
            if index.path.isEmpty { return nil }
            defer { index.formSuccessor() }
            return index.path.last!.value!.value
        }
    }
}

extension RedBlackTree2 {
    public func makeIterator() -> Iterator {
        return Iterator(self)
    }
}
/*:
 Note how the iterator includes an apparently redundant copy of the tree. Even
 though we never explicitly use this stored property in `next`, it still serves
 a critically important purpose: it retains the root node for us, guaranteeing
 that the tree doesn't get deallocated during the lifetime of the iterator.
 
 Defining this custom iterator speeds up our `for-in` benchmark by a factor of two.
 (See the `for-in2` curve in the chart below.)
 That's a nice speedup, but we wanted a 400% improvement, so let's try to find
 some other way to speed iteration up even further.
 
 ![Figure 5.4: Comparing the performance of `for-in` implementations in tree-based sorted sets. `RedBlackTree2.for-in2` eliminates unnecessary index validation steps by implementing a custom iterator, while `for-in3` replaces zeroing weak references with unowned-unsafe ones.](Images/TreeIteration2.png)
 
 A key observation is that our mutation count checks guarantee that the path of
 a valid index never has any expired weak references — because the tree it's
 associated with is still around, with the exact same nodes it had at the
 time the index was created. This implies that we can safely replace the path's
 weak references with `unowned(unsafe)` ones. Doing so eliminates all reference
 count management operations, speeding up iteration by another factor of two.
 (See the `for-in3` curve on the same figure.) This gets us to acceptable `for-in`
 performance, so we can stop optimizing for now.
 
 Choosing an asymptotically better indexing algorithm in `RedBlackTree2` didn't
 automatically provide faster results: the algorithmic advantage was swamped by
 less efficient implementation details. However, we were able to make the
 "better" algorithm competitive with the "worse" one by optimizing it. In this
 case, we got lucky, and we reached adequate performance after just two
 relatively simple optimization steps. Often we need to do much more!
 
 ### Insertion Performance
 
 With `RedBlackTree2`, we now have a really efficient, tree-based `SortedSet`
 implementation. As
 the chart below
 demonstrates, implementing in-place mutations resulted in a 300–500% boost in
 insertion performance. `RedBlackTree2.insert` is no slouch; it completes 4 million
 insertions in just 12 seconds. 
 
 ![Figure 5.5: Comparing the performance of four `insert` implementations.](Images/Insertion4.png)
 
 But it's still unable to outperform `SortedArray` below 8,000 elements: the
 latter can be as much as four times faster. Hmm. While it's certainly possible
 to optimize red-black tree insertions even further, it seems unlikely we'll be
 able to achieve a 400% speedup. What next, then?
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/