/*:
 [Previous page](@previous)

 # Conclusion
 
 In this book, we've discussed seven different ways to implement the same simple
 collection type. Every time we created a new solution, our code became
 incrementally more complicated, but in exchange, we gained substantial
 performance improvements. This is perhaps best demonstrated by the steady downward
 progress of our successive insertion implementations on the benchmark chart.
 
 ![Figure 8.1: Comparing insertion performance of five `SortedSet` implementations to the amortized per-element cost of `Array.sort`.](Images/InsertionSummary.png)
 
 Is it possible to implement an even faster `SortedSet.insert`? Well, `BTree3`
 certainly has room for some additional micro-optimizations; I think a 5–10%
 improvement is definitely possible. Investing even more effort would perhaps
 get us 20%.
 
 But is it possible we missed some clever optimization trick that would get
 us another huge performance jump of 200–400%? I don't believe so.
 
 First of all, note that by inserting a bunch of elements into a sorted set, we're
 essentially sorting them. We could also do that by simply calling
 `Array.sort`, which implements the super speedy [Introsort] sorting algorithm.
 The last line in the chart above depicts the amortized time `Array.sort`
 spends on each element. In a very real sense, `Array.sort` sets a hard upper
 limit on the performance we can expect out of any sorted set.
 
 [Introsort]: http://www.cs.rpi.edu/~musser/gp/introsort.ps
 
 At typical sizes, sorting elements by calling `BTree3.insert` in a loop is
 *just 3.5 times slower* than `Array.sort`. This is already *amazingly* close!
 Consider that the `BTree3` benchmark processes each element individually and
 keeps existing elements neatly sorted after each insertion. I find it surprising
 that `BTree3.insert` gets so close despite such a huge handicap, and I'd be shocked to learn about a new `SortedSet` implementation that improves on B-trees by even 50%.
 
 ## Implementing Insertion in Constant Time
 
 Although it may not be possible to drastically improve on `BTree3` while fully
 implementing all `SortedSet` requirements, we can always speed things up by
 cheating!
 
 For example, `SillySet` in the code below implements the syntactic requirements
 of the `SortedSet` protocol with an `insert` method that takes $O(1)$ time. It
 runs circles around `Array.sort` in the `insert` benchmark above without even
 breaking a sweat:
*/
struct SillySet<Element: Hashable & Comparable>: SortedSet, RandomAccessCollection {
    typealias Indices = CountableRange<Int>

    class Storage {
        var v: [Element]
        var s: Set<Element>
        var extras: Set<Element> = []
    
        init(_ v: [Element]) { 
            self.v = v
            self.s = Set(v) 
        }
    
        func commit() {
            guard !extras.isEmpty else { return }
            s.formUnion(extras)
            v += extras
            v.sort()
            extras = []
        }
    }

    private var storage = Storage([])
    
    var startIndex: Int { return 0 }
    
    var endIndex: Int { return storage.s.count + storage.extras.count }
    
    // Complexity: `O(n*log(n))`, where `n` is the number of insertions since the last time `subscript` was called.
    subscript(i: Int) -> Element {
        storage.commit()
        return storage.v[i]
    }
    
    // Complexity: O(1)
    func contains(_ element: Element) -> Bool {
        return storage.s.contains(element) || storage.extras.contains(element)
    }
    
    // Complexity: O(1) unless storage is shared.
    mutating func insert(_ element: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        if !isKnownUniquelyReferenced(&storage) {
            storage = Storage(storage.v)
        }
        if let i = storage.s.index(of: element) { return (false, storage.s[i]) }
        return storage.extras.insert(element)
    }
}
/*:
 Of course, there are many problems with this code: for example, it requires
 `Element` to be hashable, and it violates `Collection` requirements by
 implementing subscript in $O(n \log n)$ time — which is absurdly long. But the
 problem I find most vexing is that `SillySet`'s indexing subscript modifies its
 underlying storage by side effect — this breaks my assumptions about what value
 semantics mean in Swift. (For example, it makes it dangerous to pass
 `SillySet` values between threads; even read-only concurrent access may
 result in data races.)
 
 This particular example might be silly, but the idea of deferring the execution
 of successive insertions by collecting such elements into a separate buffer has
 a lot of merit. Creating a sorted set by individually inserting a bunch of
 elements in a loop isn't very efficient at all. It's a lot quicker to first
 sort the elements in a separate buffer and then use special [bulk loading
 initializers][bulk] to convert the buffer into a B-tree in linear time.
 
 [bulk]: https://github.com/lorentey/BTree/blob/v4.0.2/Sources/BTreeBuilder.swift
 
 Bulk loading works by exploiting the fact that we don't care whether its
 intermediate states satisfy sorted set requirements — we never look at elements
 of a half-loaded set.
 
 It's important to recognize opportunities for this type of optimization,
 because they allow us to *temporarily* escape our usual constraints, often resulting
 in performance boosts that wouldn't otherwise be possible.
 
 ## Farewell
 
 I hope you enjoyed reading this book! I had a lot of fun putting it together.
 Along the way, I learned a great deal about implementing collections in
 Swift, and hopefully you picked up a couple of new tricks too.
 
 Throughout this book, we explored a number of different ways to solve the
 particular problem of building a sorted set, concentrating on benchmarking our
 solutions in order to find ways to improve their performance.
 
 However, none of our implementations were complete, as the code we wrote was never
 really good enough for production use. To keep the book *relatively* short and
 to the point, we took some shortcuts that would be inappropriate to take in a
 real package.
 
 Indeed, even our `SortedSet` protocol was simplified to the barest minimum: we
 cut most of the methods of `SetAlgebra`. For instance, we never discussed how
 to implement the `remove` operation. Somewhat surprisingly, it's usually much
 harder to remove elements from a balanced tree than it is to insert them. (Try it!)
 
 We didn't spend time examining all the other data types we can build
 out of balanced search trees. Tree-based sorted maps, lists, and straightforward
 variants like multisets and multimaps are just as important as sorted sets; it
 would've been interesting to see how our code could be adapted to implement
 them.
 
 We also didn't explain how these implementations could be tested. This is a
 particularly painful omission, because the code we wrote was often tricky, and
 we sometimes used unsafe constructs, where the slightest mistake could result
 in scary memory corruption issues and days of frustrating debugging work.
 
 Testing is hugely important; unit tests in particular provide a safety net
 against regressions and are pretty much a prerequisite to any kind of
 optimization work. Data structures lend themselves to unit testing especially
 well: their operations take easy-to-generate input and they produce
 well-defined, easily validatable output. Powerful packages like [SwiftCheck]
 provide easy-to-use tools for providing full test coverage.
 
 [SwiftCheck]: https://github.com/typelift/SwiftCheck
 
 That said, testing COW implementations can be a challenging task. If we aren't
 careful enough about not making accidental strong references before calling
 `isKnownUniquelyReferenced`, our code will still produce correct results — it
 will just do it a lot slower than we expect. We don't normally check for
 performance issues like this in unit tests, and we need to specially instrument
 our code to easily catch them.
 
 On the other hand, if we simply forget to ensure we don't mutate shared
 storage, our code will also affect variables holding unmutated copies. This
 kind of *unexpected action at a distance* can be extremely hard to track down,
 because our operation breaks values that aren't explicitly part of its input or
 output. To ensure we catch this error, we need to write unit tests that
 specifically check for it — normal input/output checks won't necessarily
 detect it, even if we otherwise have 100% test coverage.
 
 We did briefly mention that by adding element counts to the nodes of a search
 tree, we can find the $i$th smallest or largest element in the tree in $O(\log
 n)$ time. This trick can in fact be generalized: search trees can be augmented
 to speed up the calculation of any associative binary operation over arbitrary
 ranges of elements. Augmentation is something of a secret weapon in algorithmic
 problem solving: it enables us to easily produce efficient solutions to many
 complicated-looking problems. We didn't have time to explain how to implement
 augmented trees or how we might solve problems using them.
 
 Still, this seems like a good point to end the book. We've found what seems to
 be the best data structure for our problem, and we're now ready to start
 working on building it up and polishing it into a complete, production-ready
 package. This is by no means a trivial task: we looked at the implementation of
 half a dozen or so operations, but we need to write, test, and document dozens
 more!
 
 If you liked this book and you'd like to try your hand at optimizing
 production-quality collection code, take a look my
 [`BTree` package][BTree-GitHub] on GitHub. At the time of writing, 
 the most recent version of this package
 doesn't even implement some of the optimizations in our original B-tree code,
 much less any of the advanced stuff in Chapter 7. There's lots of room for
 improvement, and your contributions are always welcome.
 
 [BTree-GitHub]: https://github.com/lorentey/BTree

 [Next page](@next)
*/