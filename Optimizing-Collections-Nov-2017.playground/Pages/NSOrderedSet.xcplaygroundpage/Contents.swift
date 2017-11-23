/*:
 [Previous page](@previous)

 # The Swiftification of `NSOrderedSet`
 
 
 The Foundation framework includes a class called `NSOrderedSet`. It's a
 relatively recent addition, first appearing in 2011 with iOS 5 and OS X 10.7
 Lion. `NSOrderedSet` was added to Foundation specifically in support of
 ordered relationships in Core Data.
 It works like a combination of `NSArray` and `NSSet`, implementing the API of
 both classes. It also provides both `NSSet`'s super fast $O(1)$ membership checks and
 `NSArray`'s speedy $O(1)$ random access indexing. The tradeoff is that it also
 inherits `NSArray`'s $O(n)$ insertions. Because `NSOrderedSet` is (most likely)
 implemented by wrapping an `NSSet` and an `NSArray`, it also has a higher memory
 overhead than either of these components.
 
 `NSOrderedSet` hasn't been bridged to Swift yet, so it seems like a nice
 subject for demonstrating how we can define thin wrappers around existing
 Objective-C classes to bring them closer to the Swift world.
 
 Despite its promising name, `NSOrderedSet` isn't really a good match for our
 use case. Although `NSOrderedSet` does keep its elements ordered, it doesn't enforce any
 particular ordering relation — you can insert elements in whichever order you
 like and `NSOrderedSet` will remember it for you, just like an array. Not
 having a predefined ordering is the difference between "ordered" and "sorted,"
 and this is why `NSOrderedSet` is not called `NSSortedSet`.
 Its primary purpose is to make lookup operations fast, but it
 achieves this using hashing rather than comparisons. (There's no equivalent to
 the `Comparable` protocol in `Foundation`; `NSObject` only provides the
 functionality of `Equatable` and `Hashable`.)
 
 But if `NSOrderedSet` supports whichever ordering we may choose to use, then it
 also supports keeping elements sorted according to their `Comparable`
 implementation. Clearly, this won't be the ideal use case for `NSOrderedSet`,
 but we should be able to make it work. So let's import Foundation and
 start working on hammering `NSOrderedSet` into a `SortedSet`:
*/
import Foundation
/*:
 Right off the bat, we run into a couple of major problems.
 
 First, `NSOrderedSet` is a class, so its instances are reference types. We want
 our sorted sets to have value semantics.
 
 Second, `NSOrderedSet` is a heterogeneous sequence — it takes `Any` members. We
 could still implement `SortedSet` by setting its `Element` type to `Any`, rather than leaving it
 as a generic type parameter, but
 that wouldn't feel like a real solution. What we really want is a generic
 homogeneous collection type, with the element type provided by a type
 parameter.
 
 So we can't just extend `NSOrderedSet` to implement our protocol. Instead,
 we're going to define a generic wrapper struct that internally uses an
 `NSOrderedSet` instance as storage. This approach is similar to what the Swift
 standard library does in order to bridge `NSArray`, `NSSet`, and `NSDictionary`
 instances to Swift's `Array`, `Set`, and `Dictionary` values. So we seem to be
 heading down the right track.
 
 What should we call our struct? It's tempting to call it `NSSortedSet`, and it
 would technically be possible to do so — Swift-only constructs don't depend on
 prefixes to work around (present or future) naming conflicts. On the other
 hand, for developers, `NS` still implies *Apple-provided*, so it'd be impolite
 and confusing to use it. Let's just go the other way and name our struct
 `OrderedSet`. (This name isn't quite right either, but at least it does resemble the name of the underlying data structure.)

```swift
public struct OrderedSet<Element: Comparable>: SortedSet {
    fileprivate var storage = NSMutableOrderedSet()
}
```

 We want to be able to mutate our storage, so we need to declare it as an
 instance of `NSMutableOrderedSet`, which is `NSOrderedSet`'s mutable subclass.
 
 ## Looking Up Elements
 
 We now have the empty shell of our data structure. Let's begin to fill it with
 content, starting with the two lookup methods, `forEach` and `contains`.
 
 `NSOrderedSet` implements `Sequence`, so it already has a `forEach` method.
 Assuming elements are kept in the correct order, we can simply
 forward `forEach` calls to `storage`. However, we need to manually downcast values
 provided by `NSOrderedSet` to the correct type:
*/
extension OrderedSet {
    public func forEach(_ body: (Element) -> Void) {
        storage.forEach { body($0 as! Element) }
    }
}
/*:
 `OrderedSet` is in full control of its own storage, so it can guarantee
 the storage will never contain anything other than an `Element`. This
 ensures the forced downcast will always succeed. But it sure is ugly!
 
 `NSOrderedSet` also happens to provide an implementation for `contains`, and it
 seems perfect for our use case. In fact, it's simpler to use than `forEach`
 because there's no need for explicit casting:

```swift
extension OrderedSet {
    public func contains(_ element: Element) -> Bool { 
        return storage.contains(element)  // BUG!
    }
}
```

 The code above compiles with no warnings, and it appears to work great when
 `Element` is `Int` or `String`. However, as we already mentioned,
 `NSOrderedSet` uses `NSObject`'s hashing API to speed up element lookups. But
 we don't require `Element` to be `Hashable`! How could this work at all?
 
 When we supply a Swift value type to a method taking an Objective-C object — as with `storage.contains` above, the compiler needs to box the value in a private
 `NSObject` subclass that it generates for this purpose. Remember that
 `NSObject` has built-in hashing APIs; you can't have an `NSObject` instance
 that doesn't support `hash`. So these autogenerated bridging classes must
 always have an implementation for `hash` that's consistent with `isEqual(:)`.
 
 If `Element` happens to be `Hashable`, then Swift is able to use the type's own
 `==` and `hashValue` implementations in the bridging class, so `Element` values
 get hashed the same way in Objective-C as in Swift, and everything works out
 perfectly.
 
 However, if `Element` doesn't implement `hashValue`, then the bridging class
 has no choice but to use the default `NSObject` implementations of both `hash`
 and `isEqual(_:)`. Because there's no other information available, these are
 based on the identity (i.e. the physical address) of the instances, which is
 effectively random for boxed value types. So two different bridged instances
 holding the exact same value will never be considered `isEqual(_:)` (or return
 the same `hash`).
 
 The upshot of all this is that the above code for `contains` compiles just
 fine, but it has a fatal bug: if `Element` isn't `Hashable`, then it always
 returns `false`. Oops!
 
 Oh dear. Lesson of the day: be very, very careful when using Objective-C APIs
 from Swift. Automatic bridging of Swift values to `NSObject` instances is
 extremely convenient, but it has subtle pitfalls. There's nothing in the code
 that explicitly warns about this problem: no exclamation marks, no explicit
 cast, nothing.
 
 Well, now we know we can't rely on `NSOrderedSet`'s own lookup methods in
 our case. Instead we have to look for some alternative APIs to find elements. Thankfully,
 `NSOrderedSet` also includes a method that was specifically designed for
 looking up elements when we know they're sorted according to some comparator
 function:

```swift
class NSOrderedSet: NSObject { // in Foundation
    ...
    func index(of object: Any, inSortedRange range: NSRange, options: NSBinarySearchingOptions = [], usingComparator: (Any, Any) -> ComparisonResult) -> Int
    ...
}
```

 Presumably this implements some form of binary search, so it should be fast
 enough. Our elements are sorted according to their `Comparable` implementation,
 so we can use Swift's `<` and `>` operators to define a suitable comparator
 function:
*/
extension OrderedSet {
    fileprivate static func compare(_ a: Any, _ b: Any) -> ComparisonResult 
    {
        let a = a as! Element, b = b as! Element
        if a < b { return .orderedAscending }
        if a > b { return .orderedDescending }
        return .orderedSame
    }
}
/*:
  
 We can use this comparator to define a method for getting the index for a
 particular element. This happens to be what `Collection`'s `index(of:)` method
 is supposed to do, so let's make sure our definition refines the default
 implementation of it:
*/
extension OrderedSet {
    public func index(of element: Element) -> Int? {
        let index = storage.index(
            of: element, 
            inSortedRange: NSRange(0 ..< storage.count),
            usingComparator: OrderedSet.compare)
        return index == NSNotFound ? nil : index
    }
}
/*:
 Once we have this function, `contains` reduces to a tiny transformation of its
 result:
*/
extension OrderedSet {
    public func contains(_ element: Element) -> Bool {
        return index(of: element) != nil
    }
}
/*:
 I don't know about you, but I found this a lot more complicated than I
 originally expected. The fine details of how values are bridged into
 Objective-C *sometimes* have far-reaching consequences that may break our code
 in subtle but fatal ways. If we aren't aware of these wrinkles, we may be
 unpleasantly surprised.
 
 `NSOrderedSet`'s flagship feature is that its `contains` implementation is
 super fast — so it's rather sad that we can't use it. But there's still hope!
 Consider that while `NSOrderedSet.contains` may mistakenly report `false` for
 certain types, it never returns `true` if the value isn't in fact in the set.
 Therefore, we can write a variant of `OrderedSet.contains` that still calls it
 as a shortcut, possibly eliminating the need for binary search:
*/
extension OrderedSet {
    public func contains2(_ element: Element) -> Bool {
        return storage.contains(element) || index(of: element) != nil
    }
}
/*:
 For `Hashable` elements, this variant will return `true` faster than
 `index(of:)`. However, it's slightly slower for values that aren't
 members of the set and for types that aren't hashable.
 
 ## Implementing `Collection`
 
 `NSOrderedSet` only conforms to `Sequence`, and not to `Collection`. (This isn't
 some unique quirk; its better-known friends `NSArray` and `NSSet` do the same.)
 Nevertheless, `NSOrderedSet` does provide some integer-based indexing methods
 we can use to implement `RandomAccessCollection` in our `OrderedSet` type:
*/
extension OrderedSet: RandomAccessCollection {
    public typealias Index = Int
    public typealias Indices = CountableRange<Int>

    public var startIndex: Int { return 0 }
    public var endIndex: Int { return storage.count }
    public subscript(i: Int) -> Element { return storage[i] as! Element }
}
/*:
 This turned out to be refreshingly simple.
 
 <!-- begin-exclude-from-preview -->
 
 ## Guaranteeing Value Semantics
 
 `SortedSet` requires value semantics, meaning we want every variable that
 contains a sorted set to behave as if it holds a unique copy of its value,
 completely independent of any other variable.
 
 We won't get this for free this time! Our `OrderedSet` struct consists of a
 reference to a class instance, so copying an `OrderedSet` value into another
 variable will just increment the reference count of the storage object.
 
 This means that two `OrderedSet` variables may easily share the same storage:

```swift
var a = OrderedSet()
var b = a
```

 Here's the result of the code above. Note how both variables have the same storage reference.
 
 ![Two `OrderedSet` values sharing a reference to the same storage object.](Images/NonUniqueStorage@3x.png)
 
 
 While storage may be shared, mutating methods like `insert` must nevertheless
 only modify the set instance that's held by the variable on which they were
 called. One way to implement this would be to always make a brand new copy of
 `storage` before we do anything that modifies it. However, that would be
 wasteful — it's often the case that the `OrderedSet` value we have holds the
 only reference to its storage, and in that case, it'd be safe to modify it
 directly, without cloning anything.
 
 The Swift standard library provides a function named
 `isKnownUniquelyReferenced` that can be called to determine if a particular
 reference to an object is the sole reference to it. If this function returns
 `true`, then we know nobody else holds a reference to the same object, so it's safe to modify it directly.
 
 (Note that this function only looks at strong references; it doesn't count
 weak and unowned references. So we can't *really* detect every case when
 somebody might be holding a reference. Luckily, this isn't a problem in our
 case, because `storage` is a private property — only code inside `OrderedSet`
 has access to it, and we'll never create such "hidden" references. Not
 counting weak/unowned references is a deliberate feature and not an accidental
 oversight; it allows indices of more complicated collections to include storage
 references without forcing COW copies when, say, an element is removed from a
 certain index. We'll see examples of such index definitions later in this book.)
 
 However, there's still a major gotcha: `isKnownUniquelyReferenced` never
 returns `true` for subclasses of `NSObject`, because such classes have their own
 reference count implementation that can't always guarantee a correct result. Of
 course, `NSOrderedSet` is a subclass of `NSObject`, so it looks like we're
 screwed. Woe is us!
 
 Oh but wait! If we extend `OrderedSet` to include a reference to some dummy
 Swift class, we can use this dummy reference to determine the uniqueness
 of the storage reference too. Copying an `OrderedSet` value will add new
 references to both its members, so the reference counts of both objects will
 always remain in sync. So let's modify the definition of `OrderedSet` to
 include an extra member:
*/
private class Canary {}

public struct OrderedSet<Element: Comparable>: SortedSet {
    fileprivate var storage = NSMutableOrderedSet()
    fileprivate var canary = Canary()
    public init() {}
}
/*:
 The sole purpose of `canary` is to indicate whether it's safe to mutate
 `storage`. (Another way of doing this would be to put the `NSMutableOrderedSet`
 reference *inside* the new Swift class. That would work just fine too.)
 
 Now we can define a method that ensures our storage is safe to
 modify:
*/
extension OrderedSet {
    fileprivate mutating func makeUnique() {
        if !isKnownUniquelyReferenced(&canary) {
            storage = storage.mutableCopy() as! NSMutableOrderedSet
            canary = Canary()
        }
    }
}
/*:
 Note that we need to create a new canary whenever we find the old one has
 expired. If we were to forget to do that, this function would continue copying the
 storage every time it's called.
 
 Now implementing value semantics becomes as simple as remembering to call
 `makeUnique` before mutating anything.
 
 ## Insertion
 
 Finally, let's do `insert`. The `insert` method in `NSMutableOrderedSet` works
 like the one in `NSMutableArray` — it takes an integer index for the new
 element:

```swift
class NSOrderedSet: NSObject { // in Foundation
    ...
    func insert(_ object: Any, at idx: Int)
    ...
}
```

 Thankfully, the `index(of:inSortedRange:options:usingComparator:)` method we
 used above can also be convinced to find the index where a new element should
 be inserted to maintain the sort order; we just
 have to set its `options` parameter to `.insertionIndex`. This way, it returns
 a valid index even when the element isn't already in the set:
*/
extension OrderedSet {
    fileprivate func index(for value: Element) -> Int {
        return storage.index(
            of: value, 
            inSortedRange: NSRange(0 ..< storage.count),
            options: .insertionIndex,
            usingComparator: OrderedSet.compare)
    }
}
/*:
 OK, now we're ready to do actual insertions. We just need to call `index(for:)`
 with the new element and check whether the element is already there or not:
*/
extension OrderedSet {
    @discardableResult
    public mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element) 
    {
        let index = self.index(for: newElement)
        if index < storage.count, storage[index] as! Element == newElement {
            return (false, storage[index] as! Element)
        }
        makeUnique()
        storage.insert(newElement, at: index)
        return (true, newElement)
    }
}
/*:
 We expended a considerable amount of effort implementing `makeUnique`; it'd be a shame if
 we forgot to call it above. But it's easy to make that mistake and then wonder
 why inserting a value into one set sometimes modifies some other sets too.
 
 That's all! We now have a second `SortedSet` implementation to play with.
 
 ## Let's See If This Thing Works
 
 Here's some code that inserts the numbers between 1 and 20 into a
 sorted set in random order:
*/
var set = OrderedSet<Int>()
for i in (1 ... 20).shuffled() {
    set.insert(i)
}
/*:
 The set is supposed to get the numbers sorted; let's see if it works
 correctly:
*/
set
/*:
 Terrific! How about `contains`? Does it find things correctly?
*/
set.contains(7)
set.contains(42)
/*:
 We should also be able to use `Collection`'s methods to manipulate sets. For
 example, let's try calculating the sum of all elements:
*/
set.reduce(0, +)
/*:
 OK, but did we get value semantics right?
*/
let copy = set
set.insert(42)
copy
set
/*:
 That seems to work too. Isn't it marvelous?
 
 We had to work extra to make sure our `OrderedSet` supports `Element`s
 that don't implement `Hashable`, so it makes sense to check that it works correctly now. Here's
 a simple comparable struct with a single integer property:
*/
import Foundation
struct Value: Comparable {
    let value: Int
    init(_ value: Int) { self.value = value }
    
    static func ==(left: Value, right: Value) -> Bool {
        return left.value == right.value
    }
    
    static func <(left: Value, right: Value) -> Bool {
        return left.value < right.value
    }
}
/*:
 When we convert `Value`s into `AnyObject`s, they get an `isEqual` implementation
 that doesn't use `==`, and the `hash` property returns some random-looking
 value, as promised:
*/
let value = Value(42)
let a = value as AnyObject
let b = value as AnyObject
a.isEqual(b)
a.hash
b.hash
/*:
 We can plug this type into our previous examples to verify `OrderedSet` doesn't rely on hashing to work correctly:
*/
var values = OrderedSet<Value>()
(1 ... 20).shuffled().map(Value.init).forEach { values.insert($0) }
values.contains(Value(7))
values.contains(Value(42))
/*:
 Yep, it seems to work fine.
 
 It's a good idea to try running your own tests in the playground version of the
 book. Also try switching to the buggy version of `contains` to see how it
 affects the results.
 
 ## Performance
 
 The figure below charts the performance of `OrderedSet` operations.
 The most remarkable aspect of this chart is the huge gap between `contains` and
 `contains2`. Evidently Foundation wasn't kidding about `NSOrderedSet.contains`
 being fast: it's about 15–25 times faster than binary search. Too bad it only
 works for hashable elements...
 
 ![Figure 3.2: Benchmark results for `OrderedSet` operations. The plot shows input size vs. average execution time for a single iteration on a log-log chart.](Images/OrderedSet.png)
 
 Interestingly enough, `contains2`, `forEach`, and `for-in` all seem to slow down after
 16,000 elements. `contains2` looks up random values in a hash table, so it's
 likely we can attribute its slowdown to cache/TLB thrashing like we did with
 `SortedArray.contains`. But this doesn't explain `forEach` and `for-in`: they
 just iterate over elements in the same order they appear in the set, so
 their curves should be perfectly flat. It's hard to say what's going on without
 reverse-engineering `NSOrderedSet`; it's a mystery!
 
 The curve for `OrderedSet.insert` ends with a quadratic tail, just like
 `SortedArray.insert`.
 The figure below
 pits these two insertion implementations against each other. Clearly,
 `NSOrderedSet` has a huge overhead compared to `Array` — at small element
 counts, the latter can be as much as 64 times faster.
 (Some of this is due to `NSOrderedSet`'s need for boxing up elements into an
 `NSObject`-derived element type; switching the element type from `Int` to a
 simple wrapper class around an integer value reduces the gap between the two
 algorithms to just 800%.)
 But after about 300,000
 elements, `NSOrderedSet` finally overcomes this disadvantage, and it actually
 finishes about two times faster than Swift arrays!
 
 ![Figure 3.3: Comparing the performance of two `insert` implementations.](Images/Insertion2.png)
 
 What's going on here? The standard library's definition for `Array` has
 extensive semantic annotations to help the compiler optimize code in ways not
 otherwise possible; the compiler is also able to inline `Array` methods to
 eliminate even the tiny cost of a function call and to detect further
 opportunities for optimization. How can some puny, unoptimizable Objective-C
 class be faster than `Array` is at inserting elements?
 
 Well, the secret is that `NSMutableOrderedSet` is probably built on top of
 `NSMutableArray`, which is not an array at all. It's a double-ended queue, or
 *deque* for short. Prepending a new element to the front of an `NSMutableArray`
 takes the same, constant amount of time as appending one to the end of it. This
 is in stark contrast to `Array.insert`, where inserting an element at position
 0 is an $O(n)$ operation; it needs to make room for the new element by moving
 every element one slot to the right. 
 
 By sliding elements toward either the front or the back,
 `NSMutableArray.insert` never needs to move more than half of the elements;
 thus, when we have enough elements for insertion time to be dominated by the
 task of moving stuff, `NSMutableArray.insert` is, on average, twice as fast as
 `Array.insert`, despite the Swift compiler's clever optimizations. That's cool!
 
 Overall though, this 200% speedup doesn't make up for `NSOrderedSet`'s slowness
 at smaller sizes. Plus, insertion still has the same $O(n^2)$ growth rate,
 which isn't impressive at all: creating an `OrderedSet` with 4 million
 elements takes more than 26 minutes. This may be better than `SortedArray`
 (which takes a little less than 50 minutes to do the same), but it's nothing to
 write home about.
 
 We've put a lot of effort into `NSOrderedSet`, but the resulting code seems overly complicated, fragile, and slow. Still, this chapter
 isn't a *complete* failure — we did create another correct implementation of
 `SortedSet`, and we've learned a great deal about writing Swift wrappers around
 legacy Objective-C interfaces, which is a useful skill to have.
 
 Is there a way to implement `SortedSet` that's meaningfully faster than
 `SortedArray`? Well, of course! But to do that, we need to learn about
 search trees.
 
 <!-- end-exclude-from-preview -->

 [Next page](@next)
*/