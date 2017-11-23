/*:
 [Previous page](@previous)

 # Sorted Arrays
 
 
 Possibly the most straightforward way to implement `SortedSet` is by storing
 the set's elements in an array. This leads to the definition of a simple
 structure like the one below:
*/
public struct SortedArray<Element: Comparable>: SortedSet {
    fileprivate var storage: [Element] = []
    
    public init() {}
}
/*:
 To help satisfy the protocol requirements, we'll always keep the `storage`
 array sorted, hence the name `SortedArray`.
 
 ## Binary Search
 
 To implement `insert` and `contains`, we'll need a method that, given an
 element, returns the position in the storage array that should hold the element.
 
 To do this fast, we need to implement the *binary search algorithm*. This
 algorithm works by cutting the array into two equal halves, discarding the one that
 doesn't contain the element we're looking for, and repeating this process until the array is
 reduced to a single element. Here's one way to do this in Swift:
*/
extension SortedArray {
    func index(for element: Element) -> Int {
        var start = 0
        var end = storage.count
        while start < end {
            let middle = start + (end - start) / 2
            if element > storage[middle] {
                start = middle + 1
            }
            else {
                end = middle
            }
        }
        return start
    }
}
/*:
 Note that the loop above needs to perform just one more iteration whenever we
 double the number of elements in the set. That's rather cheap! This is what
 people mean when they say binary search has *logarithmic complexity*: its
 running time is roughly proportional to the logarithm of the size of the data.
 (The big-O notation for such a function is $O(\log n)$.)
 
 Binary search is deceptively short, but it's a rather delicate algorithm that
 can be tricky to implement correctly. It includes a lot of subtle index
 arithmetic, and there are ample opportunities for off-by-one errors, overflow
 problems, or other mistakes. For example, the expression `start + (end - start) /
 2` seems like a strange way to calculate the middle index; we'd normally
 write `(start + end) / 2` instead. However, these two expressions don't always
 have the same results: the second version contains an addition that may
 overflow if the collection is huge, thereby resulting in a runtime error.
 
 Hopefully a generic binary search method will get added to the Swift standard
 library at some point. Meanwhile, if you ever need to implement it, please find
 a good algorithms book to use as a reference (though I guess this book will
 do in a pinch too). Don't forget to test your code; sometimes even books have
 bugs! I find that 100% unit test coverage works great for catching most of my
 own errors.
 
 Our `index(for:)` function does something similar to `Collection`'s standard
 `index(of:)` method, except our version always returns a valid index, even if
 the element isn't currently in the set. This subtle but very important
 difference will make `index(for:)` usable for insertion too.
 
 ## Lookup Methods
 
 Having mentioned `index(of:)`, it's a good idea to define it in terms of
 `index(for:)` so that it uses the better algorithm too:
*/
extension SortedArray {
    public func index(of element: Element) -> Int? {
        let index = self.index(for: element)
        guard index < count, storage[index] == element else { return nil }
        return index
    }
}
/*:
 The default implementation in `Collection` executes a linear search by enumerating all elements until it finds the one we're looking for, or until it
 reaches the end of the collection. This specialized variant can be much, *much*
 faster than that.
 
 Checking for membership requires a bit less code because we only need to see if the element is there:
*/
extension SortedArray {
    public func contains(_ element: Element) -> Bool {
        let index = self.index(for: element)
        return index < count && storage[index] == element
    }
}
/*:
 Implementing `forEach` is even easier because we can simply forward the call
 to our storage array. The array is already sorted, so the method will visit
 elements in the correct order:
*/
extension SortedArray {
    public func forEach(_ body: (Element) throws -> Void) rethrows {
        try storage.forEach(body)
    }
}
/*:
 While we're here, it's a good idea to look for other `Sequence` and
 `Collection` members that would benefit from a specialized implementation. For
 example, sequences with `Comparable` elements have a `sorted()` method that
 returns a sorted array of all elements in the sequence. For `SortedArray`, this
 can be implemented by simply returning `storage`:
*/
extension SortedArray {
    public func sorted() -> [Element] {
        return storage
    }
}
/*:
 ## Insertion
 
 To insert a new element into a sorted set, we first find its
 corresponding index using `index(for:)` and then check if the element
 is already there. To maintain the invariant that a `SortedSet` may not contain duplicates, we only insert the element into the `storage` if it's not present:
*/
extension SortedArray {
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) 
    {
        let index = self.index(for: newElement)
        if index < count && storage[index] == newElement {
            return (false, storage[index])
        }
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
}
/*:
 ## Implementing Collection
 
 Next up, let's implement `BidirectionalCollection`. Since we're storing
 everything in a single `Array`, the easiest way to do this is to simply share
 indices between `SortedArray` and its `storage`. By doing this, we'll be able
 to forward most collection methods to the `storage` array, which drastically
 simplifies our implementation.
 
 `Array` implements more than `BidirectionalCollection`: it is in fact a
 `RandomAccessCollection`, which has the same API surface but much stricter semantic requirements.
 `RandomAccessCollection` requires efficient index arithmetic: we must be able to both offset an index by any amount and measure the distance between any two indices in constant time.
 
 Since we're going to forward everything to `storage` anyway, it makes sense for
 `SortedArray` to implement the same protocol:
*/
extension SortedArray: RandomAccessCollection {
    public typealias Indices = CountableRange<Int>

    public var startIndex: Int { return storage.startIndex }
    public var endIndex: Int { return storage.endIndex }

    public subscript(index: Int) -> Element { return storage[index] }
}
/*:
 This completes the implementation of the `SortedSet` protocol. Yay! 
 
 ## Examples
 
 
 Let's check if it all works:
*/
var set = SortedArray<Int>()
for i in (0 ..< 22).shuffled() {
    set.insert(2 * i)
}
set

set.contains(42)

set.contains(13)
/*:
 It seems to work just fine. But does our new collection have value
 semantics?
*/
let copy = set
set.insert(13)

set.contains(13)

copy.contains(13)
/*:
 It sure looks like it! We didn't have to do anything to implement value
 semantics; we got it by the mere fact that `SortedArray` is a struct consisting
 of a single array. Value semantics is a composable property: structs with
 stored properties that all have value semantics automatically behave the same way
 too.
 
 ## Performance
 
 
 When we talk about the performance of an algorithm, we often use the so-called
 *big-O notation* to describe how changing the input size affects the running
 time: $O(1)$, $O(n)$, $O(n^2)$, $O(\log n)$, $O(n\log n)$, and so on. This notation
 has a precise mathematical definition, but you don't really have to look it up
 — it's enough to understand that we use this notation as shorthand for classifying
 the *growth rate* of our algorithms. When
 we double the size of its input, an $O(n)$ algorithm will take no more than
 twice the time, but an $O(n^2)$ algorithm might become as much as four times
 slower. We expect that an $O(1)$ algorithm will run for roughly the same time
 no matter what input it gets.
 
 We can mathematically analyze our algorithms to formally derive such asymptotic
 complexity estimates. This analysis provides useful indicators of performance,
 but it isn't infallible; by its very nature, it relies on simplifications that
 may or may not match actual behavior for real-world working sets running on
 actual hardware.
 
 To get an idea of the actual performance of our `SortedSet` implementations, it's therefore useful to run some benchmarks. For example, here's the code for
 one possible microbenchmark that measures four basic operations — `insert`, `contains`, `forEach`, and iteration using a `for` statement — on a `SortedArray`:

```swift
func benchmark(count: Int, measure: (String, () -> Void) -> Void) {
    var set = SortedArray<Int>()
    let input = (0 ..< count).shuffled()
    measure("SortedArray.insert") {
        for value in input {
            set.insert(value)
        }
    }

    let lookups = (0 ..< count).shuffled()
    measure("SortedArray.contains") {
        for element in lookups {
            guard set.contains(element) else { fatalError() }
        }
    }
    
    measure("SortedArray.forEach") {
        var i = 0
        set.forEach { element in
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
    
    measure("SortedArray.for-in") {
        var i = 0
        for element in set {
            guard element == i else { fatalError() }
            i += 1
        }
        guard i == input.count else { fatalError() }
    }
}
```

 The `measure` parameter is some function that measures the execution time of
 the closure that's given to it and files it under the name given as its first
 parameter. One simple way to drive this `benchmark` function is to call it in a
 loop of various sizes, printing measurements as we get them:

```swift
for size in (0 ..< 20).map({ 1 << $0 }) {
    benchmark(size: size) { name, body in 
        let start = Date()
        body()
        let end = Date()
        print("\(name), \(size), \(end.timeIntervalSince(start))")
    }
}
```

 This is a simplified version of the actual Attabench benchmarks I ran to
 draw the plots below. The real code has a lot more benchmarking boilerplate,
 but the actual measurements (the code inside the `measure` closures) are
 exactly the same.
 
 Plotting our benchmark results gets us the chart below.
 Note that in this chart, we're using logarithmic scales on both axes: moving
 one notch to the right doubles the number of input values, while moving up by
 one horizontal line indicates a tenfold increase in execution time.
 
 ![Benchmark results for `SortedArray` operations, plotting input size vs. overall execution time on a log-log chart.](Images/SortedArray-raw.png)
 
 Such log-log plots are usually the best way to display benchmarking results.
 They fit a huge range of data on a single chart without letting large values
 overwhelm small ones — in this case, we can easily compare execution
 times from a single element, up to 4 million of them: a difference of 22 binary
 orders of magnitude!
 
 Additionally, log-log plots make it easy to estimate the actual complexity
 costs an algorithm exhibits. If a section of a benchmark plot is
 a straight line segment, then the relationship between input size and execution
 time can be approximated by a multiple of a simple polynomial function, such as
 $n$, $n^2$, or even $\sqrt n$. The exponent is related to the slope of the line:
 the slope of $n^2$ is double that of $n$. With some practice, you'll be able to
 recognize the most frequently occurring relationships at a glance — there's no
 need for complicated analysis.
 
 In our case, we know that simply iterating over all the elements inside an
 array should take $O(n)$ time, and this is confirmed by the plots.
 `Array.forEach` and the `for-in` loop cost pretty much the same, and after an
 initial warmup period, they both become straight lines. It takes a little
 more than three steps to the right for the line to go a single step up, which
 corresponds to $2^{3.3} \approx 10$, proving a simple linear relationship.
 
 Looking at the plot for `SortedArray.insert`, we find it gradually turns into a
 straight line at about 4,000 elements, and the slope of the line is roughly
 double that of `SortedArray.forEach` — so it looks like the execution time of
 insertion is a quadratic function of the input size. Luckily, this matches our
 expectations: each time we insert a random element into a sorted array, we have
 to make space for it by moving (on average) half of the existing elements one
 slot to the right. So a single insertion is a linear operation, which makes $n$
 insertions cost $O(n^2)$.
 
 `SortedArray.contains` does $n$ binary searches, each taking $O(\log n)$ time,
 so it's supposed to be an $O(n\log n)$ function. It's hard to see
 this
 in the chart above,
 but you can verify it if you look close enough: its curve is
 almost parallel to that of `forEach`, except it subtly drifts upward — it's
 not a perfectly straight line. One easy way to verify this is by putting the
 edge of a piece of paper next to the `contains` plot: it curves away from the
 paper's straight edge, indicating a superlinear relationship.
 
 To highlight the difference between $O(n)$ and $O(n\log n)$ functions,
 it's useful to divide execution times by the input size, resulting in a chart
 that displays the average execution time spent on a single element. (I like to
 call this type of plot an *amortized chart*. I'm not sure the word
 *amortized* fits this context, but it does sound impressive!) The division
 eliminates the consistent slope of $O(n)$, making it easier to distinguish
 linear and logarithmic factors.
 Here is such a chart for `SortedArray.` 
 Note how `contains` now has a distinct (if slight) upward slope, while the tail of `forEach` is perfectly flat.
 
 ![Benchmark results for `SortedArray` operations, plotting input size vs. average execution time for a single operation on a log-log chart.](Images/SortedArray.png)
 
 The curve for `contains` has a couple of surprises. First, it has clear spikes
 at powers-of-two sizes. This is due to an interesting interaction between
 binary search and the architecture of the level 2 (L2) cache in the MacBook
 running the benchmarks. The cache is divided into 64-byte *lines*,
 each of which may hold the contents of main memory from a specific set of
 physical addresses. By an unfortunate coincidence, if the storage size is close
 to a perfect power of two, successive lookup operations of the binary search
 algorithm tend to all fall into the same L2 cache line, quickly exhausting its
 capacity, while other lines remain unused. This effect is called *cache line
 aliasing*, and it can evidently lead to a quite dramatic slowdown: `contains`
 takes about twice as long to execute at the top of the spikes than at nearby
 sizes. 
 
 <!-- citation: https://www.pvk.ca/Blog/2012/07/30/binary-search-is-a-pathological-case-for-caches/ -->
 
 One way to eliminate these spikes is to switch to *ternary search*, dividing
 the buffer into *three* equal slices on each iteration. An even simpler
 solution is to perturb binary search, selecting a slightly off-center middle
 index. To do this, we just need to modify a single line in the implementation
 of `index(for:)`, adding a small extra offset to the middle index:
*/
extension SortedArray {
    func index2(for element: Element) -> Int {
        var start = 0
        var end = storage.count
        while start < end {
            let middle = start + (end - start) / 2 + (end - start) >> 6
            if element > storage[middle] {
                start = middle + 1
            }
            else {
                end = middle
            }
        }
        return start
    }

    public func contains2(_ element: Element) -> Bool {
        let index = self.index2(for: element)
        return index < count && storage[index] == element
    }
    
    func index3(for element: Element) -> Int {
        var start = 0
        var end = storage.count
        while start < end {
            let diff = end - start
            if diff < 1024 {
                let middle = start + diff >> 1
                if element > storage[middle] {
                    start = middle + 1
                }
                else {
                    end = middle
                }
            }
            else {
                let third = diff / 3
                let m1 = start + third
                let m2 = end - third
                let v1 = storage[m1]
                let v2 = storage[m2]
                if element < v1 {
                    end = m1
                }
                else if element > v2 {
                    start = m2 + 1
                }
                else {
                    start = m1
                    end = m2 + 1
                }
            }
        }
        return start
    }
    
    public func contains3(_ element: Element) -> Bool {
        let index = self.index3(for: element)
        return index < count && storage[index] == element
    }
}
/*:
```swift
let middle = start + (end - start) / 2 + (end - start) >> 6
```

 This way, the middle index will fall $33/64$ the way between the two endpoints, which is enough to prevent cache line aliasing. Unfortunately, the code
 is now a tiny bit more complicated, and these off-center middle indices
 generally result in slightly more storage lookups than regular binary search.
 So the price of eliminating the power-of-two spikes is a small overall
 slowdown, as demonstrated:
 by the chart below.
 
 ![Comparing the performance of binary search (`contains`) to a variant that prevents cache line aliasing by selecting slightly off-center indices for the middle value (`contains2`).](Images/SortedArray-contains.png)
 
 The other surprise of the `contains` curve is that it seems to turn slightly
 upward at about 64k elements or so.
 (If you look closely, you may actually detect a similar, although less
 pronounced, slowdown for `insert`, starting at about a million elements.)
 At this size, my MacBook's virtual memory subsystem was unable to keep the
 physical address of all pages of the `storage` array in the CPU's address cache
 (called the Translation Lookaside Buffer, or TLB for short). The `contains`
 benchmark randomizes lookups, so its irregular access patterns lead to frequent
 TLB cache misses, considerably increasing the cost of memory accesses.
 Additionally, as the storage array gets larger, its sheer size overwhelms L1
 and L2 caches, and those cache misses contribute a great deal of additional
 latency.
 
 At the end of the day, it looks like random memory accesses in a large enough
 contiguous buffer take $O(\log n)$-ish time, not $O(1)$ — so the asymptotic
 execution time of our binary search is in fact more like $O(\log n\log n)$, and not
 $O(\log n)$ as we usually believe. Isn't that interesting? (The slowdown
 disappears if we remove the shuffling of the `lookups` array in the benchmark
 code above. Try it!)
 
 On the other hand, for small sizes, the `contains` curve keeps remarkably close
 to `insert`. Some of this is just a side effect of the logarithmic scale: at
 their closest point, `contains` is still 80% faster than insertion. But the
 `insert` curve looks surprisingly flat up to about 1,000 elements; it seems that
 as long as the sorted array is small enough, the average time it takes to
 insert a new element into it is basically independent of the size of the array.
 (I believe this is mostly a consequence of the fact that at these sizes, the
 entire array fits into the L1 cache of the CPU.) 
 
 So `SortedArray.insert` seems to be astonishingly fast as long as the array is
 small. For now, we can file this factoid away as mildly interesting
 trivia. Keep it in mind though, because this fact will have
 serious consequences in later parts of this book.

 [Next page](@next)
*/