/*:


*/

/*:
# Final Words

We hope you enjoyed this journey through Swift with us.

Despite its young age, Swift is already a complex language. It'd be a daunting
task to cover every aspect of it in one book, let alone expect readers to
remember it all.

We chose the topics for this book largely based on our own interests. What did
we want to know that was missing from the official documentation? How do things
work under the hood? And perhaps even more importantly, why does Swift behave
the way it does?

Even if you don't immediately put everything you learned to practical use, we're
confident that having a better understanding of your language makes you a more
accomplished programmer.

Swift is still changing rapidly. While the era of large-scale source-breaking
changes is probably behind us, there are several areas where we expect major
enhancements in the coming years:

  - The big goal for Swift 5 is achieving [**ABI
    stability**](https://github.com/apple/swift/blob/master/docs/ABIStabilityManifesto.md)
    (application binary interface). This mostly affects internal details like
    memory layouts and calling conventions, but one prerequisite for *ABI*
    stability that affects everyone is finalizing the standard library *API*.
    This is why enhancements to the generics system that the standard library
    can profit from are a major focus for Swift 5.

  - An explicit [**memory ownership
    model**](https://github.com/apple/swift/blob/master/docs/OwnershipManifesto.md)
    will allow developers to annotate function arguments with ownership
    requirements. The goal is to give the compiler all the information it needs
    to avoid unnecessary copies when passing values to functions. We're already
    seeing the first pieces of this in Swift 4 with the introduction of
    compiler-enforced exclusive memory access.

  - Discussions about adding [**first-class concurrency
    support**](https://gist.github.com/lattner/31ed37682ef1576b16bca1432ea9f782)
    to Swift are still in their infancy, and this is a project that will take
    several years to complete. Still, there's a good chance we'll get something
    like the coroutine-based `async`/`await` model that's popular in other
    languages in the not-too-distant future.

If you're interested in shaping how these and other features turn out, remember
that Swift is being developed in the open. Consider joining the [swift-evolution
mailing list](https://swift.org/community/#mailing-lists) and adding your
perspective to the discussions.

Finally, we'd like to encourage you to take advantage of the fact that Swift is
open source. When you have a question the documentation doesn't answer, the
source code can often give you the answer. If you made it this far, you'll have
no problem finding your way through [the standard library source
files](https://github.com/apple/swift/tree/master/stdlib/public/core). Being
able to check how things are implemented in there was a big help for us when
writing this book.

*/

/*:


*/
