/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/

/*:
### Change Observers

As we saw in the chapter on structs and classes, we can also implement the
`willSet` and `didSet` handlers for properties and variables to get called every
time a property is set (even if the value doesn't change). These get called
immediately before and after the new value is stored, respectively. One useful
case is when working with Interface Builder: we can implement `didSet` to know
when an `IBOutlet` gets connected, and then perform additional configuration in
the handler. For example, if we want to set a label's text color once it's
available, we can do the following:

*/

class SettingsController: UIViewController {
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.textColor = .black
        }
    }
}

/*:
The observers have to be defined at the declaration site of a property — you
can't add one retroactively in an extension. They are therefore a tool for the
*designer* of the type, and not the *user*. The `willSet` and `didSet` handlers
are essentially shorthand for defining a pair of properties: one private stored
property that provides the storage, and a public computed property whose setter
performs additional work before and/or after storing the value in the stored
property. This is fundamentally different from the [key-value
observing](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html)
mechanism in Foundation, which is often used by *consumers* of an object to
observe internal changes, whether or not the class's designer intended this.

You *can* override a property in a subclass to add an observer, however. Here's
an example:

*/

class Robot {
    enum State {
        case stopped, movingForward, turningRight, turningLeft
    }
    var state = State.stopped
}

class ObservableRobot: Robot {
    override var state: State {
        willSet {
            print("Transitioning from \(state) to \(newValue)")
        }
    }
}

var robot = ObservableRobot()
robot.state = .movingForward

/*:
This is still consistent with the nature of change observers as an internal
characteristic of a type. If it weren't allowed, a subclass could achieve the
same effect by overriding a stored property with a computed setter that performs
additional work.

The difference in usage is reflected in the implementation of these features.
KVO uses the Objective-C runtime to dynamically add an observer to a class's
setter, which would be impossible to implement in current Swift, especially for
value types. Swift's property observers are a purely compile-time feature.

*/

/*:
[Previous Page](@previous) • [Table of Contents](Table%20of%20Contents) • [Next
Page](@next)

*/
