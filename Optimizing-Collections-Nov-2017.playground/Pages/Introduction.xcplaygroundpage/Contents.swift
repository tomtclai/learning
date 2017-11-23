/*:
 [Previous page](@previous)

 # Introduction
 
 Swift's concept of a collection is one of the core abstractions in the
 language. The primary collections in the standard library — arrays, sets, and
 dictionaries — are used in essentially all Swift programs, from the tiniest
 scripts to the largest apps. The specific ways they work feels familiar to all
 Swift programmers and gives the language a unique personality.
 
 When we need to design a new general-purpose collection type, it's important
 we follow the precedent established by the standard library. It's not
 enough to simply conform to the documented requirements of the `Collection`
 protocol: we also need to go the extra mile to match behavior with standard
 collection types. Doing this correctly is the essence of the elusive property of
 *swiftiness*, which is often so hard to explain, yet whose absence is so
 painfully noticeable.
 
 ## Copy-On-Write Value Semantics
 
 The most important quality expected of a Swift collection is *copy-on-write value semantics*. 
 
 In essence, *value semantics* in this context means that each variable holding
 a value behaves *as if* it held an independent copy of it, so that
 mutating a value held by one variable will never modify the value of another:
*/
var a = [2, 3, 4]
let b = a
a.insert(1, at: 0)
a
b
/*:
 In order to implement value semantics, the code above needs to copy the underlying
 array storage at some point to allow the two array instances to have different
 elements. For simple value types (like `Int` or `CGPoint`), the entire value is
 stored directly in the variable, and this copying happens automatically every
 time a new variable is initialized or whenever a new value is assigned to an
 existing variable.
 
 However, putting an `Array` value into a new variable (e.g. when we assign to
 `b`) does *not* copy its underlying storage: it just creates a new reference to
 the same heap-allocated buffer, finishing in constant time. The actual copying
 is deferred until one of the values using the same shared storage is
 mutated (e.g. in `insert`). Note though that mutations only need to copy the
 storage if the underlying storage is shared. If the array value holds the only
 reference to its storage, then it's safe to modify the storage buffer directly.
 
 When we say that `Array` implements the *copy-on-write* optimization, we're
 essentially making a set of promises about the performance of its operations
 so that they behave as described above.
 
 (Note that full value semantics is normally taken to mean some combination of
 abstract concepts with scary names like *referential transparency*,
 *extensionality*, and *definiteness*. Swift's standard collections violate each
 of these to a certain degree. For example, indices of one `Set` value aren't
 necessarily valid in another set, even if both sets contain the exact same
 elements. Therefore, Swift's `Set` isn't *entirely* referentially transparent.)
 
 ## The `SortedSet` Protocol
 
 
 To get started, we first need to decide what task we want to solve. One common
 data structure currently missing from the standard library is a sorted
 set type, i.e. a collection like `Set`, but one that requires its elements to
 be `Comparable` rather than `Hashable`, and that keeps its elements sorted in
 increasing order. So let's make one of these!
 
 The sorted set problem is such a nice demonstration of the various
 ways to build data structures that this entire book will be all about it. We're
 going to create a number of independent solutions, illustrating some
 interesting Swift coding techniques.
 
 Let's start by drafting a protocol for the API we want to implement. Ideally we'd want to create concrete types that conform to this protocol:

```swift
public protocol SortedSet: BidirectionalCollection, SetAlgebra {
    associatedtype Element: Comparable
}
```

 A sorted set is all about putting elements in a certain order, so it seems
 reasonable for it to implement `BidirectionalCollection`, allowing traversal in
 both front-to-back and back-to-front directions.
 
 `SetAlgebra` includes all the usual set operations like `union(_:)`,
 `isSuperset(of:)`, `insert(_:)`, and `remove(_:)`, along with initializers for
 creating empty sets and sets with particular contents. If our sorted set was
 intended to be a production-ready implementation, we'd definitely want to
 implement it. However, to keep this book at a manageable length, we'll only require a small subset of the full `SetAlgebra` protocol — just the two
 methods `contains` and `insert`, plus the parameterless initializer for
 creating an empty set:
*/
public protocol SortedSet: BidirectionalCollection, CustomStringConvertible, CustomPlaygroundQuickLookable where Element: Comparable {
    init()
    func contains(_ element: Element) -> Bool
    mutating func insert(_ newElement: Element) -> (inserted: Bool, memberAfterInsert: Element)
}
/*:
 In exchange for removing full `SetAlgebra` conformance,
 we added `CustomStringConvertible` and `CustomPlaygroundQuickLookable`;
 this is convenient when we want to display the contents of sorted sets in
 sample code and in playgrounds.
 
 The protocol `BidirectionalCollection` has about 30 member requirements (things
 like `startIndex`, `index(after:)`, `map`, and `lazy`). Thankfully, most of
 these have default implementations; at minimum, we only need to implement the
 five members `startIndex`, `endIndex`, `subscript`, `index(after:)`, and
 `index(before:)`. In this book we'll go a little further than that and also implement `forEach` and `count`. When it makes a difference, we'll also
 add custom implementations for `formIndex(after:)`, and `formIndex(before:)`.
 For the most part, we'll leave default implementations for everything else,
 even though we could sometimes write specializations that would work much
 faster.
 
 ## Semantic Requirements
 
 Implementing a Swift protocol usually means more than just conforming to its explicit requirements — most protocols come with an additional set of semantic requirements that aren't expressible in the type system, and these requirements need to be documented separately. Our `SortedSet` protocol is no different; what follows are five properties we expect all implementations to satisfy.
 
 1. **Ordering:** Elements inside the collection must be kept sorted. To be more specific: if `i` and `j` are both valid and subscriptable indices in some `set` implementing `SortedSet`, then `i < j` must be equivalent to `set[i] < set[j]`. (This also implies that our sets won't have duplicate elements.)
 
 2. **Value semantics:** Mutating an instance of a `SortedSet` type via one variable must not affect the value of any other variable of the same type. Conforming types must behave *as if* each variable held its own unique value, entirely independent of all other variables.
 
 3. **Copy-on-write:** Copying a `SortedSet` value into a new variable must be an $O(1)$ operation. Storage may be partially or fully shared between different `SortedSet` values. Mutations must check for shared storage and create copies when necessary to satisfy value semantics. Therefore, mutations may take longer to complete when storage is shared.
 
 4. **Index specificity:** Indices are associated with a particular `SortedSet` instance; they're only guaranteed to be valid for that specific instance and its unmutated direct copies. Even if `a` and `b` are `SortedSet`s of the same type containing the exact same elements, indices of `a` may not be valid in `b`. (This unfortunate relaxation of true value semantics seems to be technically unavoidable in general.)
 
 5. **Index invalidation:** Any mutation of a `SortedSet` *may* invalidate all existing indices of it, including its `startIndex` and `endIndex`. Implementations aren't *required* to always invalidate every index, but they're allowed to do so. (This point isn't really a requirement, because it's impossible to violate it. It's merely a reminder that unless we know better, we need to assume collection indices are fragile and should be handled with care.)
 
 Note that the compiler won't complain if we forget to implement any of these
 requirements. But it's still crucial that we implement them so that generic
 code working with sorted sets has consistent behavior.
 
 If we were writing a real-life, production-ready implementation of sorted
 sets, we wouldn't need the `SortedSet` protocol at all: we'd simply
 define a single type that implements all requirements directly. However, we'll
 be writing several variants of sorted sets, so it's nice to have a protocol
 that spells out our requirements and on which we can define extensions that are common to all such types.
 
 Before we even have a concrete implementation of `SortedSet`, let's get right into defining one such extension!
 
 ## Printing Sorted Sets
 
 It's useful to provide a default implementation for `description` so that we need
 not spend time on it later. Because all sorted sets are collections, we can
 use standard collection methods to print sorted sets the same way as the standard library's
 array or set values — as a comma-separated list of elements enclosed in brackets:
*/
extension SortedSet {
    public var description: String {
        let contents = self.lazy.map { "\($0)" }.joined(separator: ", ")
        return "[\(contents)]"
    }
}
/*:
 It's also worth creating a default implementation of
 `customPlaygroundQuickLook` so that our collections print a little better in
 playgrounds. The default Quick Look view can be difficult to understand, especially
 at a glance, so let's replace it with a simple variant that just sets the
 `description` in a monospaced font using an attributed string:
*/
#if os(iOS)
import UIKit

extension PlaygroundQuickLook {
    public static func monospacedText(_ string: String) -> PlaygroundQuickLook {
        let text = NSMutableAttributedString(string: string)
        let range = NSRange(location: 0, length: text.length)
        let style = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        style.lineSpacing = 0
        style.alignment = .left
        style.maximumLineHeight = 17
        text.addAttribute(.font, value: UIFont(name: "Menlo", size: 13)!, range: range)
        text.addAttribute(.paragraphStyle, value: style, range: range)
        return PlaygroundQuickLook.attributedString(text)
    }
}
#endif

extension SortedSet {
    public var customPlaygroundQuickLook: PlaygroundQuickLook {
        #if os(iOS)
            return .monospacedText(String(describing: self))
        #else
            return .text(String(describing: self))
        #endif
    }
}
/*:
 [Next page](@next)
*/