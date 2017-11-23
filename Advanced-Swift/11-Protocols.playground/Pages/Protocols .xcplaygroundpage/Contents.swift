/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Protocols 

In previous chapters, we saw how functions and generics can help us write very
dynamic programs. Protocols work together with functions and generics to enable
even more dynamic behavior.

Swift protocols aren't unlike Objective-C protocols. They can be used for
delegation, and they allow you to specify abstract interfaces (such as
`IteratorProtocol` or `Sequence`). Yet, at the same time, they're very different
from Objective-C protocols. For example, we can make structs and enums conform
to protocols. Additionally, protocols can have associated types. We can even add
method implementations to protocols using protocol extensions. We'll look at all
these things in the section on protocol-oriented programming.

Protocols allow for dynamic dispatch: the correct method implementation is
selected at runtime based on the type of the receiver. However, when a method is
or isn't dynamically dispatched is sometimes unintuitive, and this can lead to
surprising behavior. We'll look at this issue in the next section.

Regular protocols can be used either as type constraints or as standalone types.
Protocols with associated types and protocols with `Self` requirements, however,
are special: we can't use them as standalone types, so something like `let x:
Equatable` isn't allowed; we can only use them as type constraints, such as
`func f<T: Equatable>(x: T)`. This may sound like a small limitation, but it
makes protocols with associated types almost entirely different things in
practice. We'll take a closer look at this later. We'll also discuss type
erasers (such as `AnyIterator`) as a way of making it easier to work with
protocols with associated types.

In object-oriented programming, subclassing is a powerful way to share code
among multiple classes. A subclass inherits all the methods from its superclass
and can choose to override some of the methods. For example, we could have an
`AbstractSequence` class and subclasses such as `Array` and `Dictionary`. Doing
so allows us to add methods to `AbstractSequence`, and all the subclasses would
automatically inherit those methods.

Yet in Swift, the code sharing in `Sequence` is implemented using protocols and
protocol extensions. In this way, the `Sequence` protocol and its extensions
also work with value types, such as structs and enums, which don't support
subclassing.

Not relying on subclassing also makes types more flexible. In Swift (as in most
other object-oriented languages), a class can only have a single superclass.
When we create a class, we have to choose the superclass well, because we can
only pick one; we can't subclass both `AbstractSequence`, and, say, `Stream`.
This can sometimes be a problem. There are examples in Cocoa — e.g. with
`NSMutableAttributedString`, where the designers had to choose between
`NSAttributedString` and `NSMutableString` as a superclass.

Some languages have multiple inheritance, the most common being C++. But this
leads to something called the "[diamond
problem](https://en.wikipedia.org/wiki/Multiple_inheritance#The_diamond_problem)."
For example, if multiple inheritance were possible, we could envision an
`NSMutableAttributedString` that inherits from both `NSMutableString` and
`NSAttributedString`. But what happens if both of those classes override a
method of `NSString`? You could deal with it by just picking one of the methods.
But what if that method is `isEqual:`? Providing good behavior for multiple
inheritance is really hard.

Because multiple inheritance is so complicated, most languages don't support it.
Yet many languages do support conforming to multiple protocols, which doesn't
have the same problems. In Swift, we can conform to multiple protocols, and the
compiler warns us when the use of a method is ambiguous.

Protocol extensions are a way of sharing code without sharing base classes.
Protocols define a minimal viable set of methods for a type to implement.
Extensions can then build on these minimal methods to implement more complex
features.

For example, to implement a generic algorithm that sorts any sequence, you need
two things. First, you need a way to iterate over the elements. Second, you need
to be able to compare the elements. That's it. There are no demands as to how
the elements are held. They could be in a linked list, an array, or any iterable
container. What they are doesn't matter, either — they could be strings,
integers, dates, or people. As long as you write down the two aforementioned
constraints in the type system, you can implement `sort`:

``` swift-example
extension Sequence where Element: Comparable {
    func sorted() -> [Element]
}
```

To implement an in-place sort, you need more building blocks. More specifically,
you need index-based access to the elements rather than just linear iteration.
`Collection` captures this and `MutableCollection` adds mutation to it. Finally,
you need to compare and offset indices in constant time.
`RandomAccessCollection` allows for that. This may sound complex, but it
captures the prerequisites needed to perform an in-place sort:

``` swift-example
extension MutableCollection where
    Self: RandomAccessCollection, Element: Comparable {
        mutating func sort()
}

```

Minimal capabilities described by protocols compose well. You can add different
capabilities of different protocols to a type, bit by bit. We saw this in the
collection protocols chapter when we first built a `List` type by giving it a
single method, `cons`. Without changing the original `List` struct, we made it
conform to `Sequence`. In fact, we could've done this even if we weren't the
original authors of this type, using a technique called *retroactive modeling*.
By adding conformance to `Sequence`, we get all the extension methods of
`Sequence` for free.

Adding new shared features via a common superclass isn't this flexible. You
can't just decide later to add a new common base class to many different
classes; that would be a major refactoring. And if you aren't the owner of these
subclasses, you can't do it at all\!

Subclasses have to know which methods they can override without breaking the
superclass. For example, when a method is overridden, a subclass might need to
call the superclass method at the right moment: either at the beginning,
somewhere in the middle, or at the end of the method. This moment is often
unspecified. Also, by overriding the wrong method, a subclass might break the
superclass without warning.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
