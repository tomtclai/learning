/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Discussion

Why care about these things? Does it really matter if you know that some type is
an applicative functor or a monad? We think it does.

Consider the parser combinators from Chapter 12. Defining the correct way to
sequence two parsers isn't easy: it requires a bit of insight into how parsers
work. Yet it's an absolutely essential piece of our library, without which we
couldn't even write the simplest parsers. If you have the insight that our
parsers form an applicative functor, you may realize that the existing `<*>`
provides you with exactly the right notion of sequencing two parsers, one after
the other. Knowing what abstract operations your types support can help you find
such complex definitions.

Abstract notions, like functors, provide important vocabulary. If you ever
encounter a function named `map`, you can probably make a pretty good guess as
to what it does. Without a precise terminology for common structures like
functors, you would have to rediscover each new `map` function from scratch.

These structures give guidance when designing your own API. If you define a
generic enumeration or struct, chances are that it supports a `map` operation.
Is this something you want to expose to your users? Is your data structure also
an applicative functor? Is it a monad? What do the operations do? Once you
familiarize yourself with these abstract structures, you see them pop up again
and again.

Although it's more difficult in Swift than in Haskell, you can define generic
functions that work on any applicative functor. Functions such as the `<^>`
operator on parsers can be defined exclusively in terms of the applicative
`pure` and `<*>` functions. As a result, we may want to redefine them for
*other* applicative functors aside from parsers. In this way, we recognize
common patterns in how we program using these abstract structures; these
patterns may themselves be useful in a wide variety of settings.

The historical development of monads in the context of functional programming is
interesting. Initially, monads were developed in a branch of mathematics known
as *category theory*. The discovery of their relevance to computer science is
generally attributed to @moggi, a fact that was later popularized by Wadler
\[-@wadler-monads-1; -@wadler-monads-2\]. Since then, they've been used by
functional languages such as Haskell to contain side effects and I/O \[@spj\].
Applicative functors were first described by McBride and Paterson
\[-@mcbride-paterson\], although there were many examples already known. A
complete overview of the relation between many of the abstract concepts
described in this chapter can be found in the Typeclassopedia
\[@yorgey-typeclassopedia\].

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
