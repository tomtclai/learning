/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Delegates, Foundation-Style

Let's start off by creating a protocol in the same way that Cocoa defines its
countless delegate protocols. Most programmers who come from Objective-C have
written code like this many times over:

*/

protocol AlertViewDelegate: AnyObject {
    func buttonTapped(atIndex: Int)
}

/*:
It's defined as a class-only protocol because we want our `AlertView` class to
hold a weak reference to the delegate. This way, we don't have to worry about
reference cycles. An `AlertView` will never strongly retain its delegate, so
even if the delegate (directly or indirectly) has a strong reference to the
alert view, all is well. If the delegate is deinitialized, the `delegate`
property will automatically become `nil`:

*/

class AlertView {
    var buttons: [String]
    weak var delegate: AlertViewDelegate?

    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

/*:
This pattern works really well when we're dealing with classes. For example,
suppose we have a `ViewController` class that initializes the alert view and
sets itself as the delegate. Because the delegate is marked as `weak`, we don't
need to worry about reference cycles:

*/

class ViewController: AlertViewDelegate {
    let alert: AlertView

    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        alert.delegate = self
    }

    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}

/*:
It's common practice to always mark delegate properties as `weak`. This
convention makes reasoning about the memory management very easy. Classes that
implement the delegate protocol don't have to worry about creating a reference
cycle.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
