/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## Themes

We've organized the book under the heading of basic concepts. There are in-depth
chapters on some fundamental basic concepts like optionals or strings, and some
deeper dives into topics like C interoperability. But throughout the book,
hopefully a few themes regarding Swift emerge:

**Swift is both a high- and low-level language.** Swift allows you to write code
similarly to Ruby and Python, with `map` and `reduce`, and to write your own
higher-order functions easily. Swift also allows you to write fast code that
compiles directly to native binaries with performance similar to code written in
C.

What's exciting to us, and what's possibly the aspect of Swift we most admire,
is that you're able to do both these things *at the same time*. Mapping a
closure expression over an array compiles to the same assembly code as looping
over a contiguous block of memory does.

However, there are some things you need to know about to make the most of this
feature. For example, it will benefit you to have a strong grasp on how structs
and classes differ, or an understanding of the difference between dynamic and
static method dispatch. We'll cover topics such as these in more depth later on.

**Swift is a multi-paradigm language.** You can use it to write object-oriented
code or pure functional code using immutable values, or you can write imperative
C-like code using pointer arithmetic.

This is both a blessing and a curse. It's great, in that you have a lot of tools
available to you, and you aren't forced into writing code one way. But it also
exposes you to the risk of writing Java or C or Objective-C in Swift.

Swift still has access to most of the capabilities of Objective-C, including
message sending, runtime type identification, and key-value observation. But
Swift introduces many capabilities not available in Objective-C.

Erik Meijer, a well-known programming language expert, [tweeted the following in
October 2015](https://twitter.com/headinthebox/status/655407294969196544):

> At this point, @SwiftLang is probably a better, and more valuable, vehicle for
> learning functional programming than Haskell.

Swift is a good introduction to a more functional style through its use of
generics, protocols, value types, and closures. It's even possible to write
operators that compose functions together. The early months of Swift brought
many functional programming blog posts into the world. But since the release of
Swift 2.0 and the introduction of protocol extensions, this trend has shifted.

**Swift is very flexible.** In the introduction to the book [*On
Lisp*](http://www.paulgraham.com/onlisp.html), Paul Graham writes that:

> Experienced Lisp programmers divide up their programs differently. As well as
> top-down design, they follow a principle which could be called bottom-up
> design-- changing the language to suit the problem. In Lisp, you don't just
> write your program down toward the language, you also build the language up
> toward your program. As you're writing a program you may think "I wish Lisp
> had such-and-such an operator." So you go and write it. Afterward you realize
> that using the new operator would simplify the design of another part of the
> program, and so on. Language and program evolve together.

Swift is a long way from Lisp. But still, we feel like Swift shares this
characteristic of encouraging "bottom-up" programming — of making it easy to
write very general reusable building blocks that you then combine into larger
features, which you then use to solve your actual problem. Swift is particularly
good at making these building blocks feel like primitives — like part of the
language. A good demonstration of this is that the many features you might think
of as fundamental building blocks, like optionals or basic operators, are
actually defined in a library — the Swift standard library — rather than
directly in the language. Trailing closures enable you to extend the language
with features that feel like they're built in.

**Swift code can be compact and concise while still being clear.** Swift lends
itself to relatively terse code. There's an underlying goal here, and it isn't
to save on typing. The idea is to get to the point quicker and to make code
readable by dropping a lot of the "ceremonial" boilerplate you often see in
other languages that obscure rather than clarify the meaning of the code.

For example, type inference removes the clutter of type declarations that are
obvious from the context. Semicolons and parentheses that add little or no value
are gone. Generics and protocol extensions encourage you to avoid repeating
yourself by packaging common operations into reusable functions. The goal is to
write code that's readable at a glance.

At first, this can be off-putting. If you've never used functions like `map`,
`filter`, and `reduce` before, they might look harder to read than a simple
`for` loop. But our hope is that this is a short learning curve and that the
reward is code that is more "obviously correct" at first glance.

**Swift tries to be as safe as is practical, until you tell it not to be.** This
is unlike languages such as C and C++ (where you can be unsafe easily just by
forgetting to do something), or like Haskell or Java (which are sometimes safe
whether or not you like it).

Eric Lippert, one of the principal designers of C\#,
[wrote](http://www.informit.com/articles/article.aspx?p=2425867) about his 10
regrets of C\#, including the lesson that:

> sometimes you need to implement features that are only for experts who are
> building infrastructure; those features should be clearly marked as
> dangerous—not invitingly similar to features from other languages.

Eric was specifically referring to C\#'s finalizers, which are similar to C++
destructors. But unlike destructors, they run at a nondeterministic time
(perhaps never) at the behest of the garbage collector (and on the garbage
collector's thread). However, Swift, being reference counted, *does* execute a
class's `deinit` deterministically.

Swift embodies this sentiment in other ways. Undefined and unsafe behavior is
avoided by default. For example, a variable can't be used until it's been
initialized, and using out-of-bounds subscripts on an array will trap, as
opposed to continuing with possibly garbage values.

There are a number of "unsafe" options available (such as the `unsafeBitcast`
function, or the `UnsafeMutablePointer` type) for when you really need them. But
with great power comes great undefined behavior. You can write the following:

``` swift-example
var someArray = [1,2,3]
let uhOh = someArray.withUnsafeBufferPointer { ptr in
    // ptr is only valid within this block, but
    // there is nothing stopping you letting it
    // escape into the wild:
    return ptr
}
// Later...
print(uhOh[10])
```

It'll compile, but who knows what it'll do. However, you can't say nobody warned
you.

**Swift is an opinionated language.** We as authors have strong opinions about
the "right" way to write Swift. You'll see many of them in this book, sometimes
expressed as if they're facts. But they're just, like, our opinions, man. Feel
free to disagree\! Swift is still a young language, and many things aren't
settled. What's more is that many blog posts are flat-out wrong or outdated
(including several ones we wrote, especially in the early days). Whatever you're
reading, the most important thing is to try things out for yourself, check how
they behave, and decide how you feel about them. Think critically, and beware of
out-of-date information.

**Swift continues to evolve.** The period of major yearly syntax changes may be
behind us, but important areas of the language are still new (strings), in flux
(the generics system), or haven't been tackled yet (concurrency).

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
