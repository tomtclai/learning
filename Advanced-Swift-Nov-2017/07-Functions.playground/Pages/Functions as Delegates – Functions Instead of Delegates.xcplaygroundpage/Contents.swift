/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Functions Instead of Delegates

If the delegate protocol only has a single method defined, we can simply replace
the delegate property with a property that stores the callback function
directly. In our case, this could be an optional `buttonTapped` property, which
is `nil` by default:

*/

class AlertView {
    var buttons: [String]
    var buttonTapped: ((_ buttonIndex: Int) -> ())?
    
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        buttonTapped?(1)
    }
}

/*:
The `(_ buttonIndex: Int) -> ()` notation for the function type is a little
weird because the internal name, `buttonIndex`, isn't relevant anywhere else in
the code. We mentioned above that function types unfortunately can't have
parameter labels; they *can* however have an explicit blank parameter label
combined with an internal argument name. This is the [officially sanctioned
workaround](https://lists.swift.org/pipermail/swift-evolution-announce/2016-July/000233.html)
to give parameters in function types labels for documentation purposes until
Swift supports a better way.

Just like before, we can create a logger struct and then create an alert view
instance and a logger variable:

*/

struct TapLogger {
    var taps: [Int] = []
    
    mutating func logTap(index: Int) {
        taps.append(index)
    }
}

let alert = AlertView()
var logger = TapLogger()

/*:
However, we can't simply assign the `logTap` method to the `buttonTapped`
property. The Swift compiler tells us that "partial application of a 'mutating'
method is not allowed":

``` swift-example
alert.buttonTapped = logger.logTap // Error
```

In the code above, it's not clear what should happen in the assignment. Does the
`logger` get copied? Or should `buttonTapped` mutate the original variable (i.e.
`logger` gets captured)?

To make this work, we have to wrap the right-hand side of the assignment in a
closure. This has the benefit of making it very clear that we're now capturing
the original `logger` variable (not the value) and that we're mutating it:

*/

alert.buttonTapped = { logger.logTap(index: $0) }

/*:
As an additional benefit, the naming is now decoupled: the callback property is
called `buttonTapped`, but the function that implements it is called `logTap`.
Rather than a method, we could also specify an anonymous function:

*/

alert.buttonTapped = { print("Button \($0) was tapped") }

/*:
When combining callbacks with classes, there are some caveats. Let's go back to
our view controller example. In its initializer, instead of assigning itself as
the alert view's delegate, the view controller can now assign its `buttonTapped`
method to the alert view's callback handler:

*/

class ViewController {
    let alert: AlertView
    
    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        alert.buttonTapped = self.buttonTapped(atIndex:)
    }
    
    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}

/*:
The `alert.buttonTapped = self.buttonTapped(atIndex:)` line looks like an
innocent assignment, but beware: we've just created a reference cycle\! Every
reference to an instance method of an object (like `self.buttonTapped` in the
example) implicitly captures the object. To see why this has to be the case,
consider the perspective of the alert view: when the alert view calls the
callback function that's stored in its `buttonTapped` property, the function
must somehow "know" which object's instance method it needs to call — it's not
enough to just store a reference to `ViewController.buttonTapped(atIndex:)`
without knowing the instance.

> We could've shortened `self.buttonTapped(atIndex:)` to `self.buttonTapped` or
> just `buttonTapped`; all three refer to the same function. Parameter labels
> can be omitted as long as doing so doesn't create ambiguities.

It's very easy to accidentally create reference cycles this way. To avoid a
strong reference, it's often necessary to wrap the method call in another
closure that captures the object weakly:

``` swift-example
alert.buttonTapped = { [weak self] index in
    self?.buttonTapped(atIndex: index)
}
```

This way, the alert view doesn't have a strong reference to the view controller.
If we can guarantee that the alert view's lifetime is tied to the view
controller, another option is to use `[unowned self]` instead of `weak`. With
`weak`, should the alert view outlive the view controller, `self` will be `nil`
inside the closure when the function gets called.

> If you check out the type of the expression `ViewController.buttonTapped`,
> you'll notice that it's `(ViewController) -> (Int) -> ()`. What's going on
> there? Under the hood, instance methods are modeled as functions that, given
> an instance, return another function that then operates on the instance.
> `someVC.buttonTapped` is really just another way of writing
> `ViewController.buttonTapped(someVC)` — both expressions return a function of
> type `(Int) -> ()`, and this function is a closure that has strongly captured
> the `someVC` instance.

As we've seen, there are definite tradeoffs between protocols and callback
functions. A protocol adds some verbosity, but a class-only protocol with a weak
delegate removes the need to worry about introducing reference cycles.

Replacing the delegate with a function adds a lot of flexibility and allows you
to use structs and anonymous functions. However, when dealing with classes, you
need to be careful not to introduce a reference cycle.

Also, when you need multiple callback functions that are closely related (for
example, providing the data for a table view), it can be helpful to keep them
grouped together in a protocol rather than having individual callbacks. When
using a protocol, a single type has to implement all the methods.

To unregister a delegate or a function callback, we can simply set it to `nil`.
What about when our type stores an array of delegates or callbacks? With
class-based delegates, we can simply remove an object from the delegate list.
With callback functions, this isn't so simple; we'd need to add extra
infrastructure for unregistering, because functions can't be compared.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
