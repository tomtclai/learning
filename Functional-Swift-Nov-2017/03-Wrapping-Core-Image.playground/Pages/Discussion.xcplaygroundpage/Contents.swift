/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/

/*:
## Discussion

This example illustrates, once again, how we break complex code into small
pieces, which can all be reassembled using function application. The goal of
this chapter was not to define a complete API around Core Image, but instead to
sketch out how higher-order functions and function composition can be used in a
more practical case study.

Why go through all this effort? It's true that the Core Image API is already
mature and provides all the functionality you might need. But in spite of this,
we believe there are several advantages to the API designed in this chapter:

  - **Safety** — using the API we've sketched, it's almost impossible to create
    runtime errors arising from undefined keys or failed casts.

  - **Modularity** — it's easy to compose filters using the `>>>` operator.
    Doing so allows you to tease apart complex filters into smaller, simpler,
    reusable components. Additionally, composed filters have the exact same type
    as their building blocks, so you can use them interchangeably.

  - **Clarity** — even if you've never used Core Image, you should be able to
    assemble simple filters using the functions we've defined. You don't need to
    worry about initializing certain keys, such as `kCIInputImageKey` or
    `kCIInputRadiusKey`. From the types alone, you can almost figure out how to
    use the API, even without further documentation.

Our API presents a series of functions that can be used to define and compose
filters. Any filters that you define are safe to use and reuse. Each filter can
be tested and understood in isolation. We believe these are compelling reasons
to favor the design sketched here over the original Core Image API.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents)

*/
