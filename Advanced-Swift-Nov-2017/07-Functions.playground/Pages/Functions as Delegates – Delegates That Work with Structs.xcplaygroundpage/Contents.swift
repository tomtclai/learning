/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Delegates That Work with Structs

Sometimes we might want to have a delegate protocol that's implemented by a
struct. With the current definition of `AlertViewDelegate`, this is impossible,
because it's a class-only protocol.

We can loosen the definition of `AlertViewDelegate` by not making it a
class-only protocol. Also, we'll mark the `buttonTapped(atIndex:)` method as
`mutating`. This way, a struct can mutate itself when the method gets called:

*/

protocol AlertViewDelegate {
    mutating func buttonTapped(atIndex: Int)
}

/*:
We also have to change our `AlertView` because the `delegate` property can no
longer be weak:

*/

class AlertView {
    var buttons: [String]
    var delegate: AlertViewDelegate?

    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

/*:
If we assign an object to the `delegate` property, the object will be strongly
referenced. Especially when working with delegates, the strong reference means
there's a very high chance that we'll introduce a reference cycle at some point.
However, we can use structs now. For example, we could create a struct that logs
all button taps:

*/

struct TapLogger: AlertViewDelegate {
    var taps: [Int] = []
    mutating func buttonTapped(atIndex index: Int) {
        taps.append(index)
    }
}

/*:
At first, it might seem like everything works well. We can create an alert view
and a logger and connect the two. Alas, if we look at `logger.taps` after an
event is fired, the array is still empty:

*/

let alert = AlertView()
var logger = TapLogger()
alert.delegate = logger
alert.fire()
logger.taps

/*:
When we assigned to `alert.delegate`, Swift made a copy of the struct. So the
`taps` aren't recorded in `logger`, but rather in `alert.delegate`. Even worse,
when we assign the value, we lose the value's type. To get the information back
out, we need to use a conditional type cast:

*/

if let theLogger = alert.delegate as? TapLogger {
    print(theLogger.taps)
}

/*:
Clearly this approach doesn't work well. When using classes, it's easy to create
reference cycles, and when using structs, the original value doesn't get
mutated. In short: delegate protocols don't make much sense when using structs.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
