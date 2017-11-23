/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Introduction

*Advanced Swift* is quite a bold title for a book, so perhaps we should start
with what we mean by it.

When we began writing the first edition of this book, Swift was barely a year
old. We did so before the beta of 2.0 was released — albeit tentatively, because
we suspected the language would continue to evolve as it entered its second
year. Few languages — perhaps no other language — have been adopted so rapidly
by so many developers.

But that left people with unanswered questions. How do you write "idiomatic"
Swift? Is there a correct way to do certain things? The standard library
provided some clues, but even that has changed over time, dropping some
conventions and adopting others. Over the past three years, Swift has evolved at
a high pace, and it has become clearer what idiomatic Swift is.

To someone coming from another language, Swift can resemble everything you like
about your language of choice. Low-level bit twiddling can look very similar to
(and can be as performant as) C, but without many of the undefined behavior
gotchas. The lightweight trailing closure syntax of `map` or `filter` will be
familiar to Rubyists. Swift generics are similar to C++ templates, but with type
constraints to ensure generic functions are correct at the time of definition
rather than at the time of use. The flexibility of higher-order functions and
operator overloading means you can write code that's similar in style to Haskell
or F\#. And the `@objc` and `dynamic` keywords allow you to use selectors and
runtime dynamism in ways you would in Objective-C.

Given these resemblances, it's tempting to adopt the idioms of other languages.
Case in point: Objective-C example projects can almost be mechanically ported to
Swift. The same is true for Java or C\# design patterns. And monad tutorials
appeared to be everyone's favorite blog post topic in the first few months after
Swift's introduction.

But then comes the frustration. Why can't we use protocol extensions with
associated types like interfaces in Java? Why are arrays not covariant in the
way we expect? Why can't we write "functor?" Sometimes the answer is because the
part of Swift in question isn't yet implemented. But more often, it's either
because there's a different Swift-like way to do what you want to do, or because
the Swift feature you thought was like the equivalent in some other language is
not quite what you think.

Swift is a complex language — most programming languages are. But it hides that
complexity well. You can get up and running developing apps in Swift without
needing to know about generics or overloading or the difference between static
and dynamic dispatch. You may never need to call into a C library or write your
own collection type, but after a while, we think you'll find it necessary to
know about these things — either to improve your code's performance, to make it
more elegant or expressive, or just to get certain things done.

Learning more about these features is what this book is about. We intend to
answer many of the "How do I do this?" or "Why does Swift behave like that?"
questions we've seen come up on various forums. Hopefully, once you've read our
book, you'll have gone from being aware of the basics of the language to knowing
about many advanced features and having a much better understanding of how Swift
works. Being familiar with the material presented is probably necessary, if not
sufficient, for calling yourself an advanced Swift programmer.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
