/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
## The Filter Type

*/

// --- (Hidden code block) ---
#if os(macOS)
import Cocoa 
typealias UIColor = NSColor
#else
import UIKit
#endif
// ---------------------------
/*:
One of the key classes in Core Image is the `CIFilter` class, which is used to
create image filters. When you instantiate a `CIFilter` object, you (almost)
always provide an input image via the `kCIInputImageKey` key, and then retrieve
the filtered result via the `outputImage` property. Then you can use this result
as input for the next filter.

In the API we'll develop in this chapter, we'll try to encapsulate the exact
details of these key-value pairs and present a safe, strongly typed API to our
users. We define our own `Filter` type as a function that takes an image as its
parameter and returns a new image:

*/

typealias Filter = (CIImage) -> CIImage

/*:
This is the base type we're going to build upon.

### Building Filters

Now that we have the `Filter` type defined, we can start defining functions that
build specific filters. These are convenience functions that take the parameters
needed for a specific filter and construct a value of type `Filter`. These
functions will all have the following general shape:

``` swift-example
func myFilter(...) -> Filter
```

Note that the return value, `Filter`, is a function as well. Later on, this will
help us compose multiple filters to achieve the image effects we want.

#### Blur

Let's define our first simple filters. The Gaussian blur filter only has the
blur radius as its parameter:

*/

func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur",
            withInputParameters: parameters) 
            else { fatalError() }
        guard let outputImage = filter.outputImage 
            else { fatalError() }
        return outputImage
    }
}

/*:
That's all there is to it. The `blur` function returns a function that takes an
argument `image` of type `CIImage` and returns a new image (`return`
`filter.outputImage`). Because of this, the return value of the `blur` function
conforms to the `Filter` type we defined previously as `(CIImage) -> CIImage`.

Note how we use `guard` statements to unwrap the optional values returned from
the `CIFilter` initializer, as well as from the filter's `outputImage` property.
If any of those values would be `nil`, it'd be a case of a programming error
where we, for example, have supplied the wrong parameters to the filter. Using
the `guard` statement in conjunction with a `fatalError()` instead of just force
unwrapping the optional values makes this intent explicit.

This example is just a thin wrapper around a filter that already exists in Core
Image. We can use the same pattern over and over again to create our own filter
functions.

#### Color Overlay

Let's define a filter that overlays an image with a solid color of our choice.
Core Image doesn't have such a filter by default, but we can compose it from
existing filters.

The two building blocks we're going to use for this are the color generator
filter (`CIConstantColorGenerator`) and the source-over compositing filter
(`CISourceOverCompositing`). Let's first define a filter to generate a constant
color plane:

*/

func generate(color: UIColor) -> Filter {
    return { _ in
        let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
            withInputParameters: parameters) 
            else { fatalError() }
        guard let outputImage = filter.outputImage 
            else { fatalError() }
        return outputImage
    }
}

/*:
This looks very similar to the `blur` filter we've defined above, with one
notable difference: the constant color generator filter doesn't inspect its
input image. Therefore, we don't need to name the image parameter in the
function being returned. Instead, we use an unnamed parameter, `_`, to emphasize
that the image argument to the filter we're defining is ignored.

Next, we're going to define the composite filter:

*/

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing",
            withInputParameters: parameters) 
            else { fatalError() }
        guard let outputImage = filter.outputImage 
            else { fatalError() }
        return outputImage.cropped(to: image.extent)
    }
}

/*:
Here we crop the output image to the size of the input image. This isn't
strictly necessary, and it depends on how we want the filter to behave. However,
this choice works well in the examples we'll cover.

Finally, we combine these two filters to create our color overlay filter:

*/

func overlay(color: UIColor) -> Filter {
    return { image in
        let overlay = generate(color: color)(image).cropped(to: image.extent)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

/*:
Once again, we return a function that takes an image parameter as its argument.
This function starts by generating an overlay image. To do this, we use our
previously defined color generator filter, `generate(color:)`. Calling this
function with a color as its argument returns a result of type `Filter`. Since
the `Filter` type is itself a function from `CIImage` to `CIImage`, we can call
the result of `generate(color:)` with `image` as its argument to compute a new
overlay, `CIImage`.

Constructing the return value of the filter function has the same structure:
first we create a filter by calling `compositeSourceOver(overlay:)`. Then we
call this filter with the input image.

### Composing Filters

Now that we have a blur and a color overlay filter defined, we can put them to
use on an actual image in a combined way: first we blur the image, and then we
put a red overlay on top. Let's load an image to work on:

*/

let url = URL(string: "http://via.placeholder.com/500x500")!
let image = CIImage(contentsOf: url)!

/*:
Now we can apply both filters to these by chaining them together:

*/

let radius = 5.0
let color = UIColor.red.withAlphaComponent(0.2)
let blurredImage = blur(radius: radius)(image)
let overlaidImage = overlay(color: color)(blurredImage)

// --- (Hidden code block) ---
// PLEASE NOTE: the code above doesn't work in playgrounds. However, it does work in a real project. In order to fix the code for the playground, you have to modify the `generate` function above that's used by the `overlay` function. Cropping the returned image as demonstrated below will make the code work in this playground:

func generate_fixedForPlayground(color: UIColor) -> Filter {
    return { image in
        let parameters = [kCIInputColorKey: CIColor(cgColor: color.cgColor)]
        guard let filter = CIFilter(name: "CIConstantColorGenerator",
            withInputParameters: parameters) 
            else { fatalError() }
        guard let outputImage = filter.outputImage 
            else { fatalError() }
        return outputImage.cropped(to: image.extent)
    }
}
// ---------------------------
/*:
Once again, we assemble images by creating a filter, such as `blur(radius:
radius)`, and applying the result to an image.

#### Function Composition

Of course, we could simply combine the two filter calls in the above code in a
single expression:

*/

let result = overlay(color: color)(blur(radius: radius)(image))

/*:
However, this becomes unreadable very quickly with all these parentheses
involved. A nicer way to do this is to build a function that composes two
filters into a new filter:

*/

func compose(filter filter1: @escaping Filter, 
    with filter2: @escaping Filter) -> Filter 
{
    return { image in filter2(filter1(image)) }
}

/*:
The `compose(filter:with:)` function takes two argument filters and returns a
new filter. The resulting composite filter expects an argument `image` of type
`CIImage` and passes it through both `filter1` and `filter2`, respectively.
Here's an example of how we can use `compose(filter:with:)` to define our own
composite filters:

*/

let blurAndOverlay = compose(filter: blur(radius: radius), 
    with: overlay(color: color))
let result1 = blurAndOverlay(image)

/*:
We can go one step further and introduce a custom operator for filter
composition. Granted, defining your own operators all over the place doesn't
necessarily contribute to the readability of your code. However, filter
composition is a recurring task in an image processing library. Once you know
this operator, it'll make filter definitions much more readable:

*/

infix operator >>>

func >>>(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

/*:
Now we can use the `>>>` operator in the same way we used
`compose(filter:with:)` before:

*/

let blurAndOverlay2 = 
    blur(radius: radius) >>> overlay(color: color)
let result2 = blurAndOverlay2(image)

/*:
Since the `>>>` operator is left-associative by default, we can read the filters
that are applied to an image from left to right, just like Unix pipes.

The filter composition operation that we've defined is an example of *function
composition*. In mathematics, the composition of the two functions `f` and `g`,
sometimes written `f ∘ g`, defines a new function mapping an input `x` to
`f(g(x))`. With the exception of the order, this is precisely what our `>>>`
operator does: it passes an argument image through its two constituent filters.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
