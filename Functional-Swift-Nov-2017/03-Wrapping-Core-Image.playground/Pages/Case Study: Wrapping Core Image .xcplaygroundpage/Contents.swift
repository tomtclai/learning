/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
# Case Study: Wrapping Core Image 

The previous chapter introduced the concept of *higher-order functions* and
showed how functions can be passed as arguments to other functions. However, the
example used there may seem far removed from the 'real' code that you write on a
daily basis. In this chapter, we'll show how to use higher-order functions to
write a small, functional wrapper around an existing, object-oriented API.

Core Image is a powerful image processing framework, but its API can be a bit
clunky to use at times. The Core Image API is loosely typed — image filters are
configured using key-value coding. It's all too easy to make mistakes in the
type or name of arguments, which can result in runtime errors. The new API we
develop will be safe and modular, exploiting *types* to guarantee the absence of
such runtime errors.

Don't worry if you're unfamiliar with Core Image or can't understand all the
details of the code fragments in this chapter. The goal isn't to build a
complete wrapper around Core Image, but instead to illustrate how concepts from
functional programming, such as higher-order functions, can be applied in
production code.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
